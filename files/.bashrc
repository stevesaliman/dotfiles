# There are 3 different types of shells in bash: the login shell, normal shell and interactive
# shell. Login shells read ~/.profile and interactive shells read ~/.bashrc; in our setup,
# /etc/profile sources ~/.bashrc - thus all settings made here will also take effect in a login
# shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than here, since
# multilingual X sessions would not work properly if LANG is overridden in every subshell.

# Load in the system profile, if we have one.
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# if we aren't in an interactive shell, just bail here.
[ -z "$PS1" ] && return

# First things first: Figure out what OS and machine I'm on
os_type=$(uname)
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME=`/bin/hostname`
fi

# Next, set up a basic path that works for all environments. This is needed to execute the rest of
# this script which uses things like uname, grep, etc.  We always want our own bin at the front of
# the path.
export PATH=${HOME}/bin:${HOME}/.cargo/bin
export PATH=$PATH:/usr/local/bin:/usr/local/sbin:/sbin:/usr/sbin:/bin:/usr/bin
export PATH=$PATH:/opt/bin:/etc:/usr/local/etc:/usr/etc:/usr/ccs/bin

# Next, we need to make sure later code can find the brew command.  On intel Macs, there is a link
# in /usr/local, but on ARM platforms, it is in /opt/homebrew.
if [ $os_type == Darwin -a -d /opt/homebrew ]; then
    export PATH=/opt/homebrew/bin:$PATH
fi

# Next, figure out where this .bashrc file lives so we can source the right files later.
bash_script_dir=$(dirname "${BASH_SOURCE[0]}")

#############################################################################
# Load variables and local overides from .bash_vars and .bash_local
#############################################################################

# Load environment variables.
. ${bash_script_dir}/.bash_vars
if [ -f ${bash_script_dir}/.bash_local ]; then
    . ${bash_script_dir}/.bash_local
fi

# Add the path prefix from our variable setup if we have one. We will need it for other commands in
# this script.
if [ -n "$path_prefix" ]; then
    export PATH=$path_prefix:$PATH
fi

# Load aliases and functions.
. ${bash_script_dir}/.bash_aliases
. ${bash_script_dir}/.bash_functions

#set the colors for color ls. This can't be in .bash_vars because Macs need homebrew in the path,
# And that doesn't happen until here.
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

# Load in the git functions and define what we want to see.  This comes after bash completion in
# case any of the completion scripts have their own git prompt, like Homebrew's.
. ${bash_script_dir}/.git-prompt

# If I'm not myself, add the username to the prompt and xterm title. This needs to be done before
# adding "z". I'm using the dirs command instead of the more usual ${PWD/#$HOME/~} substitution
# because, for some reason, the substitution wasn't happening in some environments.
if [[ $user == $me ]]; then
    #PS1="\h: \[\033[00;34m\]\w ${yellow}\$(parse_git_branch)\n\[\033[00m\]\!>"
    PS1="\h:${bold_blue}\w\$(__git_ps1)\n${normal}\!>"
	PROMPT_COMMAND='printf "\033]0;%s %s:%s\007" "${XTERM_NAME}" "${HOSTNAME%%.*}" "$(dirs)"'
else
    #PS1="\[\033[01;31m\]\u\[\033[00m\]@\h: \[\033[00;34m\]\w \$(parse_git_branch)\n\r\[\033[00m\]\!>"
    PS1="${bold_red}\u${normal}@\h: ${bold_blue}\w\$(__git_ps1)\n\r${normal}\!>"
	PROMPT_COMMAND='printf "\033]0;%s %s@%s:%s\007" "${XTERM_NAME}" "${USER}" "${HOSTNAME%%.*}" "$(dirs)"'
fi

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
trap stop_ssh_agent EXIT SIGTERM

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

# Set the Oracle path.  Setting LD_LIBRARY_PATH appears to interfere with Python, so we won't add
# it to the library path.
if [ -n "$ORACLE_HOME" ]; then
    if [ $instant_client == 1 ]; then
        export PATH=$PATH:$ORACLE_HOME
		# export local_libs=${local_libs:+${local_libs}:}:$ORACLE_HOME
    else
        export PATH=$PATH:$ORACLE_HOME/bin
		# export local_libs=${local_libs:+${local_libs}:}:$ORACLE_HOME/lib
    fi
fi

if [ -n "$MYSQL_HOME" ]; then
    export PATH=$PATH:$MYSQL_HOME/bin
	local_libs=${local_libs:+${local_libs}:}:$MYSQL_HOME/lib
fi

if [ -n "$CATALINA_HOME" ]; then
    export PATH=$PATH:$CATALINA_HOME/bin
fi


# finish the paths, we want /usr/ucb and . at the end
export PATH=${bash_script_dir}/bin:$PATH
export PATH=$PATH:/usr/ucb:.

# finally add the path suffix from our variable setup if we have one.
if [ -n "$path_suffix" ]; then
    export PATH=$PATH:$path_suffix
fi

# Set up the library load path, manpath, etc.
export LD_LIBRARY_PATH=$local_libs:/usr/local/lib:$X11_HOME/lib:/usr/ccs/lib:$HOME/lib
export MANPATH=$HOME/man:/usr/man:/usr/share/man:/usr/local/man:$X11_HOME/man
# On a mac, we need to add the coreutils to the MANPATH
if [[ $os_type == Darwin ]]; then
    export MANPATH=$(brew --prefix)/opt/coreutils/libexec/gnuman:$MANPATH
fi

if [[ $os_type == CYGWIN* ]]; then
    # For some reason, I can't execute sqlplus from Cygwin if ORACLE_HOME is set, so now that it is
    # in the path, unset the var.  We also need to change $HOME to the "mounted" network directory
    # instead of the cygdrive link.
    echo "Unsetting ORACLE_HOME for cygwin"
    unset ORACLE_HOME
fi

## RVM
# Load RVM into a shell session *as a function*
[[ -s "${RVM_DIR}/scripts/rvm" ]] && source "${RVM_DIR}/scripts/rvm"

# Add rvm to the path, if we've got RVM
if [ -d "${RVM_DIR}/bin" ]; then
    export PATH=${RVM_DIR}/bin:$PATH # Add RVM to the PATH for scripting
fi

## NVM
# Load NVM if we have an nvm directory.  The readlink command is used to get the real location of
# $NVM_DIR because nvm has issues with symlinks
export NVM_DIR="$(readlink -f ${NVM_DIR})"
[ -s "$NVM_DIR/nvm.sh" ] &&. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Angular CLI autocomletion, if we have Angular installed.
if  type "ng" > /dev/null 2>&1; then
    source <(ng completion script)
fi

# tabtab source for jhipster package
# uninstall by removing these lines or running `tabtab uninstall jhipster`
[ -f "${NVM_DIR}/versions/node/v6.9.5/lib/node_modules/generator-jhipster/node_modules/tabtab/.completions/jhipster.bash" ] && . "${NVM_DIR}/versions/node/v6.9.5/lib/node_modules/generator-jhipster/node_modules/tabtab/.completions/jhipster.bash"

# Add SDKMan if it is installed.
[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

# Add the rc file hook if either nvm or sdkman are installed.  No need to call it everytime we
# change directories if we don't have any of the commands installed.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    if ! [[ "${PROMPT_COMMAND:-}" =~ _rc_file_hook ]]; then
        PROMPT_COMMAND="_rc_file_hook ${PROMPT_COMMAND}"
    fi
fi

# Make sure we start in the correct home directory.  If our environment has a START_DIR, go to it.
# Otherwise, see if we have a certain variable, and if not do a cd to go to the home directory.
# Then set the var
#if [ -n "$START_DIR" ]; then
    #cd $START_DIR
#elif [ -z "$SOURCED" ]; then
    #cd
#fi
#export SOURCED=true

# We always want our own bin at the front of the path, so we find our gradle shell instead of the
# one that comes with sdkman
export PATH=${HOME}/bin:$PATH

# Load "z" for remembering directories, but don't expand symlinks.  This is last because we want
# everything that will modify the PROMPT_COMMAND to be stable first.
export _Z_NO_RESOLVE_SYMLINKS=1
. ${bash_script_dir}/bin/z.sh

