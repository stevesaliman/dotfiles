# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
# Load in the system profile, if we have one.
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# if we aren't in an interactive shell, just bail here.
[ -z "$PS1" ] && return

# First set up a basic path that works for all environments. This is needed
# to execute the rest of this script which uses things like uname, grep, etc.
export PATH=/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:/opt/bin:/etc
export PATH=$PATH:/usr/local/etc:/usr/etc:/usr/ccs/bin

# Next, figure out where this .bashrc file lives so we can source the right
# files later.
bash_script_dir=$(dirname "${BASH_SOURCE[0]}")

# Figure out what OS and machine I'm on
os_type=$(uname)
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME=`/bin/hostname`
fi

#############################################################################
# Load helper scripts like git-completion and .bash_vars
#############################################################################

# Load environment variables.
. ${bash_script_dir}/.bash_vars
if [ -f ${bash_script_dir}/.bash_local ]; then
    . ${bash_script_dir}/.bash_local
fi

# Load in the git functions and define what we want to see
. ${bash_script_dir}/.git-completion

# If I'm not myself, add the username to the prompt.
if [[ $user == $me ]]; then
    #PS1="\h: \[\033[00;34m\]\w ${yellow}\$(parse_git_branch)\n\[\033[00m\]\!>"
    PS1="\h: ${blue}\w\$(__git_ps1)\n${normal}\!>"
else
    #PS1="\[\033[01;31m\]\u\[\033[00m\]@\h: \[\033[00;34m\]\w \$(parse_git_branch)\n\r\[\033[00m\]\!>"
    PS1="${bold_red}\u${normal}@\h: ${blue}\w\$(__git_ps1)\n\r${normal}\!>"
fi

# Load "z" for remembering directories, but don't expand symlinks.
export _Z_NO_RESOLVE_SYMLINKS=1
. ${bash_script_dir}/bin/z.sh

# Load aliases and functions.
. ${bash_script_dir}/.bash_aliases
. ${bash_script_dir}/.bash_functions

#############################################################################
# Pathing and environment variables for things like Oracle, Maven, etc.
#############################################################################

# Set bash options, starting with the one that checks for background jobs before
# exiting.
if [[ $BASH_VERSION > 4 ]]; then
    shopt -s checkjobs
fi
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
# Include dotfiles when globbing (expanding wildcards)
shopt -s dotglob

# Fix terminal oddities
stty erase 
stty intr 
stty kill 
umask 022

# Add paths that depend on variables. Only add things for which we've defined a
# variable that says we've got the package.
if [ -n "$X11_HOME" ]; then
    export PATH=$PATH:$X11_HOME/bin
    export FONTPATH=$X11_HOME/lib/fonts
fi

if [ -n "$ORACLE_HOME" ]; then
    if [ $instant_client == 1 ]; then
        export PATH=$PATH:$ORACLE_HOME
        export LD_LIBRARY_PATH=$ORACLE_HOME
    else
        export PATH=$PATH:$ORACLE_HOME/bin
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib
    fi
fi

if [ -n "$MYSQL_HOME" ]; then
    export PATH=$PATH:$MYSQL_HOME/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MYSQL_HOME/lib
fi

if [ -n "$GROOVY_HOME" ]; then
    export PATH=$PATH:$GROOVY_HOME/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GROOVY_HOME/lib
fi

if [ -n "$CATALINA_HOME" ]; then
    export PATH=$PATH:$CATALINA_HOME/bin
fi


# finish the paths, we want /usr/ucb and . at the end
export PATH=${bash_script_dir}/bin:$PATH
export PATH=$PATH:/usr/ucb:.

# finally add the prefix and suffix from our variable setup if we have one.
if [ -n "$path_prefix" ]; then
    export PATH=$path_prefix:$PATH
fi
if [ -n "$path_suffix" ]; then
    export PATH=$PATH:$path_suffix
fi

# Set up the library load path, manpath, etc.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:$X11_HOME/lib:/usr/ccs/lib:$HOME/lib
export MANPATH=$HOME/man:/usr/man:/usr/share/man:/usr/local/man:$X11_HOME/man

if [ -n "$JAVA_HOME" ]; then
    export PATH=$JAVA_HOME/bin:$PATH
    export JAVA_LIB_DIR=$JAVA_HOME/lib
    export CLASSPATH=${HOME}/lib/junit-4.1.jar:${HOME}/lib/catalina-ant.jar
fi

if [[ $os_type == CYGWIN* ]]; then
    # For some reason, I can't execute sqlplus from Cygwin if ORACLE_HOME is 
    # set, so now that it is in the path, unset the var.  We also need to 
    # change $HOME to the "mounted" network directory instead of the cygdrive 
    # link.
    echo "Unsetting ORACLE_HOME for cygwin"
    unset ORACLE_HOME
fi

## RVM
# Load RVM into a shell session *as a function*
[[ -s "${HOME}/.rvm/scripts/rvm" ]] && source "${HOME}/.rvm/scripts/rvm"

# Add rvm to the path, if we've got RVM
if [ -d "$HOME/.rvm/bin" ]; then
    export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

# Trap the shell exit and kill ssh-agent when it exits
trap stop_ssh_agent EXIT SIGTERM


# Make sure we start in the correct home directory.  Basically, if our env.
# doesn't have a certain var, cd.  Then set the var
if [ -z "$SOURCED" ]; then
    cd
fi
export SOURCED=true
