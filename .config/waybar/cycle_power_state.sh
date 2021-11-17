#!/bin/bash -e

current=$(powerprofilesctl get)

if [ $current = "performance" ]; then
	current="balanced"
elif [ $current = "balanced" ]; then
	current="power-saver"
elif [ $current = "power-saver" ]; then
	current="performance"
fi

powerprofilesctl set "$current"

pkill -SIGRTMIN+8 waybar
