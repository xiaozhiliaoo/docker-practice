# 注意事项
## docker 启动需要传入如下环境变量
1. MACHINE_IP=127.0.0.1 （默认）
2. KAFKA_LOG_DIRS=/home/admin/logs/kafka （默认）
   
## 启动时 指定-e 参数
docker run -tid -e MACHINE_IP=127.0.0.1 --name=zookeeper-kafka --net=host  -v /home/admin/logs/zookeeper-kafka:/home/admin/logs --privileged=true [imageid]