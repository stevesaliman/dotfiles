# This file is sourced by .bashrc to load all the functions we want to use.

# The decode function can't be an alias because we're using $1 twice.
function decode() {
  'tr A-MN-Za-mn-z N-ZA-Mn-za-m < $1 > $1.out'
}

# function to start a gpg agent so we can generate pgp keys.
function start-gpg () {
    unset DISPLAY
	export GPG_TTY=$(tty)
	eval $(gpg-agent --daemon --pinentry-program /usr/bin/pinentry)
}

# function to show history.
function h() {
    num=$1
    if [ -z $num ]; then
        num=40
    fi
    # if no arg is passed, just get the first 39...
    history $num
}

# Function to run a single gradle build in debug mode.  It assumes that "gradle"
# is in the path (or at least an alias).  Gradle runs in debug mode based on 
# the GRADLE_OPTS variable.  This function will unset those options at the end
# of the run.
function gradled() {
    old_gradle_opts="$GRADLE_OPTS"
	export GRADLE_OPTS="$GRADLE_OPTS -Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y"
	gradle $@
	export GRADLE_OPTS="$old_gradle_opts"
}

# The vi function plays with the home directory so that I can use my vim config
# regardless of who I am. The double quotes around the $@ are very important.  
# Without them, filenames with spaces will be interpereted as several different
# filenames when they are passed to vi.
function vi() {
	if [[ $user == $me ]]; then
		vim -X "$@"
	else
		HOME=${bash_script_dir}
		vim -X -c "let \$HOME = \"${bash_script_dir}\"" "$@"
		HOME=${USER_HOME}
	fi
}

function xtitle() {
    printf "\033]0;$*\007\r"
}

function zmore() {
    zcat $*| more
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

