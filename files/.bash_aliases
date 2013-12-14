# This file loads all the aliases we want to use in our shell. It is sourced
# by .bashrc

# standard aliases - make sure color ls is before /bin/ls in the path.
alias backup='sudo rsync -avi --delete --exclude=/media/ --exclude=/run/ --exclude=/var/run/media/ --exclude=/run/media/ --exclude=/var/run/user --exclude=/proc/ --exclude=/var/lib/ntp/proc/ --exclude=/sys/ / /var/run/media/steve/Elements/valen | grep -v \.[fd]\/\/\/pog\.\.\.'
alias backup_data='sudo rsync -avi --delete --exclude=/usr/local/oradata/ /usr/local/ /var/run/media/steve/Elements/valen/usr/local | grep -v \.[fd]\/\/\/pog\.\.\.'
alias catalina=catalina.sh
alias cls=clear
alias df='df -h'
alias du='du -hx'
alias grep='grep --color'
alias lame='lame -q 2 -b 256'
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
if [[ $os_type == Linux ]]; then
    alias dir='ls --color --human-readable -lFa'
    alias ls='ls --color --human-readable -FA'
	alias psg='ps -eawo "user pid ppid vsz stime etime time tty args" | grep "$1"
elif [[ $os_type == CYGWIN* ]]; then
    alias dir='ls --color --human-readable -lFa'
    # Cygwin has trouble with the groovy shell
	alias groovysh='stty -icanon min 1 -echo; groovysh --terminal=unix; stty icanon echo'
    alias ls='ls --color --human-readable -FA'
	alias psg="ps -eaW | grep"
elif [[ $os_type == Darwin ]]; then
    alias dir='ls -lFaGh'
    alias ls='ls -FAGh'
	# Set an alias for TextMate
	alias mate=/Applications/TextMate.app/Contents/Resources/mate
	alias psg='ps -eawo "user pid ppid vsz stime etime time tty args" | grep'
else
	echo "$os_type is unknown, chaos will probably ensue..."
fi

# Aliases that depend on variables, like "gradle"
if [ -n "$GRADLE_HOME" ]; then
	alias gradle="${GRADLE_HOME}/bin/gradle"
	alias gradled='export GRADLE_OPTS=export GRADLE_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y"'
else 
	alias gradle="gradlew"
	alias gradled='export GRADLE_OPTS=export GRADLE_OPTS="-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,address=5005,server=y,suspend=y"'
fi

if [ -n "$ANT_HOME" ]; then
	alias ant="${ANT_HOME}/bin/ant"
fi

if [ -n "$MVN_HOME" ]; then
	alias mvn="${MVN_HOME}/bin/mvn"
fi
