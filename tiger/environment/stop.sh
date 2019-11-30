#!/bin/sh
if [ "$1" = "" ] ; then
        echo must has nodeName
        exit 1
fi

PID=`ps aux | grep java | grep tiger.jar | grep "instanceNo=$1 " | awk '{print $2}'`
if [ "$PID" = "" ] ; then
        echo node[$1] not running
        exit 2
fi
kill -9 $PID
echo kill $PID success $?