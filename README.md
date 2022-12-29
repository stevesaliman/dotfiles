This project contains all the environment customizations for Unix like 
environments, and provides an easy way to make sure all the boxes I use have a
consistent setup.

There are 3 main directories here:

*files*
This directory contains all the files that should be the same on all boxes,
whether they are Linux, OSX, or Cygwin.  The files here contain all the 
customizations to Bash, ssh configuration, Git, etc.  They are installed with
the `install.sh` script, which copies files to the same location under the home
directory.

*gui*
This directory contains all the themes and icons for a Linux GUI environment.
They are installed with the `install_gui.sh` script, which copies files to the
same location under the home directory.

*firefox*
This directory contains customizations for Firefox.  They are installed with 
the `install_firefox.sh` script, which takes a Firefox profile directory as
an argument. The script copies files to the same location under the Firefox
profile directory.  Note that most of the hacks here came from the 
https://github.com/Aris-t2/CustomCSSforFx project.  If things don't work in the
latest version of Firefox, this project is a great place to start the
troubleshooting process.

Notes:
- The signal-reset program came from https://github.com/thomaslee/signal-reset, and is used to work
  around https://youtrack.jetbrains.com/issue/IDEA-157989.

