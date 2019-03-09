FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

ENV ETCD_DIR=/home/admin/app/etcd

ADD ["environment/etcd3.2.9.tar.gz", "environment/docker-entrypoint.sh", "${ETCD_DIR}/"]

USER root

RUN chmod +x ${ETCD_DIR}/docker-entrypoint.sh && rpm -ivh --force  /home/admin/app/etcd/*.rpm

VOLUME /home/admin/data/etcd

# 如果子容器没有ENTRYPOINT的话，会默认进入父容器docker-base的ENTRYPOINT，从而导致docker-compose.yml中的command命令会无效
# docker logs container_name的日志是容器的日志(包括父子进程的),如果日志写入文件，则不再显示
# 如果在docker-entrypoint.sh里面执行etcd(相当于fork),那么pid=1的进程为docker-entrypoint.sh,子进程是etcd,如果是exec etcd，则pid=1的进程为etcd
# fork和exec区别：fork创建子进程，而exec：新进程代替老进程
ENTRYPOINT ["/home/admin/app/etcd/docker-entrypoint.sh"]
