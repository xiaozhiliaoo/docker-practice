#!/usr/bin/env bash

#!/bin/bash

mongodb1=`getent hosts ${MONGOS} | awk '{ print $1 }'`

mongodb11=`getent hosts ${MONGO11} | awk '{ print $1 }'`
mongodb12=`getent hosts ${MONGO12} | awk '{ print $1 }'`
mongodb13=`getent hosts ${MONGO13} | awk '{ print $1 }'`

port=${PORT:-27017}

#  mongo localhost:40000  --eval 'quit(db.runCommand({ping:1}).ok?0:2)'

echo "Waiting for startup.."
until /home/admin/app/mongo/mongodb/bin/mongo --host ${mongodb1}:${port} --eval 'quit(db.runCommand({ ping: 1 }).ok ? 0 : 2)' &>/dev/null; do
  printf '.'
  sleep 1s
done

echo "Started..."

echo init-shard.sh time now: `date +"%T" `

/home/admin/app/mongo/mongodb/bin/mongo --host ${mongodb1}:${port} <<EOF
   sh.addShard( "${RS1}/${mongodb11}:${PORT1},${mongodb12}:${PORT2},${mongodb13}:${PORT3}" );
   sh.enableSharding("mydb")
   sh.status();
EOF
