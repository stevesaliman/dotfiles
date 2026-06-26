# Setup fzf
fzf_home="${bash_script_dir}/.fzf"
# If it isn't installed, we can return here.
if [ ! -d "${fzf_home}" ]; then
    echo "Fzf not Found, skipping"
    unset fzf_home
    return
fi

# Add it to the path if it isn't there already.
if [[ ! "$PATH" == *${fzf_home}/bin* ]]; then
  PATH="${PATH:+${PATH}:}${fzf_home}/bin"
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

unset fzf_home
