# Setup fzf.  There are 2 ways it could be installed; locally in ~/.fzf, or globally via apt, homebrew, etc.
# This script makes sure a local installation is on the path, then looks for the command to see if it should
# continue.


local_fzf_home="${df_home}/.fzf"

# If the local fzf home exists, and it isn't already in the path, add it.
if [[ -d "${local_fzf_home}" ]] && [[ ! "$PATH" == *${local_fzf_home}/bin* ]]; then
  PATH="${PATH:+${PATH}:}${local_fzf_home}/bin"
fi

# If fzf isn't installed, we can return here.
if [ ! $(type -P fzf) ]; then
    echo "Fzf not Found, skipping"
    unset local_fzf_home
    return
fi

# Use exact match by default, and put the prompt at the top. Disable unicode to use ascii borders
# For colors, -1=inherit from terminal.
export FZF_DEFAULT_OPTS="--exact --reverse --no-unicode"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=fg:-1,fg+:-1"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=bg:-1,bg+:#656565"
export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color=hl:#5f87af,hl+:#5fffff"

eval "$(fzf --bash)"

alias fcd='cd $(fzf --walker=dir)'
alias fvi='vi $(fzf --walker=file --preview='\''bat {}'\'')'
alias fopen='open $(fzf --walker=file --preview='\''bat {}'\'')'

# For bat...
# If bat was installed from apt, the command will be called batcat, so make an alias.
if [ $(type -P batcat) ]; then
    alias bat=batcat
fi

export BAT_THEME="Steve"
#export BAT_THEME="ansi"
# Need to check in this file (under another name), and the .config/bat/ directory
# Need to tweak the syntax files to get keywords sorted into 2 sets

unset local_fzf_home
