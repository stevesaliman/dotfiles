# Configuration fragment for starship

# function to enable/disable a starship module.  This function takes advantage of the fact that
# starship reads the config every time it runs.  It takes 2 arguments; a module name, and either
# "on" or "off".  This function makes a couple of assumptions:
# 1. The module being used exists in the starship.toml file.
# 2. The disabled option is the first thing after the module name itself.
function st-mod {
    if [ "$#" -lt 2 ]; then
      echo "usage: st-mod <module name> on|off"
      return 1
    fi
    # Starship uses a disable flag, but our arg acts as an enable flag, so we reverse it here...
    if [ $2 = "on" ]; then
        local newval="false"
    else
        local newval="true"
    fi
    # Start by making a new config file for just this shell, if we don't already have one.  We'll
    # use the bash "$$" variable to get the shell's PID.  We then set an environment variable to
    # tell starship that we want to use our new file as the config file.
    local default_config=$HOME/.config/starship.toml
    local local_config=/tmp/starship/starship-$$.toml
    if [ ! -f $local_config ]; then
        mkdir -p /tmp/starship
        cp $default_config $local_config
        export STARSHIP_CONFIG=${local_config}
    fi

    sed -i "/\[$1\]/{n;s/.*/disabled = $newval/;}" $local_config
}

