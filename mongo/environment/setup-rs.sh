#!/bin/bash

mongodb1=`getent hosts ${MONGO1} | awk '{ print $1 }'`
mongodb2=`getent hosts ${MONGO2} | awk '{ print $1 }'`
mongodb3=`getent hosts ${MONGO3} | awk '{ print $1 }'`
echo "mongo-1-1 is ${mongodb1}, mongo-1-2 is ${mongodb2}, mongo-1-3 is ${mongodb3}"

port=${PORT:-27017}

echo "Waiting for startup.."
# 检查服务器链接是否正常,在mongodb1设置成员信息
until /home/admin/app/mongo/mongodb/bin/mongo --host ${mongodb1}:${port} --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null; do
  printf '.'
  sleep 1s
done

echo "Started.."

echo setup-rs.sh time now: `date +"%T" `
/home/admin/app/mongo/mongodb/bin/mongo --host ${mongodb1}:${port} <<EOF
   var cfg = {
        "_id": "${RS}",
        "protocolVersion": 1,
        "members": [
            {
                "_id": 0,
                "host": "${mongodb1}:${port}"
            },
            {
                "_id": 1,
                "host": "${mongodb2}:${port}"
            },
            {
                "_id": 2,
                "host": "${mongodb3}:${port}"
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    rs.reconfig(cfg, { force: true });
EOF