#!/bin/bash
#export DISPLAY=valen:0
XTERM=~steve/bin/xt

conky &

#top left
xt green "xterm-1" "80x24+2+2"

# Bottom Right We need padding to get past the Office bar
sleep 2
xt green "xterm-2" "80x24+800-1"

sleep 2
# Top Right We need padding to get past the Office bar
xt gold "xterm-3" "80x24+800+1"

sleep 2
# Bottom Left
xt purple "xterm-4" "80x24+1-1"

/opt/mucommander-0.9.0/mucommander.sh &
sleep 2

sleep 2
firefox &

sleep 2
virtualbox &


