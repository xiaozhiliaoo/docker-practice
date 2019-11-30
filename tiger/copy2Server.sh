#!/usr/bin/env bash

#docker save mx/uds:1.0  > uds.tar

scp docker-compose.yml root@47.105.112.18:/home/docker-images/uds/
scp uds.tar root@47.105.112.18:/home/docker-images/uds/