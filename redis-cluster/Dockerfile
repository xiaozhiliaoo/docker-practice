FROM alpine:3.8
MAINTAINER lili <772654204@qq.com>

RUN addgroup -g 651 -S admin && adduser -u 651 -S -G admin admin

RUN apk add --no-cache \
		tzdata

ENV HOME /home/admin
ENV DATA_DIR $HOME/data
ENV LOGS_DIR $HOME/logs
ENV PATH "${HOME}/bin:${PATH}"
ENV REDIS_VERSION 4.0.11
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-4.0.11.tar.gz
ENV REDIS_DOWNLOAD_SHA fc53e73ae7586bcdacb4b63875d1ff04f68c5474c1ddeda78f00e5ae2eed1bbb

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
echo 'Asia/Shanghai' >/etc/timezone &&\
mkdir $HOME/data $HOME/logs $HOME/commons $HOME/app $HOME/conf $HOME/bin &&\
chown admin:admin $HOME/data $HOME/logs $HOME/commons $HOME/app $HOME/conf $HOME/bin

COPY --chown=admin:admin environment/bin/* $HOME/bin/
COPY --chown=admin:admin environment/conf/* $HOME/conf/


RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		coreutils \
		gcc \
		jemalloc-dev \
		linux-headers \
		make \
		musl-dev \
	; \
	\
	wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
	echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c -; \
	mkdir -p $HOME/src/redis; \
	tar -xzf redis.tar.gz -C $HOME/src/redis --strip-components=1; \
	rm redis.tar.gz; \
	\
# disable Redis protected mode [1] as it is unnecessary in context of Docker
# (ports are not automatically exposed when running inside Docker, but rather explicitly by specifying -p / -P)
# [1]: https://github.com/antirez/redis/commit/edd4d555df57dc84265fdfb4ef59a4678832f6da
	grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 1$' $HOME/src/redis/src/server.h; \
	sed -ri 's!^(#define CONFIG_DEFAULT_PROTECTED_MODE) 1$!\1 0!' $HOME/src/redis/src/server.h; \
	grep -q '^#define CONFIG_DEFAULT_PROTECTED_MODE 0$' $HOME/src/redis/src/server.h; \
# for future reference, we modify this directly in the source instead of just supplying a default configuration flag because apparently "if you specify any argument to redis-server, [it assumes] you are going to specify everything"
# see also https://github.com/docker-library/redis/issues/4#issuecomment-50780840
# (more exactly, this makes sure the default behavior of "save on SIGTERM" stays functional by default)
	\
	make -C $HOME/src/redis -j "$(nproc)"; \
	make PREFIX=$HOME/app/redis -C $HOME/src/redis install; \
	\
	rm -r $HOME/src; \
	\
	runDeps="$( \
		scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
			| tr ',' '\n' \
			| sort -u \
			| awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
	)"; \
	apk add --virtual .redis-rundeps $runDeps; \
	apk del .build-deps;


RUN ln -s $HOME/app/redis/bin/redis-server $HOME/bin/ &&\
ln -s $HOME/app/redis/bin/redis-cli $HOME/bin/ &&\
chmod +x $HOME/bin/* &&\
redis-server --version

VOLUME $HOME/data $HOME/logs
USER admin
WORKDIR $HOME

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 6379
CMD ["redis-server", "/home/admin/conf/redis.conf"]
