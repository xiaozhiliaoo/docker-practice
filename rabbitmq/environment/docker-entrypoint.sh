#!/usr/bin/env bash

set -e

# rabbitmq服务没启动前，不会有.erlang.cookie文件，先生成该文件,不必等到服务器启动后然后生成cookie文件，然后在服务器间同步
sync_erlang_cookies() {
    mkdir -p /var/lib/rabbitmq
    ERLANG_COOKIE="lilirabbitmq"
    cookieFile='/var/lib/rabbitmq/.erlang.cookie'
    # 如果$cookieFile存在
    if [ -e "$cookieFile" ]; then
        if [ "$(cat "$cookieFile" 2>/dev/null)" != "$ERLANG_COOKIE" ]; then
            echo >&2
            echo >&2 "warning: $cookieFile contents do not match ERLANG_COOKIE"
            echo >&2
        fi
    # 如果不存在
    else
        echo "$ERLANG_COOKIE" > "$cookieFile"
        chmod 600 "$cookieFile"
        chown rabbitmq "$cookieFile"
    fi
}

# 开始集群
start_cluster() {
    chmod 777 /var/lib/rabbitmq  /var/log/rabbitmq/
    # RABBITMQ_NODENAME如果为空或者未定义,用rabbit替换RABBITMQ_NODENAME，否则用RABBITMQ_NODENAME替换
    RABBITMQ_NODENAME=${RABBITMQ_NODENAME:-rabbit}
    # CLUSTER_WITH为空or为hostname
    if [ -z "$CLUSTER_WITH" -o "$CLUSTER_WITH" = "$hostname" ]; then
      echo "Running as single server"
      # 启动主节点(加入其它节点的),如果使用 -detached则不写入pid文件,
      /usr/sbin/rabbitmq-server &
      #必须等待rabbitmq服务起来才可以add_user
      rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
      add_user
      tail -f /dev/null
    else
      echo "Running as clustered server"
      # 启动其余节点(被加入主节点的)
      /usr/sbin/rabbitmq-server &
      rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@$HOSTNAME.pid
      rabbitmqctl stop_app
      rabbitmqctl reset
      echo "Joining cluster $CLUSTER_WITH"
      # 当前节点加入主节点  rabbitmqctl join_cluster --ram rabbit@rabbit1
      rabbitmqctl join_cluster ${ENABLE_RAM:+--ram} $RABBITMQ_NODENAME@$CLUSTER_WITH
      rabbitmqctl start_app
      # 保证前台进程运行
      tail -f /dev/null
    fi
}


add_user() {
	if [ -z $RABBITMQ_DEFAULT_USER ] && [ -z $RABBITMQ_DEFAULT_PASS ]; then
		echo "Maintaining default 'guest' user"
	else
		# 不能重复添加lili用户，否则服务起不来
		USER=`rabbitmqctl list_users | grep lili | awk '{printf $1}'`
        if [ "${USER}" == "" ]; then
            echo "adding ${RABBITMQ_DEFAULT_USER}"
            rabbitmqctl add_user $RABBITMQ_DEFAULT_USER $RABBITMQ_DEFAULT_PASS
            rabbitmqctl set_user_tags $RABBITMQ_DEFAULT_USER administrator
            rabbitmqctl set_permissions -p / $RABBITMQ_DEFAULT_USER ".*" ".*" ".*"
        else
            echo "${RABBITMQ_DEFAULT_USER} is exists"
        fi
	fi
}

sync_erlang_cookies
start_cluster

