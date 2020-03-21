#!/bin/bash -e

if [[ -z "$MACHINE_IP" ]]; then
    export MACHINE_IP="127.0.0.1"
fi
MACHINE_IP=`echo $MACHINE_IP | sed -e 's/ //g'`
export MACHINE_IP
export KAFKA_LISTENERS="PLAINTEXT://$MACHINE_IP:9092"
unset MACHINE_IP
export KAFKA_HOME="/home/admin/kafka_2.11-1.1.1/"

if [[ -z "$KAFKA_LOG_DIRS" ]]; then
    export KAFKA_LOG_DIRS="/home/admin/logs/kafka"
fi

#Issue newline to config file in case there is not one already
echo "" >> "$KAFKA_HOME/config/server.properties"

(
    function updateConfig() {
        key=$1
        value=$2
        file=$3

        # Omit $value here, in case there is sensitive information
        echo "[Configuring] '$key' in '$file'"

        # If config exists in file, replace it. Otherwise, append to file.
        if grep -E -q "^#?$key=" "$file"; then
            sed -r -i "s@^#?$key=.*@$key=$value@g" "$file" #note that no config values may contain an '@' char
        else
            echo "$key=$value" >> "$file"
        fi
    }

    # Fixes #312
    # KAFKA_VERSION + KAFKA_HOME + grep -rohe KAFKA[A-Z0-0_]* /opt/kafka/bin | sort | uniq | tr '\n' '|'
    EXCLUSIONS="|KAFKA_VERSION|KAFKA_HOME|KAFKA_DEBUG|KAFKA_GC_LOG_OPTS|KAFKA_HEAP_OPTS|KAFKA_JMX_OPTS|KAFKA_JVM_PERFORMANCE_OPTS|KAFKA_LOG|KAFKA_OPTS|"

    # Read in env as a new-line separated array. This handles the case of env variables have spaces and/or carriage returns. See #313
    IFS=$'\n'
    for VAR in $(env)
    do
        env_var=$(echo "$VAR" | cut -d= -f1)
        if [[ "$EXCLUSIONS" = *"|$env_var|"* ]]; then
            echo "Excluding $env_var from broker config"
            continue
        fi

        if [[ $env_var =~ ^KAFKA_ ]]; then
            kafka_name=$(echo "$env_var" | cut -d_ -f2- | tr '[:upper:]' '[:lower:]' | tr _ .)
            updateConfig "$kafka_name" "${!env_var}" "$KAFKA_HOME/config/server.properties"
        fi
    done

    updateConfig "dataDir" "/home/admin/data/zookeeper" "$KAFKA_HOME/config/zookeeper.properties"
)



#exec "$KAFKA_HOME/bin/kafka-server-start.sh" "$KAFKA_HOME/config/server.properties"