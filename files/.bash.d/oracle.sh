# Configure Oracle if present
if [[ $os_type == Linux ]]; then
    export ORACLE_HOME="${ORACLE_HOME:=/opt/oracle/product/19.3}"
    export ORACLE_SID="${ORACLE_SID:=devl}"
elif [[ $os_type == CYGWIN* ]]; then
    export ORACLE_HOME="${ORACLE_HOME:/cygdrive/c/opt/oracle/product/11.2.0}"
fi

# By default, we're not using Oracle's instant client.
instant_client=${instant_client:=0}

# Set the Oracle path.  Setting LD_LIBRARY_PATH appears to interfere with Python, so we won't add
# it to the library path.
if [ -n "$ORACLE_HOME" ]; then
    if [ $instant_client == 1 ]; then
        path_suffix="${path_suffix:+${path_suffix}:}$ORACLE_HOME"
        # export local_libs=${local_libs:+${local_libs}:}$ORACLE_HOME
    else
        path_suffix="${path_suffix:+${path_suffix}:}$ORACLE_HOME/bin"
        # export local_libs=${local_libs:+${local_libs}:}$ORACLE_HOME/lib
    fi
fi

# For some reason, I can't execute sqlplus from Cygwin if ORACLE_HOME is set, so now that it is in
# the path, unset the var.  We also need to change $HOME to the "mounted" network directory instead
# of the cygdrive link.
if [[ $os_type == CYGWIN* ]]; then
    echo "Unsetting ORACLE_HOME for cygwin"
    unset ORACLE_HOME
fi

