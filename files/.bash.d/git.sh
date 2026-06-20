# Configuration for git
# Specify what git statuses we want to see. By default, we want 'em all.
export GIT_PS1_SHOWDIRTYSTATE=${GIT_PS1_SHOWDIRTYSTATE:=1}
export GIT_PS1_SHOWSTASHSTATE=${GIT_PS1_SHOWSTASHSTATE:=1}
export GIT_PS1_SHOWUNTRACKEDFILES=${GIT_PS1_SHOWUNTRACKEDFILES:=1}
export GIT_PS1_SHOWUPSTREAM=${GIT_PS1_SHOWUPSTREAM:=1}

if [[ $os_type == CYGWIN* ]]; then
    # Showing the stash state causes performance issues in cygwin.
    export GIT_PS1_SHOWSTASHSTATE=0
fi
