#!/bin/bash
set -e

echo "start tiger service"
tiger_DIR=/home/admin/app/tiger
tiger_CONFIG=${tiger_DIR}/tiger-common.properties
tiger_LOG=${tiger_DIR}/logs

# 替换配置参数
sed -i "s|REDIS_ENDPOINTS|$REDIS_ENDPOINTS|g" ${tiger_CONFIG}
sed -i "s|REDIS_PORT|$REDIS_PORT|g" ${tiger_CONFIG}
sed -i "s|RABBITMQ_ENDPOINTS|$RABBITMQ_ENDPOINTS|g" ${tiger_CONFIG}
sed -i "s|ETCD_ENDPOINTS|$ETCD_ENDPOINTS|g" ${tiger_CONFIG}
sed -i "s|MONGODB_ENDPOINTS|$MONGODB_ENDPOINTS|g" ${tiger_CONFIG}
ulimit -c unlimited

cd /home/admin/app/tiger

JAVA_OPTS=""
PARAM1=${NODE_NAME}
if [ "$PARAM1" = "debug" ] ; then
    echo $PARAM1
    JAVA_OPTS="-Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n"
else
    if [ "$PARAM1" != "" ] ; then
        echo instanceNo = $PARAM1
        JAVA_OPTS="$JAVA_OPTS -DinstanceNo=$PARAM1"
    fi
fi

PORT=""
if [ "${NODE_PORT}" != "" ]; then
    PORT=${NODE_PORT}
    echo "port is " ${PORT}
fi

mkdir -p /opt/tiger
if [ ! -f /opt/tiger/tiger.properties ]; then
    cp tiger.properties /opt/tiger/tiger.properties
    echo copy tiger.properties to /opt/tiger/tiger.properties
fi

if [ ! -f /opt/tiger/tiger-common.properties ]; then
    cp tiger-common.properties /opt/tiger/tiger-common.properties
    echo copy tiger-common.properties to /opt/tiger/tiger-common.properties
fi

if [ "${VIP_SERVER_LIST}" != "" ] ; then
    JAVA_OPTS="$JAVA_OPTS -DvipServerList=${VIP_SERVER_LIST}"
fi

echo JAVA_OPTS=$JAVA_OPTS

echo "java -server -Xms64m -Xmx512m $JAVA_OPTS -Dproject.name=tiger -Dserver.port=$PORT -XX:+UseG1GC -XX:MaxGCPauseMillis=200 -XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${tiger_LOG}/heapdump.hprof -XX:MaxMetaspaceSize=512m -jar tiger.jar"

exec java -server -Xms64m -Xmx512m $JAVA_OPTS -Dproject.name=tiger -Dserver.port=$PORT \
          -XX:+UseG1GC -XX:MaxGCPauseMillis=200 \
          -XX:-HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${tiger_LOG}/heapdump.hprof \
          -XX:MaxMetaspaceSize=512m \
          -jar tiger.jar
#> /dev/null 2>&1 &

# tail -f /dev/null
