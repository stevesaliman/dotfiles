# This file loads all the aliases we want to use in our shell. It is sourced
# by .bashrc

# standard aliases - make sure color ls is before /bin/ls in the path.
# Also make sure OSX machines has the GNU coreutils installed.
alias backup='sudo ~/bin/backup.sh -d ${BACKUP_HOME} -u ${USER}'
alias backup_data='sudo rsync -avi --delete --exclude=/usr/local/oradata/ /usr/local/ /var/run/media/${USER}/Elements/${HOSTNAME%%.*}/usr/local | grep -v \.[fd]\/\/\/pog\.\.\.'
alias catalina=catalina.sh
alias cls=clear
alias deploy='sudo /usr/local/bin/deploy.sh'
alias dir='ls --color --human-readable -lFa'
alias df='df -h'
alias du='du -hx'
alias gradled='gradle $@ --no-daemon -Dorg.gradle.debug=true'
alias grep='grep --color'
alias gsu='git status -uno'
alias kc=kubectl
alias lame='lame -q 2 -b 256'
alias less='less -R'
alias ls='ls --color --human-readable -FA'
alias microdeploy='sudo /usr/local/bin/microdeploy.sh'
alias mk=minikube
alias mk-env='eval $(minikube docker-env)'
alias ms=minishift
alias ms-env='eval $(minishift oc-env); eval $(minishift docker-env)'
alias nyx='telnet nyx10.nyx.net'
alias path='echo $PATH'
alias prepare="gradle -PenvironmentName=${environment_name} clean; gradle -PenvironmentName=${environment_name} -x test stageRelease"
alias scp='scp -p'
alias unkube='unset ${!DOCKER_*}'
alias vil=vi
alias vt100='set term=vt100; stty rows 24'
# Aliases ending with a space causes the next word to be checked for aliases.
# Without it, the watch command can't use aliases as commands.
alias watch='watch '
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
