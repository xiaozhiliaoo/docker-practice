#!/usr/bin/env bash
rm -rf /tmp/logs/mongo/* /tmp/data/mongo/*
# 删除6个容器
docker rm -f mongo-1-1 mongo-1-2 mongo-1-3 mongo-cnf-1 mongo-cnf-2 mongo-cnf-3 mongo-router-1 \
    mongo-router-2 mongo-router-3 mongo-rs1-setup mongo-cnf-setup mongo-shard-setup


#删除1个镜像
docker rmi lili/mongo:1.0

#构建镜像
docker build -t lili/mongo:1.0  .

docker-compose -f docker-compose.rs.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml up -d

echo "wait for running containers for 10s"
sleep 10s
echo "-------------------running containers info-------------------"
docker-compose -f docker-compose.rs.yml -f docker-compose.cnf.yml -f docker-compose.shard.yml ps

MONGO_DIR=/home/admin/app/mongo/mongodb/bin/mongo

sleep 5s
echo "-------------------replset info-------------------"
docker exec mongo-1-1  ${MONGO_DIR} localhost:27017 --eval 'rs.status()'

sleep 5s
echo "-------------------config server info -------------------"
docker exec mongo-cnf-1  ${MONGO_DIR} localhost:27017 --eval 'rs.status()'

sleep 5s
echo "-------------------mongos router info -------------------"
docker exec mongo-router-1  ${MONGO_DIR} localhost:27017 --eval 'sh.status()'

#/home/admin/app/mongo/mongodb/bin/mongo localhost:27017