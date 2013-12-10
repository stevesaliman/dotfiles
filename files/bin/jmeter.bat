rem @echo off

rem C:
chdir C:\utilities\cygwin
SET CYGWIN_ROOT=C:\utilities\cygwin
SET PATH=.;%CYGWIN_ROOT%\bin;%CYGWIN_ROOT%\usr\X11R6\bin;%PATH%
set DISPLAY=127.0.0.1:0
rem Top Left
rem run xterm -pc -ls -sb -sl 80 -fg green -bg black -ms "#f3b" -cr "#f3b" -geometry 80x24+2+2 -n "1" -e "tcsh -l"
run c:\network\jmeter-2.9\bin\jmeter.bat
