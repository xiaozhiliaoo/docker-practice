#!/usr/bin/env bash

set -e

echo "start redis ... "

MASTER_CONF_PATH=/home/admin/data/redis/conf/redis-master.conf
SLAVE_CONF_PATH=/home/admin/data/redis/conf/redis-slave.conf
SENTINEL_CONF_PATH=/home/admin/data/redis/conf/redis-sentinel.conf


# 开始主节点
if [ "$MASTER" ]; then
    echo "master start ..."
    # 替换master里面的端口号
    sed -i "s/\$PORT/$PORT/g" ${MASTER_CONF_PATH}
    # 如果有exec，使得redis进程成为pid=1进程，否则docker-entrypoint.sh将会是pid=1的进程，而redis-server为子进程
    # 此时redis挂了，容器退出，一定会触发restart的。
    # 如果没有exec，redis配置daemonize no，redis进程挂了，会自动restart，因为redis进程退出导致docker-entrypoint.sh
    # 结束，从而导致容器退出，此时会restart。如果yes，容器将启动不了，需加tail -f /dev/null 已阻止容器退出， 但是这时候
    # redis挂了，将不会触发restart，因为容器中所有进程退出的时候才会restart，容器推崇每个容器中运行一个进程，以解耦应用
    # https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#decouple-applications
    exec /usr/bin/redis-server ${MASTER_CONF_PATH}
fi

#开启从节点
if [ "$SLAVE" ]; then
    echo "slave start ..."
    sed -i "s/\$SLAVE_OF/$SLAVE_OF/g" ${SLAVE_CONF_PATH}
    sed -i "s/\$PORT/$PORT/g" ${SLAVE_CONF_PATH}
    exec /usr/bin/redis-server ${SLAVE_CONF_PATH}
fi

#开始哨兵节点
if [ "$SENTINEL" ]; then
    echo "sentinel start ..."
    sed -i "s/\$PORT/$PORT/g" ${SENTINEL_CONF_PATH}
    sed -i "s/\$MASTER_INFO/$MASTER_INFO/g" ${SENTINEL_CONF_PATH}
    exec /usr/bin/redis-sentinel ${SENTINEL_CONF_PATH}
fi