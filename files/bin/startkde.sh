#!/bin/bash
# This script is used on Lunux systems to start X windows.
#export DISPLAY=valen:0

# First things first.  Figure out what our display resolution is and set some
# variables accordingly.  Start with defaults.
left_xterm_offset=1
right_xterm_offset=800
# Wait a couple of seconds for the resolution to get stable...
sleep 2
screen_width=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $3}')
screen_height=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $4}')

#On ultrawides, we want our xterms more centered.
if [ "$screen_width" -gt "3000" ]; then
	left_xterm_offset=800
	right_xterm_offset=1600
fi

#cairo-dock --opengl --keep-above &
cairo-dock --cairo --keep-above &

#top left
sleep 2
xt green "xterm-1" "80x24+${left_xterm_offset}+2"

# Bottom Right.
sleep 2
xt green "xterm-2" "80x24+${right_xterm_offset}-1"

# Top Right.
sleep 2
xt gold "xterm-3" "80x24+${right_xterm_offset}+1"

# Bottom Left
sleep 2
xt purple "xterm-4" "80x24+${left_xterm_offset}-1"

sleep 2
thunderbird &

sleep 2
/opt/mucommander-0.9.3/mucommander.sh &

sleep 2
if [ -f "/opt/wine/drive_c/multimedia/winamp/winamp.exe" ]; then
	env WINEPREFIX="/opt/wine" wine C:\\windows\\command\\start.exe /Unix /opt/wine/dosdevices/c:/multimedia/winamp/winamp.exe
fi

sleep 2
firefox &

sleep 3
virtualbox &

# Start conky last to give the screen time to adjust to large monitors.
conky &
