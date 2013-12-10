# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.
# if we aren't in an interactive shell, just bail here.
[ -z "$PS1" ] && return

#############################################################################
# Basic initialization
#############################################################################
# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
export EDITOR=vi

# Set the sorting to the order we'd expect
export LC_COLLATE=POSIX

# Set misc. environment variables.
export LINK_TIMEOUT=3
export TERM=xterm
export term=xterm
export HISTCONTROL=ignoredups:ignorespace
export HISTFILESIZE=99

# Fix terminal oddities
stty erase 
stty intr 
stty kill 
umask 022

#set the colors for color ls.
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.deb=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.mpg=01;37:*.avi=01;37:*.gl=01;37:*.dl=01;37:'

# Figure out what OS and machine I'm on
os_type=$(uname)
if [ -z "$HOSTNAME" ]; then
    export HOSTNAME=`/bin/hostname`
fi

# This section sets the prompt based on who I am. Basically, if I'm not myself,
# I want to see the username in the prompt.  First, who should I be, and where
# is my home?
echo $HOSTNAME
if [[ $HOSTNAME == valen || $HOSTNAME == lennier ]]; then
    me="steve"
	export MY_HOME="/home/steve"
elif [[ $HOSTNAME == delenn ]]; then
    me="salimans"
	export MY_HOME="/cygdrive/e/home/steve"
elif [[ $HOSTNAME == whitestar ]]; then
    me="salimans"
	export MY_HOME="/cygdrive/c/home/steve"
elif [[ $HOSTNAME == yoda ]]; then
    me="salimans"
	export MY_HOME="/cygdrive/c/home/salimans"
elif [[ $HOSTNAME == vader* ]]; then
	me="salimans"
	export MY_HOME="/Users/salimans"
else
    me="salimans"
	export MY_HOME="/home/salimans"
fi

user=`/usr/bin/whoami`
normal="\[\e[0m\]"
black="\[\033[00;00m\]"
red="\[\033[00;31m\]"
green="\[\033[00;32m\]"
yellow="\[\033[00;33m\]"
blue="\[\033[00;34m\]"
purple="\[\033[00;35m\]"
cyan="\[\033[00;36m\]"
white="\[\033[00;37m\]"
bold_red="\[\033[01;31m\]"
bold_green="\[\033[01;32m\]"
bold_gray="\[\033[00;37m\]"

# Bring in the git functions and define what we want to see
if [ -f ${MY_HOME}/.git-completion ]; then
    . ${MY_HOME}/.git-completion
fi
if [ -f ${MY_HOME}/bin/z.sh ]; then
    . ${MY_HOME}/bin/z.sh
fi

if [[ $user == $me ]]; then
    #PS1="\h: \[\033[00;34m\]\w ${yellow}\$(parse_git_branch)\n\[\033[00m\]\!>"
    PS1="\h: ${blue}\w\$(__git_ps1)\n${normal}\!>"
else
    #PS1="\[\033[01;31m\]\u\[\033[00m\]@\h: \[\033[00;34m\]\w \$(parse_git_branch)\n\r\[\033[00m\]\!>"
    PS1="${bold_red}\u${normal}@\h: ${blue}\w\$(__git_ps1)\n\r${normal}\!>"
fi

#############################################################################
# Pathing and environment variables for things like Oracle, Maven, etc.
#############################################################################

# Set up a basic path that works for all environments.
export PATH=/usr/local/bin:/sbin:/usr/sbin:/bin:/usr/bin:/opt/bin:/etc
export PATH=$PATH:/usr/local/etc:/usr/etc:/usr/ccs/bin
# Set up host specific paths and variables. Each host will need an X11_HOME,
# JAVA_HOME, ORACLE_HOME, etc.  We'll start with reasonable defaults so each
# host only needs to set the ones that are different.
export X11_HOME=/usr/X11R6
export JAVA_HOME=/opt/java
export ORACLE_HOME=/opt/oracle
instant_client=0
# We need to keep track of the user's real home directory for the VIM alias.
export USER_HOME=${HOME}


# Set up some sensible default variables and paths based on the OS I'm on, and
# the fact that I tend to be pretty consistent from machine to machine
if [[ $os_type == Linux ]]; then
    echo "Setting variables for Linux"
    export ORACLE_HOME=/opt/oracle/product/11.2.0
    export ORACLE_SID=devl
    export JAVA_HOME=/opt/jdk1.6.0_30
    #export JAVA_HOME=/opt/jdk1.5.0_12
    export JAVA_OPTS='-Xmx128m -Xms128m'
    # for X to start up right, we need gnome on the path.
    export PATH=$PATH:/opt/gnome/sbin:/opt/gnome/bin:/opt/kde3/bin
    export ANT_HOME=/opt/ant-1.7.1
    export MVN_HOME=/opt/maven-2.2.1
	export GRADLE_HOME=/opt/gradle-1.5
    export CATALINA_HOME=/opt/tomcat-6.0.35
    cat_opts="-XX:PermSize=64m -XX:MaxPermSize=256m"
    cat_opts="$cat_opts -Xms512m -Xmx512m -Djava.awt.headless=true"
    export CATALINA_OPTS="$cat_opts"
    # Specify what git statuses we want to see.
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM=1
elif [[ $os_type == CYGWIN* ]]; then
    echo "Setting variables for Cygwin"
    export ORACLE_HOME=/c/opt/oracle/product/11.2.0
    #export MYSQL_HOME=/c/opt/mysql-5.5.20
    export ANT_HOME=/c/opt/ant-1.7.1
    export JAVA_HOME=/c/opt/jdk1.6.0_30
    export JRUBY_HOME=/opt/jruby-1.3.0
	export GROOVY_HOME=/opt/groovy-2.1.3
    #export RUBY_HOME=c:/opt/ruby-1.8.7
    export MVN_HOME=/opt/maven-2.2.1
	export GRADLE_HOME=/opt/gradle-1.7
    export CATALINA_HOME=/cygdrive/c/opt/tomcat-6.0.35
    #export CATALINA_PID $CATALINA_HOME/work/catalina.pid
    cat_opts="-XX:PermSize=64m -XX:MaxPermSize=256m"
    cat_opts="$cat_opts -Xms512m -Xmx512m -Djava.awt.headless=true"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote.port=9012"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote.ssl=false"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote.authenticate=false"
    export CATALINA_OPTS="$cat_opts"
    # also add the windows dirs to the path if we are on cygwin.
    export PATH=$PATH:/cygdrive/c/WINDOWS/System32
    export PATH=$PATH:/cygdrive/c/WINDOWS/System32/Wbem
    # Specify what git statuses we want to see. git-completion has performance
    # issues in cygwin.
    export GIT_PS1_SHOWDIRTYSTATE=1
    #export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1

    export GIT_PS1_SHOWUPSTREAM=1
	# Need Firefox in the path for Selenium to work...
	export PATH=$PATH:/cygdrive/c/network/firefox

    # Cygwin has trouble with the groovy shell
	alias groovysh='stty -icanon min 1 -echo; groovysh --terminal=unix; stty icanon echo'
elif [[ $os_type == Darwin ]]; then
    echo "Setting variables for OSX"
	export JAVA_HOME=$(/usr/libexec/java_home)
    export MVN_HOME=/opt/local
    export MYSQL_HOME=/usr/local/mysql
    instant_client=1
	export GRADLE_HOME=/opt/gradle-1.5
    export CATALINA_HOME=/opt/tomcat-6.0.35
    cat_opts="-XX:PermSize=64m -XX:MaxPermSize=256m"
    cat_opts="$cat_opts -Xms512m -Xmx512m -Djava.awt.headless=true"
    export CATALINA_OPTS="$cat_opts"
    # Add Git to the path, since the OSX installer puts it in a subdir...
    export PATH=$PATH:/usr/local/git/bin
    # Specify what git statuses we want to see.
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM=1
	# Add the macports dirs to the path
    export PATH=$PATH:/opt/local/bin:/opt/local/sbin
else
    echo "$HOSTNAME is unknown, I hope the path and ORACLE_HOME work out"
fi

# Override the variables with host specific settings here...
if [[ $HOSTNAME == delenn ]]; then
    # we had to set HOME in windows for egit, but that won't work for cygwin
    export HOME=/e/home/${me}
elif [[ $HOSTNAME == maxdev* ]]; then
    export JAVA_HOME=/opt/jdk1.6.0_23
    export CATALINA_HOME=/opt/apache-tomcat-6.0.29
    export MVN_HOME=/opt/apache-maven-2.2.1
elif [[ $HOSTNAME == maxci* ]]; then
    export JAVA_HOME=/opt/jdk1.6.0_22
    export CATALINA_HOME=/opt/apache-tomcat-6.0.29
    export MVN_HOME=/opt/apache-maven-2.2.1
fi

# finish the paths, we want /usr/ucb and . at the end
export PATH=$PATH:$X11_HOME/bin
export PATH=~${me}/bin:$JAVA_HOME/bin:$PATH
# Add Oracle to the path, if we've got ORACLE_HOME
if [ -n "$ORACLE_HOME" ]; then
    if [ $instant_client == 1 ]; then
        export PATH=$PATH:$ORACLE_HOME
        export LD_LIBRARY_PATH=$ORACLE_HOME
    else
        export PATH=$PATH:$ORACLE_HOME/bin
        export LD_LIBRARY_PATH=$ORACLE_HOME/lib
    fi
fi

# Add MYSql to the path, if we've got MYSQL_HOME
if [ -n "$MYSQL_HOME" ]; then
    export PATH=$PATH:$MYSQL_HOME/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$MYSQL_HOME/lib
fi

# Add Groovy to the path, if we've got GROOVY_HOME
if [ -n "$GROOVY_HOME" ]; then
    export PATH=$PATH:$GROOVY_HOME/bin
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$GROOVY_HOME/lib
fi
# Add tomcat to the path, if we've got CATALINA_HOME
if [ -n "$CATALINA_HOME" ]; then
    export PATH=$PATH:$CATALINA_HOME/bin
fi

export PATH=$PATH:/usr/ucb:.

# Set up the library load path, manpath, etc.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:$X11_HOME/lib:/usr/ccs/lib:$HOME/lib
export MANPATH=$HOME/man:/usr/man:/usr/share/man:/usr/local/man:$X11_HOME/man
export FONTPATH=$X11_HOME/lib/fonts

# Finish up the java environment.
export JAVA_LIB_DIR=$JAVA_HOME/lib
export CLASSPATH=${HOME}/lib/junit-4.1.jar:${HOME}/lib/catalina-ant.jar

#############################################################################
# Aliases
#############################################################################

# standard aliases - make sure color ls is before /bin/ls in the path.
alias backup='sudo rsync -avi --delete --exclude=/media/ --exclude=/proc/ --exclude=/sys/ / /media/Elements/valen | grep -v \.[fd]\/\/\/pog\.\.\.'
alias backup_data='sudo rsync -avi --delete --exclude=/usr/local/oradata/ /usr/local/ /media/Elements/valen/usr/local | grep -v \.[fd]\/\/\/pog\.\.\.'
alias catalina=catalina.sh
alias cls=clear
alias df='df -h'
alias du='du -h'
alias gradled='export GRADLE_OPTS=export GRADLE_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y"'
alias grep='grep --color'
alias nyx='telnet nyx10.nyx.net'
alias path='echo $PATH'
alias ssh='ssh -X'
alias startx=/home/${me}/bin/startx
alias temp='telnet thermhost.colorado.edu 451'
alias weather='finger weather@unidata.ucar.edu'
alias vil=vi
alias vncserv='vncserver :1 -depth 16 -geometry 1870x1140'
alias vncserv-low='vncserver :1 -depth 16 -geometry 1280x800'
alias vt100='set term=vt100; stty rows 24'
alias which=type

# Aliases that differ by OS
if [[ $os_type == Darwin ]]; then
    alias dir='ls -lFaGh'
    alias ls='ls -FAGh'
else
    alias dir='ls --color --human-readable -lFa'
    alias ls='ls --color --human-readable -FA'
fi

# Aliases that need to be functions.
function decode() {
  'tr A-MN-Za-mn-z N-ZA-Mn-za-m < $1 > $1.out'
}

function start-gpg () {
    unset DISPLAY
	export GPG_TTY=$(tty)
	eval $(gpg-agent --daemon --pinentry-program /usr/bin/pinentry)
}

function h() {
    num=$1
    if [ -z $num ]; then
        num=40
    fi
    # if no arg is passed, just get the first 39...
    history $num
}

function psg() { 
	if [[ $os_type == CYGWIN* ]]; then
    	#procps -eao "user pid ppid vsz stime etime time tty args" | grep "$1"
		ps -eaW | grep $1
	else
    	ps -eao "user pid ppid vsz stime etime time tty args" | grep "$1"
	fi
}

# The vi function plays with the home directory so that I can use my vim config
# regardless of who I am. The double quotes around the $@ are important.  
# Without them, a filename with spaces will be interpereted as several different
# filenames.
function vi() {
	if [[ $user == $me ]]; then
		vim -X "$@"
	else
		HOME=${MY_HOME}
		vim -X -c "let \$HOME = \"${USER_HOME}\"" "$@"
		HOME=${USER_HOME}
	fi
}

function xtitle() {
    printf "\033]0;$*\007\r"
}

function zmore() {
    zcat $*| more
}

# Set up the aliases that needed host specific info
alias ant="${ANT_HOME}/bin/ant"
alias mvn="${MVN_HOME}/bin/mvn"
#alias gradle="${GRADLE_HOME}/bin/gradle --daemon"
alias gradle="${GRADLE_HOME}/bin/gradle"

#############################################################################
# Further OS and Host specific actions
#############################################################################

# Function to start Cygwin's ssh-agent. It starts the agent, then creates an
# RC file that other shells can use to access the agent.  Then it adds the
# private key to the agent, which is the only part of the process that prompts.
# Only the first shell to start will ask for a password because other shells
# will see the RC file.
function start_ssh_agent {
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

if [[ $os_type == CYGWIN* ]]; then
    # For some reason, I can't execute sqlplus from Cygwin if ORACLE_HOME is 
    # set, so now that it is in the path, unset the var.  We also need to 
    # change $HOME to the "mounted" network directory instead of the cygdrive 
    # link.
    echo "Unsetting ORACLE_HOME for cygwin"
    unset ORACLE_HOME
fi
# Start an ssh-agent, or builds won't work because we can't pass an ssh 
# passphrase to git, and we can't get it to prompt.
export SSHRC="$HOME/.ssh/.sshrc"
#if [ -f "${SSHRC}" ]; then
	#. "${SSHRC}" > /dev/null
	## Just because we have an RC file, doesn't mean the process is 
	## actually running.
	#ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
		#start_ssh_agent;
	#}
#else
	#start_ssh_agent;
#fi 

# Function to make a tar file of the various files that make up my environment.
# This tar file can then be copied to other machines for one step setup.
function env_backup() {
	backup_dir=${HOME}/env_backup
    mkdir -p $backup_dir
    mkdir -p $backup_dir/.ssh
	chmod 700 $backup_dir/.ssh
    mkdir -p $backup_dir/.vim
	mkdir -p $backup_dir/bin
	cp -p $HOME/.Xdefaults $backup_dir
	cp -p $HOME/.bashrc $backup_dir
	cp -p $HOME/.bash_profile $backup_dir
	cp -p $HOME/.bash_logout $backup_dir
	cp -p $HOME/.git-completion $backup_dir
	cp -p $HOME/.gitconfig $backup_dir
	cp -p $HOME/.gitignore $backup_dir
	cp -p $HOME/.ssh/authorized_keys $backup_dir/.ssh
	cp -p $HOME/.ssh/config $backup_dir/.ssh
	cp -p $HOME/.ssh/id_rsa $backup_dir/.ssh
	cp -p $HOME/.ssh/id_rsa.pub $backup_dir/.ssh
	cp -p $HOME/.vimrc $backup_dir
	cp -pr $HOME/.vim $backup_dir
	cp -p $HOME/bin/z.sh $backup_dir/bin
	pushd $backup_dir
	tar -cvf ${HOME}/env_backup.tar .
	popd
	#rm -r $backup_dir
}

## RVM
# Load RVM into a shell session *as a function*
[[ -s "${MY_HOME}/.rvm/scripts/rvm" ]] && source "${MY_HOME}/.rvm/scripts/rvm"

# Make sure we start in the correct home directory.  Basically, if our env.
# doesn't have a certain var, cd.  Then set the var
if [ -z "$SOURCED" ]; then
    cd
fi
export SOURCED=true
