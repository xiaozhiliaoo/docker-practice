FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

USER root
COPY --chown=root:root package/ /home/admin/package/
# env
ENV LANG en_US.UTF-8
ENV HOME /home/admin
ENV BIN_DIR $HOME/bin
ENV COMMONS_DIR $HOME/commons
ENV APP_DIR $HOME/app
ENV DATA_DIR $HOME/data
ENV LOGS_DIR $HOME/logs
WORKDIR /home/admin/package/
RUN rpm --rebuilddb && yum install -y wget &&\
wget http://mirror.bit.edu.cn/apache/kafka/1.1.1/kafka_2.11-1.1.1.tgz &&\
/usr/bin/tar -xzf $HOME/package/kafka_2.11-1.1.1.tgz -C $HOME/ &&\
sed -i '2a /home/admin/bin/modify-config.sh' /home/admin/bin/docker-entrypoint.sh &&\
cp $HOME/package/modify-config.sh /home/admin/bin/ &&\
chmod +x /home/admin/bin/modify-config.sh &&\
cp $HOME/package/zk_kafka.conf /home/admin/commons/supervisor/conf/ &&\
rm -rf $HOME/package