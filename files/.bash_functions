# This file is sourced by .bashrc to load the basic functions we want to use.  Configuration
# fragments can also define functions specific to the command(s) covered by the fragment.
#
# The general convention in this file is that functions that start with an underscore are internal
# and not to be called directly.  Ones that don't start with underscores are essentially complex
# aliases.


# Stop the ssh agent when the shell exits.  It is not really intended to called by users, as it
# exits the shell.
function _stop_ssh_agent {
    if [ "$SSH_AGENT_PID" != "" ]; then
		eval $(/usr/bin/ssh-agent -k)
	fi
	exit
}

# The decode function can't be an alias because we're using $1 twice.
function decode {
  'tr A-MN-Za-mn-z N-ZA-Mn-za-m < $1 > $1.out'
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

# function to start a gpg agent so we can generate pgp keys.
function start-gpg {
    unset DISPLAY
	export GPG_TTY=$(tty)
	eval $(gpg-agent --daemon --pinentry-program /usr/bin/pinentry)
}

# Function to start the ssh-agent and associate it with the current shell.
# It starts the agent, then creates an RC file that other shells can use to access the agent.  Then
# it adds the private key to the agent, which is the only part of the process that prompts the user.
# Only the first shell to start will ask for a password because other shells will see the RC file.
function start_ssh_agent {
	if [ -f "${SSHRC}" ]; then
		. "${SSHRC}" > /dev/null
		# Just because we have an RC file, doesn't mean the process is actually running.
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
        if [ -f "${HOME}/.ssh/id_ed25519" ]; then
            /usr/bin/ssh-add ${HOME}/.ssh/id_ed25519;
        else
            /usr/bin/ssh-add ${HOME}/.ssh/id_rsa;
        fi
    fi
}

# The vi function plays with the home directory so that I can use my vim config regardless of who I
# am.  The double quotes around the $@ are very important.  Without them, filenames with spaces
# will be interpereted as several different filenames when they are passed to vi.
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

