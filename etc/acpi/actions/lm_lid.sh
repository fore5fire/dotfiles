#! /bin/sh

# Query all sway IPC sockets, if any has multiple displays then don't restart
for sock in /tmp/1000-runtime-dir/sway-ipc.*.sock; do
	if [ "$(swaymsg --socket=$sock -t get_outputs | jq length)" -gt "1" ]; then
		exit 0
	fi
done

/sbin/shutdown 0 -hP "lid closed"

#test -f /lib/udev/lmt-udev || exit 0

# lid button pressed/released event handler
#/lib/udev/lmt-udev
