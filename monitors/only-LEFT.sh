#! /bin/bash
xrandr --newmode "2560x1080_58.00"  222.00  2560 2720 2992 3424  1080 1083 1093 1119 -hsync +vsync
xrandr --addmode HDMI1 2560x1080_58.00
xrandr --output eDP1 --noprimary --off
xrandr --auto --output HDMI1 --mode 2560x1080_58.00 --primary --pos 0x0 --output eDP1 1366x768 --pos 2560x0
