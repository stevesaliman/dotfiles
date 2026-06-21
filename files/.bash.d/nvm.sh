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

# Helper function to run "nvm use" when we change to a directory that has an .nvmrc file in it. The
# method name starts with an underscore because we don't intend for anyone to call it directly, but
# is used in the PROMPT_COMMAND
_nvmrc_hook() {
    if [[ $PWD == $PREV_PWD ]]; then
        return
    fi

    PREV_PWD=$PWD

    if [[ -f ".nvmrc" && -s "$NVM_DIR/nvm.sh" ]]; then
        nvm use
        # Angular CLI autocomletion, if we have Angular installed.
        if type "ng" > /dev/null 2>&1; then
            source <(ng completion script)
        fi
    fi
}

# Add the nvmrrc hook if nvm is installed, and we don't already have the hook in the prompt command.
# No need to call it everytime we change directories if we don't have any of the commands installed.
if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    if ! [[ "${PROMPT_COMMAND:-}" =~ _nvmrc_hook ]]; then
        PROMPT_COMMAND="_nvmrc_hook; ${PROMPT_COMMAND}"
    fi
fi


