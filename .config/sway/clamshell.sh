#!/usr/bin/bash

laptop_screen=eDP-1

if grep -q open /proc/acpi/button/lid/LID0/state; then
    swaymsg output $laptop_screen enable
else
    swaymsg output $laptop_screen disable
fi
