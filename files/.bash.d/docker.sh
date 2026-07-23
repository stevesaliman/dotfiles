# Docker and Rancher setup
if [[ $os_type == Linux ]]; then
    # Docker cli plugins
    if [ -d "${df_home}/.docker/cli-plugins" ]; then
        path_prefix="${path_prefix:+${path_prefix}:}${df_home}/.docker/cli-plugins"
    fi
elif [[ $os_type == CYGWIN* ]]; then
    # Rancher Desktop
    if [ -d "${df_home}/.rd/bin" ]; then
      path_prefix="${path_prefix:+${path_prefix}:}${df_home}/.rd/bin"
    fi
elif [[ $os_type == Darwin ]]; then
    # Rancher Desktop
    if [ -d "${df_home}/.rd/bin" ]; then
      path_prefix="${path_prefix:+${path_prefix}:}${df_home}/.rd/bin"
    fi
    export HOMEBREW_NO_ANALYTICS=${HOMEBREW_NO_ANALYTICS:=1}
fi

# Remove all exited docker containers
function drm {
  docker rm $(docker ps -a -f status=exited -q)
}

# Remove all unused images
function drmi {
  docker rmi $(docker images -f dangling=true -q)
}

# Login to a running docker container
function dsh {
  docker exec -it $1 /bin/bash
}

