#!/bin/bash

/usr/bin/supervisord -c /home/admin/commons/supervisor/supervisord.conf
tail -f /dev/null
