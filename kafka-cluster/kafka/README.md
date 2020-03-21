参考 https://github.com/spotify/docker-kafka

docker run -tid -e SERVER_IP=127.0.0.1 -e SERVER_PORT=9092 LOG_DIRs=/home/admin/logs/ -e ZOOKEEPER_CONNECT=broker1:2181,broker2:2181 [imageid]