rem @echo off
rem this script start the 4 standard windows.

rem C:
chdir C:\utilities\cygwin
SET CYGWIN_ROOT=C:\utilities\cygwin
SET PATH=.;%CYGWIN_ROOT%\bin;%CYGWIN_ROOT%\usr\bin;%CYGWIN_ROOT%\usr\X11R6\bin;%PATH%;%HOME%\bin
set DISPLAY=127.0.0.1:0
rem Top Left
run xt.bat green "xterm-1" "80x24+2+2"

rem rem Bottom Right We need padding to get past the Office bar
sleep 2
run xt.bat green "xterm-2" "80x24+800-1"

sleep 2
rem rem Top Right We need padding to get past the Office bar
run xt.bat gold "xterm-3" "80x24+800+1"

sleep 2
rem rem Bottom Left
run xt.bat purple "xterm-4" "80x24+1-1"
