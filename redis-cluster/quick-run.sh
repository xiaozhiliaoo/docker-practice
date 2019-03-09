#!/usr/bin/env bash
# set -e

isNetWorkExist=$(docker network ls | grep lili-bridge-network)
if [ "${isNetWorkExist}" ];then
    echo "lili-bridge-network is exist "
else
    docker network create lili-bridge-network
fi

# 删除6个容器
docker rm -f redis{1,2,3}

#删除1个镜像
docker rmi lili/redis-cluster:1.0

#构建镜像
docker build -t lili/redis-cluster:1.0  .

#启动6个容器
docker-compose up -d

#查看运行容器状态
echo "-------------------running containers info-------------------"
# docker ps
docker-compose ps

echo "-------------------redis master info-------------------"


