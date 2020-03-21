FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

USER root
WORKDIR /home/admin/
COPY --chown=root:root package/ /home/admin/package/

ENV APP_HOME /home/admin/next-ai-device-update/

RUN mkdir -p $APP_HOME &&\
cp -f /home/admin/package/update.jar ${APP_HOME} &&\
cp -f /home/admin/package/application.yml ${APP_HOME} &&\
cp -f /home/admin/package/docker-entrypoint.sh /usr/bin/ &&\
chmod +x /usr/bin/docker-entrypoint.sh &&\
rm -rf $HOME/package

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]