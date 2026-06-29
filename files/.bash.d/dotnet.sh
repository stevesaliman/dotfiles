# Dotnet on a linux box.
if [[ $os_type == Linux ]]; then
    export DOTNET_ROOT=/opt/dotnet

    # Add dotnet, if installed.  Note that we use "-e" because the home dir may be a directory or a
    # symlink
    if [ -n "$DOTNET_ROOT" ] && [ -e "$DOTNET_ROOT" ]; then
        path_suffix="${path_suffix:+${path_suffix}:}$DOTNET_ROOT"
    fi
fi
