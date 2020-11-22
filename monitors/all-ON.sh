#! /bin/bash

xrandr --newmode "2560x1080_56.00"  213.25  2560 2720 2984 3408  1080 1083 1093 1118 -hsync +vsync
xrandr --addmode HDMI1 2560x1080_56.00
xrandr --auto --output HDMI1 --mode 2560x1080_56.00 --primary  
xrandr --auto --output eDP1 --right-of HDMI1 --noprimary
