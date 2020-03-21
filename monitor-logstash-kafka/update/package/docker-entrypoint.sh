#!/bin/bash
mkdir -p /home/admin/logs/
mkdir -p /home/admin/data/tmp
sed -r -i "s,replace_server_port,$PORT,g" $APP_HOME/application.yml
sed -r -i "s,replace_datesource_database_url,$DB_URL,g" $APP_HOME/application.yml
sed -r -i "s,replace_datesource_database_username,$DB_USERNAME,g" $APP_HOME/application.yml
sed -r -i "s,replace_datesource_database_password,$DB_PASSWORD,g" $APP_HOME/application.yml
sed -r -i "s,replace_common_download_prefix,$DOWNLOAD_PREFIX,g" $APP_HOME/application.yml
cp -f $APP_HOME/application.yml /home/admin/logs/
cd $APP_HOME
exec java -jar update.jar -server -Xms2g -Xmx2g -Xmn1g -XX:MetaspaceSize=256m --logging.path=/home/admin/logs/