#!/usr/bin/env bash

rm -rf /tmp/data/etcd/* /tmp/logs/etcd/*

# 删除容器
docker rm -f etcd{0,1,2}

#删除镜像
docker rmi lili/etcd:1.0

#构建镜像
docker build -t lili/etcd:1.0  .

#启动3个容器
docker-compose up -d

#查看运行容器状态
echo "-------------------running containers info-------------------"
docker ps | grep etcd

echo "-------------------etcd cluster status info (dynamic info)-------------------"

#查看master节点的复制信息 etcdctl默认端口是2379
docker exec etcd0 /usr/bin/etcdctl --endpoints="etcd0:2379,etcd1:2369,etcd2:2359"  endpoint status --write-out=table endpoint status

echo "-------------------etcd cluster status info (static info)-------------------"
docker exec etcd0 /usr/bin/etcdctl  member list  --write-out=table endpoint status

