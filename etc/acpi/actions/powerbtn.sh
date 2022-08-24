#!/bin/sh
if [ $2 = "PNP0C0C:00" ]; then
	for sock in /tmp/*-runtime-dir/sway-ipc.*.sock; do
		swaymsg exec 'swaylock -f' --socket "$sock" || 0
	done
	sleep 0.2
	acpitool --suspend
fi
