#!/usr/bin/env bash
# This script is used on Lunux systems to start X windows.
#export DISPLAY=valen:0

# First things first.  Not all distros load .Xresources automatically, so load them here
xrdb -merge ~/.Xresources

# Next, figure out what our display resolution is and set some variables accordingly.  Start with
# defaults.
left_xterm_offset=1
right_xterm_offset=800
char_width=100
# Wait a couple of seconds for the resolution to get stable...
sleep 2
screen_width=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $3}')
screen_height=$(xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $4}')

#On ultrawides, we want our xterms more centered.
if [ "$screen_width" -gt "3000" ]; then
    # We need 20 per character...
	#left_xterm_offset=800
	left_xterm_offset=620
	right_xterm_offset=1600
fi

# KDE needs Cairo Dock.   Gnome doesn't
if [ "$XDG_CURRENT_DESKTOP" == "KDE" ]; then
    #cairo-dock --opengl --keep-above &
    cairo-dock --cairo --keep-above -f &
fi

#top left
sleep 2
${HOME}/bin/xt green "xterm-1" "${char_width}x24+${left_xterm_offset}+2"

# Bottom Right.
sleep 2
${HOME}/bin/xt green "xterm-2" "${char_width}x24+${right_xterm_offset}-1"

# Top Right.
sleep 2
${HOME}/bin/xt gold "xterm-3" "${char_width}x24+${right_xterm_offset}+1"

# Bottom Left
sleep 2
${HOME}/bin/xt purple "xterm-4" "${char_width}x24+${left_xterm_offset}-1"

sleep 2
thunderbird &

sleep 2
# Start MuCommander.  It needs java 9+, regardless of what SDKMan is doing...
old_java_home=$JAVA_HOME
/opt/mucommander/mucommander.sh &
JAVA_HOME=$old_java_home

sleep 2
if [ -f "/opt/wine/drive_c/multimedia/winamp/winamp.exe" ]; then
	env WINEPREFIX="/opt/wine" wine C:\\windows\\command\\start.exe /Unix /opt/wine/dosdevices/c:/multimedia/winamp/winamp.exe
fi

sleep 2
firefox &

sleep 3
# There are two ways to install VirtualBox, and unfortunately, they don't use
# the same executable.  Try to detect which one is used.
virtualbox_exec=virtualbox
type $virtualbox_exec > /dev/null 2>&1
if [ $? -ne 0 ]; then
    virtualbox_exec=VirtualBox
fi

# There is a bug in VirtualBox that causes bad flickering in Windows guests 
# when there is an Nividia card installed, but they provided a workaround via
# an environment variable.  Set that variable here, if we can detect an nvidia
# card.
using_nvidia=$(/sbin/lspci | /bin/grep -i nvidia | wc -l)
if [ "$using_nvidia" == "0" ]; then
	# No Nvidia card, just start VirtualBox
	$virtualbox_exec &
else 
	# We have an Nvidia card, work around that pesky flicker
	CR_RENDER_FORCE_PRESENT_MAIN_THREAD=0 $virtualbox_exec &
fi

# Start conky last to give the screen time to adjust to large monitors.
conky &
