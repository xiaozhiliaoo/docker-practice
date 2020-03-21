FROM openjdk:8-jre-alpine

# Install required packages
RUN apk add --no-cache \
    bash \
    su-exec

ENV ZOO_USER=zookeeper \
    ZOO_CONF_DIR=/conf \
    ZOO_TICK_TIME=2000 \
    ZOO_INIT_LIMIT=5 \
    ZOO_SYNC_LIMIT=2 \
    ZOO_AUTOPURGE_PURGEINTERVAL=0 \
    ZOO_AUTOPURGE_SNAPRETAINCOUNT=3 \
    ZOO_MAX_CLIENT_CNXNS=60

# Add a user and make dirs
RUN set -ex; \
    adduser -D "$ZOO_USER"; \
    mkdir -p "$ZOO_CONF_DIR"; \
    chown "$ZOO_USER:$ZOO_USER" "$ZOO_CONF_DIR"

ARG DISTRO_NAME=zookeeper-3.4.13

# Download Apache Zookeeper, verify its PGP signature, untar and clean up
RUN set -ex; \
    apk add --no-cache --virtual .build-deps \
        ca-certificates \
        gnupg \
        libressl; \
    echo 'Asia/Shanghai' > /etc/timezone; \
    wget "https://www.apache.org/dist/zookeeper/$DISTRO_NAME/$DISTRO_NAME.tar.gz"; \
    export GNUPGHOME="$(mktemp -d)"; \
    tar -xzf "$DISTRO_NAME.tar.gz"; \
    mv "$DISTRO_NAME/conf/"* "$ZOO_CONF_DIR"; \
    rm -rf "$GNUPGHOME" "$DISTRO_NAME.tar.gz"; \
    apk del .build-deps

EXPOSE 2888 3888

ENV PATH=$PATH:/$DISTRO_NAME/bin \
    ZOOCFGDIR=$ZOO_CONF_DIR

COPY docker-entrypoint.sh /
RUN chmod 777 /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["zkServer.sh", "start-foreground"]