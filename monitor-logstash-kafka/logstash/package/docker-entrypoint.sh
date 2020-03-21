#!/bin/bash
mkdir -p /home/admin/logs/

if [ -z "$LOGSTASH_LISTEN_PORT" ]; then
    export LOGSTASH_LISTEN_PORT=5044
fi
sed -r -i "s,LOGSTASH_LISTEN_PORT,$LOGSTASH_LISTEN_PORT,g" /etc/logstash/conf.d/logstash.pipeline.conf

if [ -z "$LOGSTASH_TOPIC_NAME" ]; then
    export LOGSTASH_TOPIC_NAME=device_info
fi
sed -r -i "s,LOGSTASH_TOPIC_NAME,$LOGSTASH_TOPIC_NAME,g" /etc/logstash/conf.d/logstash.pipeline.conf

if [ -z "$LOGSTASH_KAFKA_ADDRESS" ]; then
    export LOGSTASH_KAFKA_ADDRESS=kafka:9092
fi
sed -r -i "s,LOGSTASH_KAFKA_ADDRESS,$LOGSTASH_KAFKA_ADDRESS,g" /etc/logstash/conf.d/logstash.pipeline.conf

cp -f /etc/logstash/conf.d/logstash.pipeline.conf /home/admin/logs/
exec /usr/share/logstash/bin/logstash "--path.settings" "/etc/logstash" "--path.config" "/etc/logstash/conf.d"