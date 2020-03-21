# 基础docker镜像，基于admin用户，包含：
1.时区修改  
2.tar zip unzip等工具安装  
3.supervisor安装  
4.admin用户创建，默认目录及环境变量设置  
5.jdk安装  
6./data、/logs目录映射  

# 目录说明：
/home/admin/commons/  通用工具依赖，如supervisor、jdk  
/home/admin/bin/  可执行脚本  
/home/admin/bin/app  程序包  
/home/admin/bin/data  程序产生的数据（会被映射到物理机上）  
/home/admin/bin/logs  程序产生的日志（会被映射到物理机上）

# 程序添加说明
1.把程序包拷贝到/home/admin/bin/app目录下（需配置好数据及日志产生的路径位置）  
2.添加supervisord配置（命名需以.conf结尾），并拷贝到/home/admin/commons/supervisor/conf下，示例：{}内为需替换的变量  
  [program:{你的程序名}]  
  command={启动脚本}  
  directory=/home/admin  
  user=admin  
  autorestart=true          
  redirect_stderr=true  
  stdout_logfile=/home/admin/logs/{程序标准输出的日志名}.log  
  loglevel=info  
3.启动dokcer实例即可，需指定--name、-p、-v参数  
  docker镜像启动后会调用/home/admin/bin/start.sh脚本，其中会启动supervisord，并加载/home/admin/commons/supervisor/conf下的配置