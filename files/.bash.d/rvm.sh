# Load RVM if present
if [[ $os_type == Linux ]]; then
    export RVM_DIR="${RVM_DIR:=/opt/rvm}"
elif [[ $os_type == CYGWIN* ]]; then
    export RVM_DIR="${RVM_DIR:=/cygdrive/c/opt/rvm}"
elif [[ $os_type == Darwin ]]; then
    export RVM_DIR="${RVM_DIR:=/opt/rvm}"
fi

# Load RVM into a shell session *as a function*
[[ -s "${RVM_DIR}/scripts/rvm" ]] && source "${RVM_DIR}/scripts/rvm"

# Add rvm to the path, if we've got RVM
if [ -d "${RVM_DIR}/bin" ]; then
    path_prefix="${path_prefix:+${path_prefix}:}${RVM_DIR}/bin"
fi

