# Java configuration.  We'll configure tomcat here too.
if [[ $os_type == Linux ]]; then
    export JAVA_OPTS="${JAVA_OPTS:=-Xmx256m -Xms256m}"
    # export CATALINA_HOME="${CATALINA_HOME:=/opt/tomcat-8.0.39}"
    # cat_opts="-XX:PermSize=64m -XX:MaxPermSize=256m"
    # cat_opts="$cat_opts -Xms512m -Xmx512m -Djava.awt.headless=true"
    # export CATALINA_OPTS="${CATALINE_OPTS:=$cat_opts}"
elif [[ $os_type == CYGWIN* ]]; then
    export CATALINA_HOME="${CATALINA_HOME:=/cygdrive/c/opt/tomcat-8.0.39}"
    #export CATALINA_PID-$CATALINA_HOME/work/catalina.pid
    cat_opts="-XX:PermSize=64m -XX:MaxPermSize=256m"
    cat_opts="$cat_opts -Xms512m -Xmx512m -Djava.awt.headless=true"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote.port=9012"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote.ssl=false"
    #cat_opts="$cat_opts -Dcom.sun.management.jmxremote.authenticate=false"
    export CATALINA_OPTS="${CATALINA_OPTS:=$cat_opts}"
elif [[ $os_type == Darwin ]]; then
    export CATALINA_HOME=/opt/tomcat-8.0.39
    cat_opts="-XX:PermSize=64m -XX:MaxPermSize=256m"
    cat_opts="$cat_opts -Xms512m -Xmx512m -Djava.awt.headless=true"
    export CATALINA_OPTS="${CATALINA_OPTS:=$cat_opts}"
fi

if [ -n "$CATALINA_HOME" ]; then
    path_suffix="${path_suffix:+${path_suffix}:}/$CATALINA_HOME/bin"
    alias catalina=catalina.sh
fi

