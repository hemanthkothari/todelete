#!/bin/bash

function usage() {
	cat <<EOF
$(basename "$0") <arm|x64> user@hostname [user@hostname ...]
EOF
	exit ${1:-2}
}

if [ $# -lt 2 ]; then
	usage 2
fi

declare arch="$1"
if [ -z "${arch}" ]; then
	usage 2
fi

########
# MAIN #
########

# 1: architecture type
# 2: username@hostname
function fixup() {
	# try to copy id, just so we don't have to keep authorizing passwords
	ssh-copy-id "$2"

	set -e
	
	super-echo "Installing vsftpd..."
	ssh "$2" "opkg update && opkg install vsftpd" || return $?

	super-echo "Ruinning FTP security..."
	scp ./vsftpd-unsafe.conf "${2}:/etc/vsftpd.conf" || return $?

	super-echo "Restarting vsftpd..."
	ssh "$2" "/etc/init.d/vsftpd restart" || return $?

	if [ "$1" == "x64" ]; then
		super-echo "Enabling Embedded UI..."
		ssh "$2" "nirtcfg --set section=systemsettings,token=ui.enabled,value=True" || return $?
	fi

	super-echo "Restarting..."
	ssh "$2" "reboot" || return $?

	set +e
	return $?
}

function super-echo() {
	printf "##---\n"
	echo $@
	printf "##---\n"
}

failed=0
for creds in ${@:2}; do
	fixup "$arch" "$creds" || failed=1
done

exit ${failed}
