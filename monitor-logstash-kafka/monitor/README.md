# 基于docker-base 镜像制作的 monitor 镜像包含：
1. monitor架包及 启动脚本
2. monitor 的开机启动（monitor_start.conf 拷贝放入 /home/admin/commons/supervisor/conf 文件夹下，被supervisor 管理）

# 端口说明
monitor 监听端口 8011

# package中文件说明
1. monitor.jar 是 monitor 服务的架包
2. fileter.properties 是monitor 服务用到的监控配置参数
3. monitor_supervisor.conf 是 supervisor 管理monitor服务用到的配置文件，在构建镜像的时候回会拷贝放入 /home/admin/commons/supervisor/conf 文件夹下
4. monitor_start.sh 是 monitor_supervisor 中启动monitor 服务的命令command
5. sigar 文件夹中的是 sigar 包 所依赖的一些文件

# 启动容器的命令
docker run -tid --name monitor --net=host -v /home/admin/logs/monitor:/home/admin/logs --privileged=true monitor:v1