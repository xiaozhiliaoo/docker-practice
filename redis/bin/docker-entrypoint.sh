#!/bin/sh
set -e

# 每次docker容器启动都会运行，追加配置要做到幂等
CONFIG_FILE=$2
echo "dir ${DATA_DIR}/" >> ${CONFIG_FILE}
echo "pidfile ${LOGS_DIR}/redis.pid" >> ${CONFIG_FILE}
echo "logfile ${LOGS_DIR}/redis.log" >> ${CONFIG_FILE}

exec "$@"
