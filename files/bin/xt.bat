@echo on
rem This is a helper script that encapsulates the xterm command.
rem We need this because run.exe has a limit to the number of
rem command args passed.
setlocal
rem C:
rem chdir C:\Utilities\cygwin\bin
SET CYGWIN_ROOT=c:\Utilities\cygwin
SET PATH=.;%CYGWIN_ROOT%\bin;%CYGWIN_ROOT%\usr\X11R6\bin;%PATH%
set DISPLAY=127.0.0.1:0
SET FG=green
SET BG=black
SET COLOR=%1
SET NAME=%2
SET GEOM=%3
set font=-adobe-courier-medium-r-normal--14-140-75-75-m-90-iso8859-1

if not defined COLOR set COLOR="green"
if %COLOR% == aqua SET FG=cyan
if %COLOR% == purple SET FG="#f3f"
if %COLOR% == gold SET FG=gold
if %COLOR% == cyan SET FG=cyan 
if %COLOR% == cyan SET BG=navy
if not defined NAME SET NAME="xterm"
if not defined GEOM SET GEOM="80x24+10+10"

echo 1=%1
echo 2=%2
echo 3=%3
xterm -pc -ls -sb -sl 80 -fg %FG% -bg %BG% -ms "#f3b" -cr "#f3b" -fn %font% -geometry %GEOM% -T %NAME% 
