#!/usr/bin/env bash
set -e
echo "start etcd cluster"
# 这里执行的是docker-compose.yml中的command命令
exec "$@"