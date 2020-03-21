FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

USER root
RUN useradd -ms /bin/bash elastic

WORKDIR /home/admin/
COPY --chown=root:root package/ /home/admin/package/
USER root
# env
ENV LANG en_US.UTF-8
ENV HOME /home/admin
ENV BIN_DIR $HOME/bin
ENV COMMONS_DIR $HOME/commons
ENV APP_DIR $HOME/app
ENV DATA_DIR $HOME/data
ENV LOGS_DIR $HOME/logs
ENV JAVA_HOME $COMMONS_DIR/jdk
ENV PATH $JAVA_HOME/bin:$PATH

RUN mkdir -p /home/admin/logs/logstash &&\
mkdir -p /home/admin/data/logstash &&\
rpm -ivh --force $HOME/package/logstash-6.3.0.rpm &&\
cp -f $HOME/package/patterns /etc/logstash &&\
cp -f $HOME/package/logstash.pipeline.conf /etc/logstash/conf.d/ &&\
cp -f $HOME/package/logstash.yml /etc/logstash &&\
cp -f $HOME/package/20-nproc.conf /etc/security/limits.d/20-nproc.conf &&\
cp -f $HOME/package/logstash_jvm.options /etc/logstash/jvm.options &&\
cp -f $HOME/package/logstash_log4j.properties /etc/logstash/log4j2.properties &&\
cp -f /home/admin/package/docker-entrypoint.sh /usr/bin/ &&\
chmod +x /usr/bin/docker-entrypoint.sh &&\
rm -rf $HOME/package
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]