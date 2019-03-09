#!/usr/bin/env bash

#docker save mx/mongo:1.0  > mongo.tar
scp mongo.tar root@47.105.112.18:/home/docker-images/mongo/
scp docker-compose.cnf.yml docker-compose.rs.yml docker-compose.shard.yml root@47.105.112.18:/home/docker-images/mongo/