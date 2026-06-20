# Setup SDKMan
if [[ $os_type == Linux ]]; then
    export SDKMAN_DIR="${SDKMAN_DIR:=/opt/sdkman}"
elif [[ $os_type == CYGWIN* ]]; then
    export SDKMAN_DIR="${SDKMAN_DIR:=/cygdrive/c/opt/sdkman}"
elif [[ $os_type == Darwin ]]; then
    export SDKMAN_DIR="${SDKMAN_DIR:=/opt/sdkman}"
fi
# Add SDKMan if it is installed.
[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"

