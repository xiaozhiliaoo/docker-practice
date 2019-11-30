FROM lili/base:1.0

MAINTAINER lili <772654204@qq.com>

ENV APP_DIR /home/admin/app/tiger

ADD ["environment/tiger.tar.gz", "environment/docker-entrypoint.sh" , "${APP_DIR}/"]

USER root

RUN chmod +x ${APP_DIR}/docker-entrypoint.sh

VOLUME /home/admin/app/tiger/logs

ENTRYPOINT ["/home/admin/app/tiger/docker-entrypoint.sh"]

