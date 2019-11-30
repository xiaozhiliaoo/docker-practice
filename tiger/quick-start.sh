#!/usr/bin/env bash


cd environment
rm -rf tiger.tar.gz
tar -zcvf tiger.tar.gz tiger.jar tiger.properties tiger-common.properties start.sh stop.sh version

cd ../


rm -rf /tmp/logs/tiger/*

# 删除6个容器
docker rm -f tiger{1,2,3}

#删除1个镜像
docker rmi lili/tiger:1.0

#构建镜像
docker build -t lili/tiger:1.0  .

#启动3个容器
docker-compose up -d

#查看容器状态
docker-compose ps


