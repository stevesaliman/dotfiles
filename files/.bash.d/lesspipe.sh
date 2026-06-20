# Make less friendlier for binary files using lesspipe
if [[ $os_type == Linux ]]; then
    lesspipe="${lesspipe:=/usr/bin/lesspipe}"
elif [[ $os_type == CYGWIN* ]]; then
    lesspipe="${lesspipe:=/usr/bin/lesspipe.sh}"
elif [[ $os_type == Darwin ]]; then
    lesspipe="${lesspipe:=$(brew --prefix)/bin/lesspipe.sh}"
fi
[ -x $lesspipe ] && eval "$(SHELL=/bin/sh $lesspipe)"

