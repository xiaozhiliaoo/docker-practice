FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

ENV RABBIT_DIR=/home/admin/app/rabbitmq

ADD ["environment/rabbitmq3.6.14.tar.gz", "environment/docker-entrypoint.sh", "${RABBIT_DIR}/"]

USER root

RUN chmod +x ${RABBIT_DIR}/docker-entrypoint.sh &&  yum install -y hostname &&  rpm -ivh --force --nodeps ${RABBIT_DIR}/rpm/*.rpm

#解决guest不能访问配置
ADD environment/rabbitmq.config /etc/rabbitmq/

# 离线启动一些插件
RUN /usr/sbin/rabbitmq-plugins list <<<'y' &&  /usr/sbin/rabbitmq-plugins enable --offline rabbitmq_mqtt rabbitmq_stomp rabbitmq_management <<<'y'

# 4369 epmd(Erlang Port Mapper Daemon)
EXPOSE 5672 15672 25672 4369

VOLUME /var/log/rabbitmq /var/lib/rabbitmq

ENTRYPOINT ["/home/admin/app/rabbitmq/docker-entrypoint.sh"]