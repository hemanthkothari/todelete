#!/bin/bash

function usage() {
	cat <<EOF
Usage: $(basename "$0") path_to_greenwayio_export user@hostname [user@hostname ...]
Example: $(basename "$0") /mnt/penguinExports/labviewrt/Industrial/testStack/export/3.6/3.6.0f1 admin@rtosrack1-a5-9030
EOF
	exit ${1:-2}
}

if [ $# -lt 2 ]; then
	usage 2
fi

declare greenway_export="$1"
if [ -z "$greenway_export" ]; then
	usage 2
fi

expected_target_handlers="libsimIOAssemblyHandler.so"
expected_target_plugins="libonBoardIOPlugin.so libsimIOPlugin.so"

########
# MAIN #
########
# 1: path to extracted greenway IO export for Linux
# 2: username@hostname
# 3: archdir
# 4: file list
# 5: target file location
function process_file_list() {

	for file in $4; do
		super-echo "Copying RTImages contents to $2"
		base_so_major_minor_tiny=$(ls -1 $1/RTImages/TestIO/Linux/$archdir | grep $file)
		base_so_major=$(echo $base_so_major_minor_tiny | cut -d'.' -f1-3)
		base_so=$file
		scp -o LogLevel=Error $1/RTImages/TestIO/Linux/$archdir/$base_so_major_minor_tiny "$2:$5" || return $?

		super-echo "Creating symlinks for shared libraries on $2"
		ssh -o LogLevel=Error $2 "rm $5/$base_so"
		ssh -o LogLevel=Error $2 "rm $5/$base_so_major"
		ssh -o LogLevel=Error $2 "ln -s $5/$base_so_major_minor_tiny $5/$base_so" || return $?
		ssh -o LogLevel=Error $2 "ln -s $5/$base_so_major_minor_tiny $5/$base_so_major" || return $?
	done
}

# 1: path to extracted greenway IO export for Linux
# 2: username@hostname
function process() {
	# try to copy id, just so we don't have to keep authorizing passwords
	ssh-copy-id "$2"

	ssh -o LogLevel=Error $2 "uname -a | grep x86_64"
	if [ $? == 0 ]; then
		archdir="x64"
	else
		ssh -o LogLevel=Error $2 "uname -a | grep armv7"
		if [ $? == 0 ]; then
			archdir="armv7-a"
		else
			super-echo "ERROR: Could not determine architecture of $2! Exiting..."
			return -2
		fi
	fi
	super-echo "Architecture of $2 is $archdir"

    # PXI Linux RT targets are missing this directory, so create it here.
    ssh -o LogLevel=Error $2 "mkdir -p /usr/local/natinst/share/ScanEngine/ioplugins"

	process_file_list $1 $2 $archdir "$expected_target_handlers" /usr/local/natinst/share/deployfwk/handlers || return $?
	process_file_list $1 $2 $archdir "$expected_target_plugins" /usr/local/natinst/share/ScanEngine/ioplugins || return $?
	
	super-echo "Creating entry to load libsimIOAssemblyHandler.so on $2"	
	ssh -o LogLevel=Error $2 "/usr/local/natinst/bin/nirtcfg -s section=NIDP_HANDLER_LOAD_ORDER,token=libnilvicv_deployhandler.so,value=libsimIOAssemblyHandler.so -f /usr/local/natinst/share/deployfwk/handlers/loadOrder.ini" || return $?

	super-echo "Rebooting $2"
	ssh -o LogLevel=Error "$2" "reboot" || return $?

	return 0
}

function super-echo() {
	printf "##----------------------------------------------------------\n"
	echo "## $@"
	printf "##----------------------------------------------------------\n"
}

function check_target_files_against_list() {
	num_files_found=0
	for file in $1; do
		if ls $unzipped/RTImages/TestIO/Linux/armv7-a/ | grep $file > /dev/null; then
			num_files_found=$((num_files_found+1))
		else
			super-echo "ERROR: File has been removed from Greenway export. This script needs to be updated. Exiting..."
			return -2
		fi
	done
}

failed=0
super-echo "Unzipping Greenway IO Linux archive"
unzipped=$(mktemp -d)
unzip -q $greenway_export/.archives/linux.zip -d $unzipped

set -e
check_target_files_against_list "$expected_target_handlers"
check_target_files_against_list "$expected_target_plugins"
num_files_in_export=$(ls "$unzipped"/RTImages/TestIO/Linux/armv7-a/ | wc -l)
num_handlers_expected=$(echo "$expected_target_handlers" | wc -w)
num_plugins_expected=$(echo "$expected_target_plugins" | wc -w)
num_files_expected=$((num_handlers_expected+num_plugins_expected))
if [ "$num_files_in_export" != "$num_files_expected" ]; then
	super-echo "ERROR: Files have been added to Greenway export. This script needs to be updated. Exiting..."
	failed=1
fi
set +e

for creds in ${@:2}; do
	if [ "$failed" -eq "0" ]; then
		process "$unzipped" "$creds" || failed=1
	fi
done

if [ "$failed" -eq "0" ]; then
	super-echo "SUCCESS!"
else
	super-echo "FAILURE! - See output above for details"
fi	
exit ${failed}
