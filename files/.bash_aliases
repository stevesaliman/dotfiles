# This file loads all the aliases we want to use in our shell. It is sourced
# by .bashrc

# standard aliases - make sure color ls is before /bin/ls in the path.
# Also make sure OSX machines has the GNU coreutils installed.
alias backup='sudo rsync -avi --delete --exclude=/media/ --exclude=/run/ --exclude=/var/run/media/ --exclude=/run/media/ --exclude=/var/run/user --exclude=/proc/ --exclude=/var/lib/ntp/proc/ --exclude=/sys/ / /var/run/media/steve/Elements/valen | grep -v \.[fd]\/\/\/pog\.\.\.'
alias backup_data='sudo rsync -avi --delete --exclude=/usr/local/oradata/ /usr/local/ /var/run/media/steve/Elements/valen/usr/local | grep -v \.[fd]\/\/\/pog\.\.\.'
alias catalina=catalina.sh
alias cls=clear
alias deploy='sudo /usr/local/bin/deploy.sh'
alias dir='ls --color --human-readable -lFa'
alias df='df -h'
alias du='du -hx'
alias grep='grep --color'
alias lame='lame -q 2 -b 256'
alias less='less -R'
alias ls='ls --color --human-readable -FA'
alias microdeploy='sudo /usr/local/bin/microdeploy.sh'
alias nyx='telnet nyx10.nyx.net'
alias path='echo $PATH'
alias prepare="gradle -PenvironmentName=${environment_name} clean; gradle -PenvironmentName=${environment_name} -x test stageRelease"
alias scp='scp -oHostKeyAlgorithms=+ssh-dss'
alias ssh='ssh -X -oHostKeyAlgorithms=+ssh-dss'
alias temp='telnet thermhost.colorado.edu 451'
alias weather='finger weather@unidata.ucar.edu'
alias vil=vi
alias vncserv='vncserver :1 -depth 16 -geometry 1870x1140'
alias vncserv-low='vncserver :1 -depth 16 -geometry 1280x800'
alias vt100='set term=vt100; stty rows 24'
alias which=type

# Aliases that differ by OS
if [[ $os_type == Linux ]]; then
	alias psg="ps -eawo 'user pid ppid vsz stime etime time tty args' | grep"
	alias startx=/home/${me}/bin/startx
elif [[ $os_type == CYGWIN* ]]; then
    # Cygwin has trouble with the groovy shell
	alias groovysh='stty -icanon min 1 -echo; groovysh --terminal=unix; stty icanon echo'
	alias psg="ps -eaW | grep"
	alias startx=/home/${me}/bin/startx
	# If we have NVMW, add an alias for it.
	if [ -d "$HOME/.nvmw" ]; then
	    alias nvmw=nvmw.bat
	fi
elif [[ $os_type == Darwin ]]; then
	# Set an alias for TextMate
	alias mate=/Applications/TextMate.app/Contents/Resources/mate
	alias psg="ps -eawo 'user pid ppid vsz stime etime time tty args' | grep"
	alias startx=/Users/${me}/bin/startx
else
	echo "$os_type is unknown, chaos will probably ensue..."
fi

# Aliases that depend on variables, like "gradle"
if [ -d "$GRADLE_HOME" ]; then
	alias gradle="${GRADLE_HOME}/bin/gradle"
else 
	alias gradle="gradlew"
fi

if [ -d "$GRAILS_HOME" ]; then
	alias grails="${GRAILS_HOME}/bin/grails"
fi

if [ -d "$ANT_HOME" ]; then
	alias ant="${ANT_HOME}/bin/ant"
fi

if [ -d "$MVN_HOME" ]; then
	alias mvn="${MVN_HOME}/bin/mvn"
fi
