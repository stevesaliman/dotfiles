# Zoxide configuration
# Assume a local cargo installation unless we are on a mac.
zoxide_bin="${df_home}/.cargo/bin/zoxide"
if [ $os_type == Darwin ]; then
    zoxide_bin="$(brew --prefix)/bin/zoxide"
fi

if [ -f "$zoxide_bin" ]; then
    eval "$($zoxide_bin init bash)"
    # reduce index scope
    export _ZO_EXCLUDE_DIRS="/tmp:/proc:/sys"
    alias za='zoxide add'
    alias zq='zoxide query'
    alias zr='zoxide remove'
fi


