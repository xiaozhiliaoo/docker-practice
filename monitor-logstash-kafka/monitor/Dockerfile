FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

USER root
WORKDIR /home/admin/
COPY --chown=root:root package/ /home/admin/package/
COPY --chown=root:root sigar/ /home/admin/sigar/
# env
ENV LANG zh_US.UTF-8
ENV HOME /home/admin
ENV JAVA_HOME $COMMONS_DIR/jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV APP_HOME /home/admin/next-ai-device-monitor/

RUN mkdir -p $APP_HOME &&\
mkdir -p /home/admin/logs/ &&\
cp -f /home/admin/package/next-ai-device-monitor.jar ${APP_HOME} &&\
cp -f /home/admin/package/application.properties ${APP_HOME} &&\
cp -f /home/admin/package/filter.properties ${APP_HOME} &&\
cp -f /home/admin/package/docker-entrypoint.sh /usr/bin/ &&\
chmod +x /usr/bin/docker-entrypoint.sh &&\
rm -rf $HOME/package

ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]