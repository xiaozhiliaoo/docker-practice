FROM centos:centos7.1.1503
MAINTAINER lili <772654204@qq.com>

COPY --chown=root:root environment/sys/* /tmp/sys/
RUN cp /tmp/sys/localtime /etc/localtime &&\
yum update -y nss curl libcurl &&\
yum install -y tar zip unzip net-tools &&\
yum install -y curl wget tar bzip2 unzip vim-enhanced passwd sudo yum-utils hostname net-tools rsync man && \
yum install -y gcc gcc-c++ git make automake cmake patch logrotate python-devel libpng-devel libjpeg-devel && \
/usr/bin/unzip /tmp/sys/setuptools-40.0.0.zip -d /tmp/sys/ &&\
cd /tmp/sys/setuptools-40.0.0/ &&\
/usr/bin/python setup.py build &&\
/usr/bin/python setup.py install &&\
/usr/bin/tar -xzf /tmp/sys/supervisor-3.3.4.tar.gz -C /tmp/sys/ &&\
cd /tmp/sys/supervisor-3.3.4/ &&\
/usr/bin/python setup.py install &&\
rm -rf /tmp/sys

ADD environment/aliyun-mirror.repo /etc/yum.repos.d/CentOS-Base.repo
ADD environment/aliyun-epel.repo /etc/yum.repos.d/epel.repo

RUN groupadd -g 651 admin &&\
useradd -u 651 -g 651 -m -s /bin/bash admin
USER admin

ENV LANG=en_US.UTF-8
ENV HOME=/home/admin
ENV JAVA_HOME=$HOME/commons/jdk
ENV PATH=$JAVA_HOME/bin:$PATH

WORKDIR $HOME

RUN mkdir -p $HOME/bin $HOME/commons $HOME/app $HOME/data $HOME/logs $HOME/tmp $HOME/commons/supervisor/conf

COPY --chown=admin:admin environment/usr/* $HOME/usr/
COPY --chown=admin:admin environment/bin/* $HOME/bin/

RUN cp $HOME/usr/supervisord.conf $HOME/commons/supervisor/ &&\
chmod +x $HOME/bin/*.sh &&\
/usr/bin/tar -xzf $HOME/usr/server-jre-8u181-linux-x64.tar.gz -C $HOME/commons/ &&\
ln -s $HOME/commons/jdk1.8.0_181 $HOME/commons/jdk &&\
rm -rf $HOME/usr

VOLUME $HOME/data $HOME/logs

ENTRYPOINT ["/home/admin/bin/docker-entrypoint.sh"]
