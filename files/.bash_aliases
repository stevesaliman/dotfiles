# This file loads the default aliases we want to use in our shell.
#
# This file doesn't have all the aliases we'll use.  Configuration fragments can add to, or override
# The aliaes in this file.  For example, the alias for nvm in a cygwin environment is in the nvm
# fragment, and the final aliases for ls are determined by the eza fragment.

# aliases that are not OS specific. It assumes that color ls is before /bin/ls in the path, and that
# OSX machines have the GNU coreutils installed.
alias backup='sudo ~/bin/backup.sh -d ${BACKUP_HOME} -u ${USER}'
alias backup_data='sudo rsync -avi --delete --exclude=/usr/local/oradata/ /usr/local/ /var/run/media/${USER}/Elements/${HOSTNAME%%.*}/usr/local | grep -v \.[fd]\/\/\/pog\.\.\.'
alias cls=clear
alias diffr='diff -r -X ~/.diff_excludes'
alias dir='ls --color --human-readable -lFa'
alias df='df -h'
alias du='du -hx'
alias gradled='gw $@ --no-daemon -Dorg.gradle.debug=true'
alias grep='grep --color'
alias gsu='git status -uno'
alias kc=kubectl
alias lame='lame -q 2 -b 256'
alias less='less -R'
alias ls='ls --color --human-readable -FA'
alias lstr='ls --color --human-readable -lFatr'
alias mk=minikube
alias mk-env='eval $(minikube docker-env)'
alias ms=minishift
alias ms-env='eval $(minishift oc-env); eval $(minishift docker-env)'
alias nyx='telnet nyx10.nyx.net'
alias path='echo $PATH'
alias scp='scp -p'
alias unkube='unset ${!DOCKER_*}'
alias vil=vi
alias vt100='set term=vt100; stty rows 24'
# Aliases ending with a space causes the next word to be checked for aliases.
# Without it, the watch command can't use aliases as commands.
alias watch='watch '
alias which=type

# Aliases that differ by OS.
if [[ $os_type == Linux ]]; then
	alias psg="ps -eawo 'user pid ppid vsz stime etime time tty args' | grep"
	alias startx=/home/${me}/bin/startx
elif [[ $os_type == CYGWIN* ]]; then
    # Cygwin has trouble with the groovy shell
	alias groovysh='stty -icanon min 1 -echo; groovysh --terminal=unix; stty icanon echo'
	alias psg="ps -eaW | grep"
	alias startx=/home/${me}/bin/startx
elif [[ $os_type == Darwin ]]; then
	# Set an alias for TextMate
	alias mate=/Applications/TextMate.app/Contents/Resources/mate
	alias psg="ps -eawo 'user pid ppid vsz stime etime time tty args' | grep"
	alias startx=/Users/${me}/bin/startx
else
	echo "$os_type is unknown, chaos will probably ensue..."
fi
