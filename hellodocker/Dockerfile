FROM alpine:3.8

RUN addgroup -g 651 -S admin && adduser -u 651 -S -G admin admin

RUN apk add --no-cache \
		tzdata

ENV HOME /home/admin
ENV PATH "${HOME}/bin:${PATH}"

RUN /bin/cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
echo 'Asia/Shanghai' >/etc/timezone &&\
mkdir $HOME/data $HOME/logs $HOME/commons $HOME/app $HOME/conf $HOME/bin &&\
chown admin:admin $HOME/data $HOME/logs $HOME/commons $HOME/app $HOME/conf $HOME/bin

COPY --chown=admin:admin bin/* $HOME/bin/
# custom
RUN chmod +x $HOME/bin/*

VOLUME $HOME/data $HOME/logs
WORKDIR $HOME

ENTRYPOINT ["docker-entrypoint.sh"]
