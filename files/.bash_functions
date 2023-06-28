# This file is sourced by .bashrc to load all the functions we want to use.

# The decode function can't be an alias because we're using $1 twice.
function decode {
  'tr A-MN-Za-mn-z N-ZA-Mn-za-m < $1 > $1.out'
}

# Remove all exited docker containers
function drm {
  docker rm $(docker ps -a -f status=exited -q)
}

# Remove all unused images
function drmi {
  docker rmi $(docker images -f dangling=true -q)
}

# Login to a running docker container
function dsh {
  docker exec -it $1 /bin/bash
}

# Functions to get the screen resolution
function get_screen_res_x {
  if [[ $os_type == Darwin ]]; then
    system_profiler SPDisplaysDataType | awk -F '[ x ]+' '/Resolution:/{print $3}'
  else
    xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $3}'
  fi
}

function get_screen_res_y {
  if [[ $os_type == Darwin ]]; then
    system_profiler SPDisplaysDataType | awk -F '[ x ]+' '/Resolution:/{print $4}'
  else
    xdpyinfo | awk -F '[ x]+' '/dimensions:/{print $4}'
  fi
}

# function to show history.
function h {
    num=$1
    if [ -z $num ]; then
        num=40
    fi
    # if no arg is passed, just get the first 39...
    history $num
}

# function to display swap usage
function ls-swap {
    for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | sort -k 2 -n -r | less
}

# Function to run "nvm use" when we change to a directory that has a .nvmrc file in it.  It starts
# with an underscore because we don't intend for anyone to call it directly.  We also need to make
# sure this doesn't get applied to PROMPT_COMMAND if we don't actually have nvm installed.
_nvmrc_hook() {
    if [[ $PWD == $PREV_PWD ]]; then
        return
    fi

    PREV_PWD=$PWD
    if [[ -f ".nvmrc" ]]; then
        nvm use
        # Angular CLI autocomletion, if we have Angular installed.
        if type "ng" > /dev/null 2>&1; then
            source <(ng completion script)
        fi
    fi
}

# function to enable/disable a starship module.  This function takes advantage of the fact that
# starship reads the config every time it runs.  It takes 2 arguments; a module name, and either
# "on" or "off".  This function makes a couple of assumptions:
# 1. The module being used exists in the starship.toml file.
# 2. The disabled option is the first thing after the module name itself.
function st-mod {
    if [ "$#" -lt 2 ]; then
      echo "usage: st-mod <module name> on|off"
      return 1
    fi
    # Starship uses a disable flag, but our arg acts as an enable flag, so we reverse it here...
    if [ $2 = "on" ]; then
        local newval="false"
    else
        local newval="true"
    fi
    # Start by making a new config file for just this shell, if we don't already have one.  We'll
    # use the bash "$$" variable to get the shell's PID.  We then set an environment variable to
    # tell starship that we want to use our new file as the config file.
    local default_config=$HOME/.config/starship.toml
    local local_config=/tmp/starship/starship-$$.toml
    if [ ! -f $local_config ]; then
        mkdir -p /tmp/starship
        cp $default_config $local_config
        export STARSHIP_CONFIG=${local_config}
    fi

    sed -i "/\[$1\]/{n;s/.*/disabled = $newval/;}" $local_config
}

# function to start a gpg agent so we can generate pgp keys.
function start-gpg {
    unset DISPLAY
	export GPG_TTY=$(tty)
	eval $(gpg-agent --daemon --pinentry-program /usr/bin/pinentry)
}

# Function to start Cygwin's ssh-agent. It starts the agent, then creates an
# RC file that other shells can use to access the agent.  Then it adds the
# private key to the agent, which is the only part of the process that prompts.
# Only the first shell to start will ask for a password because other shells
# will see the RC file.
function start_ssh_agent {
	if [ -f "${SSHRC}" ]; then
		. "${SSHRC}" > /dev/null
		# Just because we have an RC file, doesn't mean the process is 
		# actually running.
		ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
			_start_ssh_agent;
		}
	else
		_start_ssh_agent;
	fi
}

# Helper function that does the actual work of starting an agent
function _start_ssh_agent {
	if [[ $os_type == Darwin ]]; then
        echo "skipping ssh-agent in an OSX environment"
    else
        echo "Initializing new SSH agent..."
        /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSHRC}"
        echo succeeded
        chmod 600 "${SSHRC}"
        . "${SSHRC}" > /dev/null
        /usr/bin/ssh-add;
    fi
} 

# Stop the ssh agent when the shell exits.  It is not really intended to 
# called by users, as it exits the shell.
function stop_ssh_agent {
    if [ "$SSH_AGENT_PID" != "" ]; then
		eval $(/usr/bin/ssh-agent -k)
	fi
	exit
}

# The vi function plays with the home directory so that I can use my vim config
# regardless of who I am. The double quotes around the $@ are very important.  
# Without them, filenames with spaces will be interpereted as several different
# filenames when they are passed to vi.
function vi {
	if [[ $user == $me ]]; then
		vim -X "$@"
	else
		HOME=${bash_script_dir}
		vim -X -c "let \$HOME = \"${bash_script_dir}\"" "$@"
		HOME=${USER_HOME}
	fi
}

function xtitle {
    printf "\033]0;$*\007\r"
	export XTERM_NAME="$*"
}

function zmore {
    zcat $*| more
}

