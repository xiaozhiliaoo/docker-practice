#!/bin/bash
JAVA_HOME=/home/mx/jdk1.8.0_172
PATH=$PATH:$JAVA_HOME/bin:$JAVA_HOME/jre/bin
export JAVA_HOME
export PATH

# support core dump
ulimit -c unlimited

# locate working directory
cd /home/mx/tiger

JAVA_OPTS=""
PARAM1=$1
if [ "$PARAM1" = "debug" ] ; then
        echo $PARAM1
        JAVA_OPTS="-Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
else
        if [ "$PARAM1" != "" ] ; then
                echo instanceNo = $PARAM1
                JAVA_OPTS="$JAVA_OPTS -DinstanceNo=$PARAM1"
        fi
fi

PORT=9666
if [ "$2" != "" ] ; then
        PORT=$2
        echo PORT=$PORT
fi

mkdir -p /opt/tiger
if [ ! -f /opt/tiger/tiger.properties ]
then
        cp tiger.properties /opt/tiger/tiger.properties
        echo copy tiger.properties to /opt/tiger/tiger.properties
fi

if [ ! -f /opt/tiger/tiger-common.properties ]
then
        cp tiger-common.properties /opt/tiger/tiger-common.properties
        echo copy tiger-common.properties to /opt/tiger/tiger-common.properties
fi
if [ "$3" != "" ] ; then
        JAVA_OPTS="$JAVA_OPTS -DvipServerList=$3"
fi
echo JAVA_OPTS=$JAVA_OPTS

java -server -Xms64m -Xmx512m $JAVA_OPTS -Dproject.name=tiger -Dserver.port=$PORT \
-XX:+UseG1GC -XX:MaxGCPauseMillis=200 \
-XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/mx/tiger/logs/heapdump.hprof \
-XX:MaxMetaspaceSize=512m \
-jar tiger.jar > /dev/null 2>&1 &
