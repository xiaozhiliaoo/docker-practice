#!/usr/bin/env bash

rm -rf /tmp/data/rabbitmq/*  /tmp/logs/rabbitmq/*

# 删除6个容器
docker rm -f rabbit{1,2,3}

#删除1个镜像
docker rmi lili/rabbitmq:1.0

#构建镜像
docker build -t lili/rabbitmq:1.0  .

#启动6个容器
docker-compose up -d

#echo "-------------------running containers info-------------------"
#这里有可能启动一会，rabbitmq挂了，导致容器全挂了，所以信息可能并不准
#docker ps | grep rabbit
docker-compose ps

echo "-------------------rabbitmq cluster status info -------------------"

docker exec rabbit1 /bin/bash rabbitmqctl cluster_status
docker exec rabbit2  /bin/bash rabbitmqctl cluster_status
docker exec rabbit3  /bin/bash rabbitmqctl cluster_status

echo "please visit web manangment console at http://localhost:15672/#/"


