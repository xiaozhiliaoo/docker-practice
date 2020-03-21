#!/bin/bash
ulimit -c unlimited
mkdir -p /home/admin/logs/
cd $APP_HOME

if [ -z "$KAFKA_IP" ]; then
    export KAFKA_IP=127.0.0.1:9092
fi
sed -r -i "s/(spring.kafka.bootstrap-servers)=(.*)/\1=$KAFKA_IP/g" $APP_HOME/application.properties

if [ -z "$PORT" ]; then
    export PORT=8011
fi
sed -r -i "s/(server.port)=(.*)/\1=$PORT/g" $APP_HOME/application.properties

exec java -Djava.library.path=/home/admin/sigar/ -jar $APP_HOME/monitor.jar  -server -Xms2g -Xmx2g -Xmn1g -XX:MetaspaceSize=256m -XX:MaxMetaspaceSize=256m -XX:MaxDirectMemorySize=1g -XX:SurvivorRatio=10 -XX:+UseConcMarkSweepGC -XX:CMSMaxAbortablePrecleanTime=5000 -XX:+CMSClassUnloadingEnabled -XX:CMSInitiatingOccupancyFraction=80 -XX:+UseCMSInitiatingOccupancyOnly -XX:+ExplicitGCInvokesConcurrent -Dsun.rmi.dgc.server.gcInterval=2592000000 -Dsun.rmi.dgc.client.gcInterval=2592000000 -XX:ParallelGCThreads=24 -Xloggc:/home/admin/logs/gc.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/home/admin/logs/java.hprof --logging.path=/home/admin/logs/