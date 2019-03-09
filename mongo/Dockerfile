FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

ENV MONGO_DIR=/home/admin/app/mongo

ADD ["environment/mongodb3.6.0.tar.gz","environment/docker-entrypoint.sh","environment/init-shard.sh","environment/setup-rs.sh","environment/setup-cnf.sh","${MONGO_DIR}/"]

USER root

RUN mkdir -p /home/admin/data/config /home/admin/data/rs && \
    chmod +x $MONGO_DIR/docker-entrypoint.sh && chmod +x $MONGO_DIR/init-shard.sh && \
    chmod +x $MONGO_DIR/setup-rs.sh && chmod +x $MONGO_DIR/setup-cnf.sh && \
    mv $MONGO_DIR/mongodb-linux-x86_64-rhel70-3.6.0  $MONGO_DIR/mongodb

ENTRYPOINT ["/home/admin/app/mongo/docker-entrypoint.sh"]

