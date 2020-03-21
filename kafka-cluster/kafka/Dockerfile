FROM openjdk:8u171-jre-alpine

ARG kafka_version=1.1.1
ARG scala_version=2.11
ARG glibc_version=2.27-r0

MAINTAINER wurstmeister

ENV KAFKA_VERSION=$kafka_version \
    SCALA_VERSION=$scala_version \
    KAFKA_HOME=/opt/kafka \
    GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin
RUN mkdir -p /tmp
COPY start-kafka.sh /tmp/

RUN apk add --no-cache bash curl jq \
 && mkdir /opt \
 && chmod a+x /tmp/*.sh \
 && mv /tmp/start-kafka.sh  /usr/bin \
 && sync && wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz \
 && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
 && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} /opt/kafka \
 && rm -rf /tmp \
 && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
 && apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk \
 && rm glibc-${GLIBC_VERSION}.apk

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
ENTRYPOINT ["/usr/bin/start-kafka.sh"]