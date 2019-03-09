#!/usr/bin/env bash
# set -e

isNetWorkExist=$(docker network ls | grep lili-bridge-network)
if [ "${isNetWorkExist}" ];then
    echo "lili-bridge-network is exist "
else
    docker network create lili-bridge-network
fi

rm -rf /tmp/data/redis/* /tmp/logs/redis/*

# 删除6个容器
docker rm -f redis-master redis-slave{1,2} sentinel{1,2,3}

#删除1个镜像
docker rmi lili/redis:1.0

#构建镜像
docker build -t lili/redis:1.0  .

#启动6个容器
docker-compose up -d

#查看运行容器状态
echo "-------------------running containers info-------------------"
# docker ps
docker-compose ps

echo "-------------------redis master info-------------------"

#查看master节点的复制信息
docker exec redis-master /usr/bin/redis-cli -p 6379 -a lili info Replication

echo "-------------------redis slave1 info-------------------"

docker exec redis-slave1 /usr/bin/redis-cli -p 6389 -a lili info Replication

echo "-------------------redis slave2 info-------------------"

docker exec redis-slave2 /usr/bin/redis-cli -p 6399 -a lili info Replication

echo "-------------------redis sentinel1 info-------------------"
#查看sentinel1节点的信息
docker exec sentinel1 /usr/bin/redis-cli -p 26379 -a lili info Sentinel

echo "-------------------redis sentinel2 info-------------------"
#查看sentinel2节点的信息
docker exec sentinel2 /usr/bin/redis-cli -p 26389 -a lili info Sentinel
echo "-------------------redis sentinel3 info-------------------"
#查看sentinel3节点的信息
docker exec sentinel3 /usr/bin/redis-cli -p 26399 -a lili info Sentinel

