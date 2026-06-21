# Set up NVM if present
if [[ $os_type == Linux ]]; then
    export NVM_DIR="${NVM_DIR:=/opt/nvm}"
elif [[ $os_type == CYGWIN* ]]; then
    # If we have NVMW, add it to the path
    if [ -d "$HOME/.nvmw" ]; then
      path_suffix="${path_suffix:+${path_suffix}:}$HOME/.nvmw"
      alias nvmw=nvmw.bat
    fi
elif [[ $os_type == Darwin ]]; then
    export NVM_DIR="${NVM_DIR:=/opt/nvm}"
fi

# Load NVM if we have an nvm directory.  The readlink command is used to get the real location of
# $NVM_DIR because nvm has issues with symlinks
export NVM_DIR="$(readlink -f ${NVM_DIR})"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# tabtab source for jhipster package
# uninstall by removing these lines or running `tabtab uninstall jhipster`
[ -f "${NVM_DIR}/versions/node/v6.9.5/lib/node_modules/generator-jhipster/node_modules/tabtab/.completions/jhipster.bash" ] && . "${NVM_DIR}/versions/node/v6.9.5/lib/node_modules/generator-jhipster/node_modules/tabtab/.completions/jhipster.bash"

# Add the rc file hook if nvm is installed.  No need to call it everytime we change directories if
# we don't have any of the commands installed.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    if ! [[ "${PROMPT_COMMAND:-}" =~ _rc_file_hook ]]; then
        PROMPT_COMMAND="_rc_file_hook; ${PROMPT_COMMAND}"
    fi
fi


