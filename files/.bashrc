# There are 3 different types of shells in bash: the login shell, normal shell and interactive
# shell. Login shells read ~/.profile and interactive shells read ~/.bashrc; in our setup,
# /etc/profile sources ~/.bashrc - thus all settings made here will also take effect in a login
# shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than here, since
# multilingual X sessions would not work properly if LANG is overridden in every subshell.

# This file works in 6 basic steps:
#
# 1. Load system files, set shell options, and set up a very basic path with things we'll need in
# the rest of the script
#
# 2. Load variables, and process local overrides to the variables.
#
# 3. Load the default alises and functions
#
# 4. Load the configuration fragments from the bash.d directory. In general, configuration fragments
#   are for things that are installed after the basic OS install, or which have complex
#   configurations like Docker.
#
# 5. Set up auto completion
#
# 6. Finalize pathing and other things like LD_LIBRARY PATH.

# Load in the system profile, if we have one.
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi
if [ -f /etc/profile ]; then
    . /etc/profile
fi

# if we aren't in an interactive shell, just bail here.
case $- in
    *i*) ;;
      *) return;;
esac

# Set bash options, starting with the one that checks for background jobs before exiting.
if [[ $BASH_VERSION > 4 ]]; then
    shopt -s checkjobs
fi
# check the window size after each command and update the values of LINES and COLUMNS if necessary.
shopt -s checkwinsize
# Include dotfiles when globbing (expanding wildcards)
shopt -s dotglob
# append to the history file, don't overwrite it
shopt -s histappend

# Trap the shell exit and kill ssh-agent when it exits
trap _stop_ssh_agent EXIT SIGTERM

# Fix terminal oddities
stty erase 
stty intr 
stty kill 
# Turn off the ctrl-s "freezing" behavior
stty -ixon
umask 022

# Next, figure out what OS and machine I'm on, so we can make os-specific aliases, paths, etc.
os_type=$(uname)
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME=`/bin/hostname`
fi

# Next, set up a basic path that works for all environments. This is needed to execute the rest of
# this script which uses things like uname, grep, etc.  We always want our own bin at the front of
# the path.
export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin
export PATH=$PATH:/opt/bin:/etc:/usr/local/etc:/usr/etc
# Set up a basic library load path, manpath, etc.
export LD_LIBRARY_PATH=/usr/local/lib:$X11_HOME/lib:$HOME/lib
export MANPATH=$HOME/man:/usr/man:/usr/share/man:/usr/local/man:$X11_HOME/man

# Next, we need to make sure we can find the brew command.  On intel Macs, there is a link in
# /usr/local, but on ARM platforms, it is in /opt/homebrew.  We need this for the rest of this
# script to work properly.
if [ $os_type == Darwin ]; then
    if [ -d /opt/homebrew ]; then
        export PATH=/opt/homebrew/bin:$PATH
    fi
    echo "path=$PATH $(which dircolors)"
    # make sure dircolors is in the path...
    export PATH=$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH
    echo "path=$PATH $(which dircolors)"
fi

# Next, figure out where this .bashrc file lives so we can source the right files later.
df_home=$(dirname $(realpath "${BASH_SOURCE[0]}"))

# Using dircolors to set the LS_COLORS variable for color ls.  This depends on homebrew.
eval $(dircolors ${df_home}/.dir_colors)

###################################################################################################
# Load variables and local overides from .bash_vars and .bash_local
###################################################################################################

# Load global environment variables.
. ${df_home}/.bash_vars

# Load local overrides to global variables.  This runs before configuration fragments so that they
# use the right values in the fragments.
# override anything there.
if [ -f ${df_home}/.bash_local ]; then
    . ${df_home}/.bash_local
fi

# Load default aliases and functions.  Configuration fragments may override these depending on what
# is installed on the system.
. ${df_home}/.bash_aliases
. ${df_home}/.bash_functions

###################################################################################################
# Load configuration fragments
###################################################################################################

# Load command specific configuration fragments early in case we need to modify the path. Fragments
# can set variables, but they need to use myvar="${myvar:=newvalue}" to avoid overriding a locally
# defined value.  This because the configuration fragments set up path fragments and we need the
# right values.
for bfile in ${df_home}/.bash.d/*.sh ; do
	. $bfile
done

# Add the path prefix from our variable setup if we have one. We will need it for other commands in
# this script.
if [ -n "$path_prefix" ]; then
    export PATH=$path_prefix:$PATH
fi

###################################################################################################
# Set up auto-completion
###################################################################################################

# On a mac, we need to enable completion manually.
if [[ $os_type == Darwin ]]; then
    if [ -f $(brew --prefix)/etc/profile.d/bash_completion.sh ]; then
        . $(brew --prefix)/etc/profile.d/bash_completion.sh
    fi
fi

# Load local completion scripts.
for bcfile in ${df_home}/.bash_completion.d/* ; do
	. $bcfile
done

# The AWS cli has its own way of doing autocomplete
if hash aws_completer 2>/dev/null; then
	complete -C aws_completer aws
fi

# So does terraform
complete -C /usr/bin/terraform terraform

# Angular CLI autocomletion, if we have Angular installed.
if  type "ng" > /dev/null 2>&1; then
    source <(ng completion script)
fi

# Load in the git functions and define what we want to see.  This comes after bash completion in
# case any of the completion scripts have their own git prompt, like Homebrew's.
. ${df_home}/.git-prompt

#############################################################################
# Finalize pathing
#############################################################################

# Add paths that depend on variables. Only add things for which we've defined a variable that says
# we've got the package.
if [ -n "$X11_HOME" ]; then
    export PATH=$PATH:$X11_HOME/bin
    export FONTPATH=$X11_HOME/lib/fonts
fi

# Add the path suffix from our variable setup if we have one.
if [ -n "$path_suffix" ]; then
    export PATH=$PATH:$path_suffix
fi

# On a mac, we need to add the coreutils to the MANPATH
if [[ $os_type == Darwin ]]; then
    export MANPATH=$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH
fi

# Load "z" for remembering directories, but don't expand symlinks.  This is near the end because we
# want everything that will modify the PROMPT_COMMAND to be stable first.
export _Z_NO_RESOLVE_SYMLINKS=1
. ${df_home}/bin/z.sh


# Make sure we start in the correct home directory.  If our environment has a START_DIR, go to it.
# Otherwise, see if we have a certain variable, and if not do a cd to go to the home directory.
# Then set the var
#if [ -n "$START_DIR" ]; then
    #cd $START_DIR
#elif [ -z "$SOURCED" ]; then
    #cd
#fi
#export SOURCED=true

# Finish the path.  We always want the user's bin at the very front, followed by the bin and cargo
# dirs under this script's dir so that scripts from this project are used ahead of whatever comes
# from things like sdkman.
export PATH=${df_home}/bin:${df_home}/.cargo/bin:$PATH
if [ -d "${HOME}/bin" ] && [[ ":$PATH:" != *":${HOME}/bin:"* ]]; then
    export PATH=${HOME}/bin:$PATH
fi

# And we want "." dead last
export PATH=$PATH:.
