#!/bin/sh

# 默认每个topic 24个分区
if [ -z "$NUM_PARTITIONS" ]; then
    export NUM_PARTITIONS=24
fi
sed -r -i "s/(num.partitions)=(.*)/\1=$NUM_PARTITIONS/g" $KAFKA_HOME/config/server.properties

# 设置broker_id，默认0
if [ -z "$BROKER_ID" ]; then
    export BROKER_ID=0
fi
sed -r -i "s/(broker.id)=(.*)/\1=$BROKER_ID/g" $KAFKA_HOME/config/server.properties

# 设置log.dirs
if [ -z "$LOG_DIRS" ]; then
    export LOG_DIRS=/home/admin/logs/
fi
sed -r -i "s,(log.dirs)=(.*),\1=$LOG_DIRS,g" $KAFKA_HOME/config/server.properties

#  优先log.retention.ms ,其次 log.retention.minutes ，最后 log.retention.hours
# log.retention.hours 消息无法被索引到的时间
if [ -z "$LOG_RETENTION_MINUTES" ]; then
    export LOG_RETENTION_MINUTES=30
fi
sed -r -i "s/(log.retention.minutes)=(.*)/\1=$LOG_RETENTION_MINUTES/g" $KAFKA_HOME/config/server.properties

# log.segment.delete.delay.ms 日志文件真正被删除的时间
if [ -z "$LOG_DELETE_DELAY" ]; then
    export LOG_DELETE_DELAY=259200000
fi
#sed -r -i "s/(log.segment.delete.delay.ms)=(.*)/\1=$LOG_DELETE_DELAY/g" $KAFKA_HOME/config/server.properties
echo -e "\n" >> $KAFKA_HOME/config/server.properties
echo "log.segment.delete.delay.ms=$LOG_DELETE_DELAY" >> $KAFKA_HOME/config/server.properties

# 设置port listeners
if [ -z "$SERVER_PORT" ]; then
    export SERVER_PORT=9092
fi
if [ -z "$SERVER_IP" ]; then
    export SERVER_IP=127.0.0.1
fi
sed -r -i "s@^#?listeners=.*@listeners=PLAINTEXT://$SERVER_IP:$SERVER_PORT@g" $KAFKA_HOME/config/server.properties

# 设置 zookeeper-connect
if [ -z "$ZOOKEEPER_CONNECT" ]; then
    export ZOOKEEPER_CONNECT=localhost:2181
fi
sed -r -i "s/(zookeeper.connect)=(.*)/\1=$ZOOKEEPER_CONNECT/g" $KAFKA_HOME/config/server.properties

# # Set the zookeeper chroot
# if [ ! -z "$ZK_CHROOT" ]; then
#     # wait for zookeeper to start up
#     until /usr/share/zookeeper/bin/zkServer.sh status; do
#       sleep 0.1
#     done

#     # create the chroot node
#     echo "create /$ZK_CHROOT \"\"" | /usr/share/zookeeper/bin/zkCli.sh || {
#         echo "can't create chroot in zookeeper, exit"
#         exit 1
#     }

#     # configure kafka
#     sed -r -i "s/(zookeeper.connect)=(.*)/\1=localhost:2181\/$ZK_CHROOT/g" $KAFKA_HOME/config/server.properties
# fi

# Run Kafka,需要保证zk 已经启动
mkdir -p $LOG_DIRS
sleep 1s
exec $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
#tail -f /dev/null