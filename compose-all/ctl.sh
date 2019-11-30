#!/usr/bin/env bash
#!/bin/bash

# 镜像地址
IMAGES_ROOT_DIR=/opt/cli/package/docker-images
# compose文件目录
COMPOSE_ROOT_DIR=/home/lili/dockerManager/compose
# 通用compose名字
COMPOSE_FILE=docker-compose.yml
# 所有composefile
ALL_COMPOSE_FILE=all-compose-services.yml
# 默认测试例句
DEFAULT_QUERY="我要去东方明珠"
# 数据目录
DATA_DIR=/home/admin/data
# 日志目录
LOG_DIR=/home/admin/logs

#显示使用方法
usage(){
    echo ""
    echo "usage:"
    echo ""
    echo $0" load"
    echo "       导入所有的镜像"
    echo ""
    echo $0" unload"
    echo "       卸载的所有镜像"
    echo ""
    echo $0" run oneCompose"
    echo "       通过一个docker-compose启动所有镜像"
    echo ""
    echo $0" run allCompose"
    echo "       通过多个docker-compose启动所有镜像"
    echo ""
    echo $0" run XXX (redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console)"
    echo "       启动某一个镜像"
    echo ""
    echo $0" rm XXX (可选项有：redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console)"
    echo "       删除运行的容器"
    echo ""
    echo $0" rm all "
    echo "       删除所有lili运行的容器"
    echo ""
    echo $0" stop XXX (可选项有：redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console)"
    echo "       关闭运行的容器"
    echo ""
    echo $0" stop all "
    echo "       停止所有lili运行的容器"
    echo ""
    echo $0" status XXX(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console)"
    echo "       查看指定容器状态"
    echo ""
    echo $0" init-data"
    echo "       初始化mongodb数据"
    echo ""
    echo $0" init all"
    echo "       初始化nlu数据和subway jar包"
    echo ""
    echo $0" init XXX(nlu,uds)"
    echo "       初始化nlu或uds"
    echo ""
    echo $0" destroy "
    echo "       删除整个集群数据,日志"
    echo ""
    echo $0" test XXX(smartr,nlu,uds) YYY(例句) 例如：test smartr '我要去陆家嘴'"
    echo "       测试服务真实是否可用"
    echo ""
    echo $0" setip vipserver yourip  or setip aim yourip"
    echo "       设置服务ip"
    echo ""
    echo $0" create network "
    echo "       创建容器网络"
    echo ""
}

# 将镜像文件导入到docker中
load(){
    # 10
    echo " start load lili images"
    start_load_time=`date +%s`
	docker load -i ${IMAGES_ROOT_DIR}/base.tar
	docker load -i ${IMAGES_ROOT_DIR}/redis.tar
	docker load -i ${IMAGES_ROOT_DIR}/etcd.tar
	docker load -i ${IMAGES_ROOT_DIR}/mongo.tar
	docker load -i ${IMAGES_ROOT_DIR}/rabbitmq.tar
	docker load -i ${IMAGES_ROOT_DIR}/smartr.tar
	docker load -i ${IMAGES_ROOT_DIR}/uds.tar
	docker load -i ${IMAGES_ROOT_DIR}/nlu.tar
	docker load -i ${IMAGES_ROOT_DIR}/aim.tar
	docker load -i ${IMAGES_ROOT_DIR}/console.tar
	end_load_time=`date +%s`
    load_cost=$((end_load_time - start_load_time))
    echo "load lili images time "${load_cost}"s"
	docker images | grep lili
}

unload(){
    docker rmi -f lili/etcd:1.0 lili/mongo:1.0 lili/redis:1.0 lili/rabbitmq:1.0 lili/nlu:1.0 lili/console:1.0 lili/uds:1.0 lili/smartr:1.0 lili/aim:1.0
}

run_redis(){
    echo "start redis"
    docker-compose -f ${COMPOSE_ROOT_DIR}/redis/${COMPOSE_FILE} up -d
}

run_etcd(){
    echo "start etcd"
    docker-compose -f ${COMPOSE_ROOT_DIR}/etcd/${COMPOSE_FILE} up -d
}

run_mongo(){
    echo "start mongo"
    docker-compose -f ${COMPOSE_ROOT_DIR}/mongo/docker-compose.rs.yml -f ${COMPOSE_ROOT_DIR}/mongo/docker-compose.cnf.yml -f ${COMPOSE_ROOT_DIR}/mongo/docker-compose.shard.yml up -d
}

run_rabbitmq(){
    echo "start rabbitmq"
    docker-compose -f ${COMPOSE_ROOT_DIR}/rabbitmq/${COMPOSE_FILE} up -d
}

run_smartr(){
    echo "start smartr"
	docker-compose -f ${COMPOSE_ROOT_DIR}/smartr/${COMPOSE_FILE} up -d
}

run_uds(){
    echo "start uds"
    docker-compose -f ${COMPOSE_ROOT_DIR}/uds/${COMPOSE_FILE} up -d
}

run_nlu(){
    echo "start nlu"
    docker-compose -f ${COMPOSE_ROOT_DIR}/nlu/${COMPOSE_FILE} up -d
}

run_aim(){
    echo "start aim"
    docker-compose -f ${COMPOSE_ROOT_DIR}/aim/${COMPOSE_FILE} up -d
}

run_console(){
    echo "start console"
    docker-compose -f ${COMPOSE_ROOT_DIR}/console/${COMPOSE_FILE} up -d
}

run_one_compose(){
    docker-compose -f ${COMPOSE_ROOT_DIR}/${ALL_COMPOSE_FILE} up -d
}

initialize_data(){
    echo "perpare initialize data ... please waiting ..."
    echo "initialize data start"
    starttime=`date +%s`
    curl -X POST -s --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8081/cli/init'
    endtime=`date +%s`
    cost=$((endtime -starttime))
    echo "initialize data cost time "${cost}"s"
}

initialize_data_immediately(){
    echo "initialize data start"
    starttime=`date +%s`
    curl -X POST -s --header 'Content-Type: application/json' --header 'Accept: application/json' 'http://localhost:8081/cli/init'
    endtime=`date +%s`
    cost=$((endtime -starttime))
    echo "initialize data cost time "${cost}"s"
}


rm_redis(){
    echo "remove redis container"
    docker rm -f redis-master redis-slave{1,2} sentinel{1,2,3}
}

rm_etcd(){
    echo "remove etcd container"
    docker rm -f etcd{0,1,2}
}

rm_mongo(){
    echo "remove  mongo container"
    docker rm -f mongo-1-1 mongo-1-2 mongo-1-3 mongo-cnf-1 mongo-cnf-2 mongo-cnf-3 mongo-router-1 \
    mongo-router-2 mongo-router-3 mongo-rs1-setup mongo-cnf-setup mongo-shard-setup
}

rm_rabbitmq(){
    echo "remove rabbitmq container"
    docker rm -f rabbit{1,2,3}
}

rm_smartr(){
    echo "remove smartr container"
	docker rm -f smartr{1,2,3}
}

rm_uds(){
    echo "remove uds container"
    docker rm -f uds{1,2,3}
}

rm_nlu(){
    echo "remove nlu container"
    docker rm -f nlu{1,2,3}
}

rm_aim(){
    echo "remove aim container"
    docker rm -f aim{1,2,3}
}

rm_console(){
    echo "remove console container"
    docker rm -f console{1,2,3}
}

rm_console_middleware_setup(){
    echo "remove console-middleware-setup container"
    docker rm -f console-middleware-setup
}

stop_redis(){
    echo "stop redis container"
    docker stop redis-master redis-slave{1,2} sentinel{1,2,3}
}

stop_etcd(){
    echo "stop etcd container"
    docker stop etcd{0,1,2}
}

stop_mongo(){
    echo "stop  mongo container"
    docker stop mongo-1-1 mongo-1-2 mongo-1-3 mongo-cnf-1 mongo-cnf-2 mongo-cnf-3 mongo-router-1 \
    mongo-router-2 mongo-router-3 mongo-rs1-setup mongo-cnf-setup mongo-shard-setup
}

stop_rabbitmq(){
    echo "stop rabbitmq container"
    docker stop rabbit{1,2,3}
}

stop_smartr(){
    echo "stop smartr container"
	docker stop smartr{1,2,3}
}

stop_uds(){
    echo "stop uds container"
    docker stop uds{1,2,3}
}

stop_nlu(){
    echo "stop nlu container"
    docker stop nlu{1,2,3}
}

stop_aim(){
    echo "stop aim container"
    docker stop aim{1,2,3}
}

stop_console(){
    echo "stop console container"
    docker stop console{1,2,3}
}

stop_all(){
    stop_redis
    stop_etcd
    stop_mongo
    stop_rabbitmq
    stop_smartr
    stop_uds
    stop_nlu
    stop_aim
    stop_console
}

create_network(){
    isNetWorkExist=$(docker network ls | grep lili-bridge-network)
    if [ "${isNetWorkExist}" ];then
        echo "lili-bridge-network is exist "
    else
        docker network create lili-bridge-network
    fi
}

#启动所有服务
run(){
    echo "start ..."
    run_start_time=`date +%s`
    create_network
    run_mongo
    sleep 10
    run_rabbitmq
    sleep 10
    run_redis
    run_etcd
    sleep 10
    run_console
    # 等待console启动
    sleep 10
    # 初始化数据
    initialize_data
    run_nlu
    run_smartr
    run_uds
    run_aim
    run_end_time=`date +%s`
    cost=$((run_end_time -run_start_time))
    echo "start service cost time "${cost}"s"
}

remove_all(){
    rm_redis
    rm_etcd
    rm_mongo
    rm_rabbitmq
    rm_smartr
    rm_uds
    rm_nlu
    rm_aim
    rm_console
    rm_console_middleware_setup
}


status_redis(){
    echo "主从信息:"
    docker exec redis-master /usr/bin/redis-cli -p 6379 -a lili2017 info Replication
    docker exec redis-slave1 /usr/bin/redis-cli -p 6389 -a lili2017 info Replication
    docker exec redis-slave2 /usr/bin/redis-cli -p 6399 -a lili2017 info Replication
    echo "哨兵信息："
    docker exec sentinel1 /usr/bin/redis-cli -p 26379 -a lili2017 info Sentinel
    docker exec sentinel2 /usr/bin/redis-cli -p 26389 -a lili2017 info Sentinel
    docker exec sentinel3 /usr/bin/redis-cli -p 26399 -a lili2017 info Sentinel
}

status_etcd(){
    echo "集群状态:"
    docker exec etcd0 /usr/bin/etcdctl --endpoints="etcd0:2379,etcd1:2369,etcd2:2359"  endpoint status --write-out=table endpoint status
    echo "集群成员:"
    docker exec etcd0 /usr/bin/etcdctl  member list  --write-out=table endpoint status
}

status_mongo(){
    echo "副本集信息:"
    docker exec mongo-1-1 /home/admin/app/mongo/mongodb/bin/mongo localhost:27017 --eval 'rs.status()'
    echo "配置服务器信息:"
    docker exec mongo-cnf-1  /home/admin/app/mongo/mongodb/bin/mongo localhost:27017 --eval 'rs.status()'
    echo "路由器信息:"
    docker exec mongo-router-1 /home/admin/app/mongo/mongodb/bin/mongo localhost:27017 --eval 'sh.status()'
}

status_rabbitmq(){
    echo "集群节点信息:（或者通过浏览器查看,http://yourip:15672/）"
    docker exec rabbit1 /bin/bash rabbitmqctl cluster_status
}

status_smartr(){
    echo "9777:" ;curl 0:9777/health
    echo ""
    echo "9778:" ;curl 0:9778/health
    echo ""
    echo "9779:" ;curl 0:9779/health
    echo ""
}

status_console(){
    echo "8081:" ;curl 0:8081/health
    echo ""
    echo "18081:" ;curl 0:18081/health
    echo ""
    echo "28081:" ;curl 0:28081/health
    echo ""
}

status_uds(){
    echo "9666:" ;curl 0:9666/health
    echo ""
    echo "9667:" ;curl 0:9667/health
    echo ""
    echo "9668:" ;curl 0:9668/health
    echo ""
}

status_nlu(){
    echo "8080:" ;curl 0:8080/health
    echo ""
    echo "18080:" ;curl 0:18080/health
    echo ""
    echo "28080:" ;curl 0:28080/health
    echo ""
}

status_aim(){
    echo "8082:" ;curl 0:8082/health
    echo ""
    echo "18082:" ;curl 0:18082/health
    echo ""
    echo "28082:" ;curl 0:28082/health
    echo ""
}

destroy_data_log(){
    echo "remove data ..."
    rm -rf ${DATA_DIR}/etcd
    rm -rf ${DATA_DIR}/mongo
    rm -rf ${DATA_DIR}/rabbitmq
    rm -rf ${DATA_DIR}/redis
    echo "remove logs ..."
    rm -rf ${LOG_DIR}/etcd
    rm -rf ${LOG_DIR}/mongo
    rm -rf ${LOG_DIR}/rabbitmq
    rm -rf ${LOG_DIR}/redis
    rm -rf ${LOG_DIR}/aim
    rm -rf ${LOG_DIR}/console
    rm -rf ${LOG_DIR}/nlu-plus
    rm -rf ${LOG_DIR}/smartr
    rm -rf ${LOG_DIR}/uds
}


init_all(){
    echo "init uds (upload subway-dialog-fn-1.0.0-shaded.jar)..."
    cd /home/lili/file && curl -X POST --header 'Content-Type: multipart/form-data' -F 'fileIn=@subway-dialog-fn-1.0.0-shaded.jar;filename=subway-dialog-fn-1.0.0-shaded.jar' --header 'Accept: application/json' '0:8081/cli/uds/upload?appid=default'
    echo ""
    echo "init nlu (upload shanghai_train.zip)..."
    cd /home/lili/file && curl -X POST --header 'Content-Type: multipart/form-data' -F 'fileIn=@shanghai_train.zip;filename=shanghai_train.zip' --header 'Accept: application/json' '0:8081/cli/nluplus/upload?appid=default'
    echo ""
}

init_uds(){
    echo "init uds (upload subway-dialog-fn-1.0.0-shaded.jar)..."
    cd /home/lili/file && curl -X POST --header 'Content-Type: multipart/form-data' -F 'fileIn=@subway-dialog-fn-1.0.0-shaded.jar;filename=subway-dialog-fn-1.0.0-shaded.jar' --header 'Accept: application/json' '0:8081/cli/uds/upload?appid=default'
    echo ""
}

init_nlu(){
    echo "init nlu (upload shanghai_train.zip)..."
    cd /home/lili/file && curl -X POST --header 'Content-Type: multipart/form-data' -F 'fileIn=@shanghai_train.zip;filename=shanghai_train.zip' --header 'Accept: application/json' '0:8081/cli/nluplus/upload?appid=default'
    echo ""
}


test_smartr(){
    QUERY="$1"
    if [ "$1" == "" ]; then
        QUERY=${DEFAULT_QUERY}
        echo ""
    fi
    echo "测试例句:${QUERY}"
    echo "测试结果:"
    curl -X POST --header 'Content-type: application/json' "0:9777/smartr/request" -d '{"header":{"namespace":"Uds","name":"Request","task_id":"653ae7e2ac994b1c9000a0a149e22cdd","message_id":"533101a830c24cd1a7e78d6fc8083a98","appkey":"default","status":0},"payload":{"app_key":"default","content":{"session_id":"project2048_conversation_1534899134679","query":"'${QUERY}'","query_params":[{"name":"auto_wakeup","value":"false"}]},"request_id":"653ae7e2ac994b1c9000a0a149e22cdd"},"context":{"sdk":{"name":"nls-sdk-java","version":"2.0.1"},"optional":"{\"line\":\"01\",\"station\":\"13\"}"}}'
    echo ""
}

test_nlu(){
    QUERY="$1"
    if [ "$1" == "" ]; then
        QUERY=${DEFAULT_QUERY}
        echo ""
    fi
    echo "测试例句:${QUERY}"
    echo "测试结果:"
    curl -X POST --header 'Content-type: application/json' "0:8080/nlu/response" -d '{"app_key":"default","device_context":{},"dialog_context":[],"query":"'${QUERY}'","request_id":"37680d6abec6462aacdbedd44fbf5339","service":"empty","session_id":"2971aa0af19649919fb700a0f5067465","v_log":0,"version":"6.0"}'
    echo ""
}

test_uds(){
    QUERY="$1"
    if [ "$1" == "" ]; then
        QUERY=${DEFAULT_QUERY}
        echo ""
    fi
    echo "测试例句:${QUERY}"
    echo "测试结果:"
    curl -X POST --header 'Content-type: application/json' "0:9666/uds" -d '{"app_key":"default","request_type":"REQUEST_GATEWAY_NEW","request_id":"37680d6abec6462aacdbedd44fbf5339","content":{"query":"'${QUERY}'","session_id":"2971aa0af19649919fb700a0f5067465","optional":""},"context": {"optional": "{\"line\":\"09\",\"station\":\"26\"}"}}'
    echo ""
}

set_aim_ip(){
  if [ "$1" == "" ]; then
     echo "aim的ip不能设置为空"
     return
  fi
  sed -i 's|MAP_SEARCHKEYWORD_URL.*|MAP_SEARCHKEYWORD_URL='$1'|g' all-compose-services.yml
  sed -i 's|MAP_SEARCHAROUD_URL.*|MAP_SEARCHAROUD_URL='$1'|g' all-compose-services.yml
}

set_vip_ip(){
  if [ "$1" == "" ]; then
     echo "vipserver的ip不能设置为空"
     return
  fi
  # 替换包含VIP_SERVER_LIST的那一行
  sed -i 's|VIP_SERVER_LIST.*|VIP_SERVER_LIST='$1'|g' all-compose-services.yml
}


if [ "$1" == "load" ]; then
        load
elif [ "$1" == "unload" ]; then
        unload
elif [ "$1" == "run" ]; then
    if [ "$2" == "" ]; then
        run_one_compose
    elif [ "$2" == "oneCompose" ]; then
        run_one_compose
    elif [ "$2" == "allCompose" ]; then
        run
    elif [ "$2" == "redis" ]; then
        run_redis
    elif [ "$2" == "redis" ]; then
        run_redis
    elif [ "$2" == "etcd" ]; then
        run_etcd
    elif [ "$2" == "mongo" ]; then
        run_mongo
    elif [ "$2" == "rabbitmq" ]; then
        run_rabbitmq
    elif [ "$2" == "smartr" ]; then
        run_smartr
    elif [ "$2" == "uds" ]; then
        run_uds
    elif [ "$2" == "nlu" ]; then
        run_nlu
    elif [ "$2" == "aim" ]; then
        run_aim
    elif [ "$2" == "console" ]; then
        run_console
    else
        echo "没有${2}这个服务，请从(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console中选择)"
    fi
elif [ "$1" == "rm" ]; then
    if [ "$2" == "" ]; then
        echo "请选择要删除的容器，(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console)"
    elif [ "$2" == "redis" ]; then
        rm_redis
    elif [ "$2" == "etcd" ]; then
        rm_etcd
    elif [ "$2" == "mongo" ]; then
        rm_mongo
    elif [ "$2" == "rabbitmq" ]; then
        rm_rabbitmq
    elif [ "$2" == "smartr" ]; then
        rm_smartr
    elif [ "$2" == "uds" ]; then
        rm_uds
    elif [ "$2" == "nlu" ]; then
        rm_nlu
    elif [ "$2" == "aim" ]; then
        rm_aim
    elif [ "$2" == "console" ]; then
        rm_console
    elif [ "$2" == "all" ]; then
        remove_all
    else
        echo "没有${2}这个服务，请从(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console中选择)"
    fi
elif [ "$1" == "stop" ]; then
    if [ "$2" == "" ]; then
        echo "请选择要停止的容器(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console)"
    elif [ "$2" == "redis" ]; then
        stop_redis
    elif [ "$2" == "etcd" ]; then
        stop_etcd
    elif [ "$2" == "mongo" ]; then
        stop_mongo
    elif [ "$2" == "rabbitmq" ]; then
        stop_rabbitmq
    elif [ "$2" == "smartr" ]; then
        stop_smartr
    elif [ "$2" == "uds" ]; then
        stop_uds
    elif [ "$2" == "nlu" ]; then
        stop_nlu
    elif [ "$2" == "aim" ]; then
        stop_aim
    elif [ "$2" == "console" ]; then
        stop_console
    elif [ "$2" == "all" ]; then
        stop_all
    else
        echo "没有${2}这个服务，请从(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console中选择)"
    fi
elif [ "$1" == "status" ];then
    if [ "$2" == "" ]; then
        echo "请选择查看的容器(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console中选择)"
    elif [ "$2" == "redis" ]; then
        status_redis
    elif [ "$2" == "etcd" ]; then
        status_etcd
    elif [ "$2" == "mongo" ]; then
        status_mongo
    elif [ "$2" == "rabbitmq" ]; then
        status_rabbitmq
    elif [ "$2" == "smartr" ]; then
        status_smartr
    elif [ "$2" == "uds" ]; then
        status_uds
    elif [ "$2" == "nlu" ]; then
        status_nlu
    elif [ "$2" == "aim" ]; then
        status_aim
    elif [ "$2" == "console" ]; then
        status_console
    else
        echo "没有${2}这个服务，请从(redis,etcd,mongo,rabbitmq,smartr,uds,nlu,aim,console中选择)"
    fi
elif [ "$1" == "create" ]; then
    create_network
elif [ "$1" == "init-data" ]; then
    initialize_data_immediately
elif [ "$1" == "destroy" ]; then
    destroy_data_log
elif [ "$1" == "init" ]; then
    if [ "$2" == "" ]; then
        echo "请选择初始化类型(all,nlu,uds)"
    elif [ "$2" == "all" ]; then
        init_all
    elif [ "$2" == "nlu" ]; then
        init_nlu
    elif [ "$2" == "uds" ]; then
        init_uds
    else
        echo "没有${2}这个选项，请从(all,nlu,uds)中选择"
    fi
elif [ "$1" == "test" ]; then
    if [ "$2" == "" ]; then
        echo "请选择测试类型(smartr,nlu,uds)"
    elif [ "$2" == "smartr" ]; then
        test_smartr $3
    elif [ "$2" == "nlu" ]; then
        test_nlu $3
    elif [ "$2" == "uds" ]; then
        test_uds $3
    else
        echo "没有${2}这个服务，请从(smartr,nlu,uds)中选择"
    fi
elif [ "$1" == "setip" ]; then
    if [ "$2" == "" ]; then
        echo "请选择设置服务(aim,vipserver)"
    elif [ "$2" == "aim" ]; then
        set_aim_ip $3
    elif [ "$2" == "vipserver" ]; then
        set_vip_ip $3
    else
        echo "没有${2}这个选项，请从(aim,vipserver)中选择"
    fi
else
    usage
fi