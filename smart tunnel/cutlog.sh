#!/bin/bash
log_dir='/usr/local/server/nginx/logs'
date=`date +%Y%m%d%H%M`
mv ${log_dir}/host.access.log ${log_dir}/host.access.log.${date}
kill -USR1 `cat /usr/local/server/nginx/logs/nginx.pid`
