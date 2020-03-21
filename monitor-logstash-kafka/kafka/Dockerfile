FROM lili/base:1.0
MAINTAINER lili <772654204@qq.com>

USER root
COPY --chown=root:root package/ /home/admin/package/
# env
ENV KAFKA_HOME /home/admin/kafka_2.11-1.1.1
WORKDIR /home/admin/package/
RUN /usr/bin/tar -xzf /home/admin/package/kafka_2.11-1.1.1.tgz -C /home/admin &&\
chmod +x /home/admin/package/*.sh &&\
cp /home/admin/package/*.sh /usr/bin/ &&\
rm -rf $HOME/package

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
ENTRYPOINT ["/usr/bin/start-kafka.sh"]