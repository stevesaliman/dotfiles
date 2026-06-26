# Setup fzf

# If it isn't installed, we can return here.
if [ ! -d "${bash_script_dir}/.fzfx" ]; then
    echo "Not Found!"
    return
fi

# Add it to the path if it isn't there already.
if [[ ! "$PATH" == *${bash_script_dir}/.fzf/bin* ]]; then
    echo "Found!"
  PATH="${PATH:+${PATH}:}/home/ssaliman/.fzf/bin"
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
export BAT_THEME="Steve"
#export BAT_THEME="ansi"
# Need to check in this file (under another name), and the .config/bat/ directory
# Need to tweak the syntax files to get keywords sorted into 2 sets
