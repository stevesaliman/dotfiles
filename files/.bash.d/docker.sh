# Docker and Rancher setup
if [[ $os_type == Linux ]]; then
    # Docker cli plugins
    if [ -d "${bash_script_dir}/.docker/cli-plugins" ]; then
        path_prefix="${path_prefix:+${path_prefix}:}${bash_script_dir}/.docker/cli-plugins"
    fi
elif [[ $os_type == CYGWIN* ]]; then
    # Rancher Desktop
    if [ -d "${bash_script_dir}/.rd/bin" ]; then
      path_prefix="${path_prefix:+${path_prefix}:}${bash_script_dir}/.rd/bin"
    fi
elif [[ $os_type == Darwin ]]; then
    # Rancher Desktop
    if [ -d "${bash_script_dir}/.rd/bin" ]; then
      path_prefix="${path_prefix:+${path_prefix}:}${bash_script_dir}/.rd/bin"
    fi
    export HOMEBREW_NO_ANALYTICS=${HOMEBREW_NO_ANALYTICS:=1}
fi

