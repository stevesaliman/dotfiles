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
profile directory.
