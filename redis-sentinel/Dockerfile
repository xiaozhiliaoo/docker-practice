FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

ENV REDIS_DIR=/home/admin/app/redis
ADD ["environment/redis3.2.10.tar.gz", "environment/docker-entrypoint.sh" ,"${REDIS_DIR}/"]
COPY ["environment/redis-master.conf","environment/redis-sentinel.conf","environment/redis-slave.conf", \
     "/home/admin/data/redis/conf/"]

USER root
RUN chmod +x ${REDIS_DIR}/docker-entrypoint.sh && \
     rpm -ivh --force --nodeps ${REDIS_DIR}/*.rpm

#这里必须要指定/home/admin/data/redis/data，否则redis-sentinel.conf中dir将报错,如果logfile
#是/home/admin/logs/redis/redis-sentinel.log，则也要添加/home/admin/logs/redis
VOLUME /home/admin/data/redis/data

ENTRYPOINT ["/home/admin/app/redis/docker-entrypoint.sh"]

