# There are 3 different types of shells in bash: the login shell, normal shell and interactive
# shell. Login shells read ~/.profile and interactive shells read ~/.bashrc; in our setup,
# /etc/profile sources ~/.bashrc - thus all settings made here will also take effect in a login
# shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than here, since
# multilingual X sessions would not work properly if LANG is overridden in every subshell.

# This file works in 6 basic steps:
#
# 1. Load system files, Set up a very basic path and initialize some things we'll use in the rest of
# the script
#
# 2. Load variables, and process local overrides to the variables.
#
# 3. Load the configuration fragments from the bash.d directory
#
# 4. Load the alises and functions
#
# 5. Set up auto completion
#
# 6. Final pathing and other things like ld_library path.

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

# First things first: Figure out what OS and machine I'm on
os_type=$(uname)
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME=`/bin/hostname`
fi

# Next, set up a basic path that works for all environments. This is needed to execute the rest of
# this script which uses things like uname, grep, etc.  We always want our own bin at the front of
# the path.
export PATH=/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin
export PATH=$PATH:/opt/bin:/etc:/usr/local/etc:/usr/etc

# Next, we need to make sure later code can find the brew command.  On intel Macs, there is a link
# in /usr/local, but on ARM platforms, it is in /opt/homebrew.
if [ $os_type == Darwin -a -d /opt/homebrew ]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

# Next, figure out where this .bashrc file lives so we can source the right files later.
bash_script_dir=$(dirname $(realpath "${BASH_SOURCE[0]}"))

###################################################################################################
# Load variables and local overides from .bash_vars and .bash_local
###################################################################################################

# Load global environment variables.
. ${bash_script_dir}/.bash_vars

# Load local overrides to global variables.  This runs before configuration fragments so that they
# use the right values in the fragments.
# override anything there.
if [ -f ${bash_script_dir}/.bash_local ]; then
    . ${bash_script_dir}/.bash_local
fi

# Load command specific configuration fragments early in case we need to modify the path. Fragments
# can set variables, but they need to use myvar="${myvar:=newvalue}" to avoid overriding a locally
# defined value.  This because the configuration fragments set up path fragments and we need the
# right values.
for bfile in ${bash_script_dir}/.bash.d/*.sh ; do
	. $bfile
done

# Add the path prefix from our variable setup if we have one. We will need it for other commands in
# this script.
if [ -n "$path_prefix" ]; then
    export PATH=$path_prefix:$PATH
fi

# Load aliases and functions.
. ${bash_script_dir}/.bash_aliases
. ${bash_script_dir}/.bash_functions

#set the colors for color ls. This can't be in .bash_vars or an exa fragment because Macs need
# homebrew in the path, and that doesn't happen until after those files run.

#set the colors for color ls. Start by using dircolors to set the basic colors.
eval $(dircolors ${bash_script_dir}/.dir_colors)
# Set the extended colors for exa per at https://the.exa.website/docs/colour-themes
export EXA_COLORS=$LS_COLORS
# Set the "user" permission bits to the terminal color
export EXA_COLORS="${EXA_COLORS}ur=0:uw=0:ux=0:ue=0:"
# Set the "group" permission bits to yellow
export EXA_COLORS="${EXA_COLORS}gr=33:gw=33:gx=33:"
# Set the "other" permission bits to bold versions of the terminal color
export EXA_COLORS="${EXA_COLORS}tr=1;0:tw=1;0:tx=1;0:"
# Set the setuid and setgid colors
export EXA_COLORS="${EXA_COLORS}sf=30;43:"
# Set the user and group colors.  Yellow for me and my groups, bold yellow otherwise.
export EXA_COLORS="${EXA_COLORS}uu=33:un=1;33:gu=33:gn=1;33:"
# Set the file size colors to normal terminal color
export EXA_COLORS="${EXA_COLORS}sn=0:sb=0:"
# Dates are bold blue.
export EXA_COLORS="${EXA_COLORS}da=1;34:"

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
for bcfile in ${bash_script_dir}/.bash_completion.d/* ; do
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
. ${bash_script_dir}/.git-prompt

#############################################################################
# Pathing and environment variables for things like Oracle, Maven, etc.
#############################################################################

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

# Add paths that depend on variables. Only add things for which we've defined a variable that says
# we've got the package. We'll use a helper variable for the Load Library Path. This variable gets
# used with a funny looking syntax that only puts in a separating colon if there is already a value
# in the variable.
unset local_libs

if [ -n "$X11_HOME" ]; then
    export PATH=$PATH:$X11_HOME/bin
    export FONTPATH=$X11_HOME/lib/fonts
fi

if [ -n "$MYSQL_HOME" ]; then
    export PATH=$PATH:$MYSQL_HOME/bin
	local_libs=${local_libs:+${local_libs}:}:$MYSQL_HOME/lib
fi

# Add the path suffix from our variable setup if we have one.
if [ -n "$path_suffix" ]; then
    export PATH=$PATH:$path_suffix
fi

# Set up the library load path, manpath, etc.
export LD_LIBRARY_PATH=$local_libs:/usr/local/lib:$X11_HOME/lib:$HOME/lib
export MANPATH=$HOME/man:/usr/man:/usr/share/man:/usr/local/man:$X11_HOME/man
# On a mac, we need to add the coreutils to the MANPATH
if [[ $os_type == Darwin ]]; then
    export MANPATH=$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH
fi

# Load "z" for remembering directories, but don't expand symlinks.  This is near the end because we
# want everything that will modify the PROMPT_COMMAND to be stable first.
export _Z_NO_RESOLVE_SYMLINKS=1
. ${bash_script_dir}/bin/z.sh


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
export PATH=${bash_script_dir}/bin:${bash_script_dir}/.cargo/bin:$PATH
if [ -d "${HOME}/bin" ] && [[ ":$PATH:" != *":${HOME}/bin:"* ]]; then
    export PATH=${HOME}/bin:$PATH
fi

# And we want "." dead last
export PATH=$PATH:.
