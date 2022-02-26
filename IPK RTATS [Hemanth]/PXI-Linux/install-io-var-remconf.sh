#!/bin/bash

function usage() {
	cat <<EOF
Usage: $(basename "$0") EXPORT_PATH USER@HOSTNAME [USER@HOSTNAME ...]
EXPORT_PATH = Path to IO Variable Remote Configuration export. See example below.
Example: $(basename "$0") /mnt/penguinExports/iak/web/webservices/RemoteConfigWebService/export/18.0/18.0.0f0 admin@rtosrack1-a5-9030
EOF
	exit ${1:-2}
}

if [ $# -lt 2 ]; then
	usage 2
fi

declare path_to_export="$1"
if [ -z "$path_to_export" ]; then
	usage 2
fi

expected_arch_specific_files="libNI_VariableRemConf.so libNI_VariableRemConf_dll.so"
expected_arch_agnostic_files="WebService.ini"

########
# MAIN #
########
# 1: path to directory containing files in extracted export archive for Linux
# 2: username@hostname
# 3: file list
# 4: target file location
function process_shared_library_file_list() {

	for file in $3; do
		super-echo "Copying RTImages contents to $2"
		base_so_major_minor_tiny=$(ls -1 $1 | grep "$file".*.0.0$)
		base_so_major=$(echo $base_so_major_minor_tiny | cut -d'.' -f1-3)
		base_so=$file
		scp -o LogLevel=Error $1/$base_so_major_minor_tiny "$2:$4" || return $?

		super-echo "Creating symlinks for shared libraries on $2"
		ssh -o LogLevel=Error $2 "rm $4/$base_so"
		ssh -o LogLevel=Error $2 "rm $4/$base_so_major"
		ssh -o LogLevel=Error $2 "ln -s $4/$base_so_major_minor_tiny $4/$base_so" || return $?
		ssh -o LogLevel=Error $2 "ln -s $4/$base_so_major_minor_tiny $4/$base_so_major" || return $?
	done
}

# 1: path to directory containing files in extracted export archive for Linux
# 2: username@hostname
# 3: file list
# 4: target file location
function process_basic_file_list() {

	for file in $3; do
		super-echo "Copying RTImages contents to $2"
		scp -o LogLevel=Error $1/$file "$2:$4" || return $?

	done
}

# 1: path to export
# 2: path to extracted Linux archive from export
# 3: username@hostname
function process() {
	# try to copy id, just so we don't have to keep authorizing passwords
	ssh-copy-id "$3"

	ssh -o LogLevel=Error $3 "uname -a | grep x86_64"
	if [ $? == 0 ]; then
		archdir="x64"
	else
		ssh -o LogLevel=Error $3 "uname -a | grep armv7"
		if [ $? == 0 ]; then
			archdir="armv7-a"
		else
			super-echo "ERROR: Could not determine architecture of $3! Exiting..."
			return -2
		fi
	fi
	super-echo "Architecture of $3 is $archdir"

	ssh -o LogLevel=Error $3 "mkdir -p /var/local/natinst/webservices/NI/ni_variable_ioremconf"
	process_shared_library_file_list $2/targets/linuxU/$archdir/gcc-4.7-oe/release $3 "libNI_VariableRemConf.so" /var/local/natinst/webservices/NI/ni_variable_ioremconf || return $?
	process_shared_library_file_list $2/targets/linuxU/$archdir/gcc-4.7-oe/release $3 "libNI_VariableRemConf_dll.so" /usr/local/natinst/labview || return $?
	process_basic_file_list $1/config $3 "WebService.ini" /var/local/natinst/webservices/NI/ni_variable_ioremconf || return $?
	
	super-echo "Rebooting $3"
	ssh -o LogLevel=Error "$3" "reboot" || return $?

	return 0
}

function super-echo() {
	printf "##----------------------------------------------------------\n"
	echo "## $@"
	printf "##----------------------------------------------------------\n"
}

# 1: list of files
# 2: directory containining export files being checked
function check_target_files_against_list() {
	num_files_found=0
	for file in $1; do
		if ls $2 | grep $file > /dev/null; then
			num_files_found=$((num_files_found+1))
		else
			super-echo "ERROR: File has been removed from export. This script needs to be updated. Exiting..."
			return -2
		fi
	done
}

failed=0
super-echo "Unzipping Linux archive"
unzipped=$(mktemp -d)
unzip -q $path_to_export/.archives/linux.zip -d $unzipped

set -e
check_target_files_against_list "$expected_arch_specific_files" $unzipped/targets/linuxU/armv7-a/gcc-4.7-oe/release/
check_target_files_against_list "$expected_arch_agnostic_files" $path_to_export/config/
num_arch_specific_files_in_export=$(ls "$unzipped"/targets/linuxU/armv7-a/gcc-4.7-oe/release/*.0.0 | wc -l)
num_arch_specific_files_expected=$(echo "$expected_arch_specific_files" | wc -w)
if [ "$num_arch_specific_files_in_export" != "$num_arch_specific_files_expected" ]; then
	super-echo "ERROR: Files have been added to the export. This script needs to be updated. Exiting..."
	failed=1
fi
set +e

for creds in ${@:2}; do
	if [ "$failed" -eq "0" ]; then
		process $path_to_export "$unzipped" "$creds" || failed=1
	fi
done

if [ "$failed" -eq "0" ]; then
	super-echo "SUCCESS!"
else
	super-echo "FAILURE! - See output above for details"
fi	
exit ${failed}
