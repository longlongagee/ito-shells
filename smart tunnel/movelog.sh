#!/bin/bash
log_dir='/usr/local/server/nginx/logs'
ydate=`date -d yesterday +%Y%m%d`
datecount=`date +%H%M`
mv ${log_dir}/host.access.log.${ydate}* ${log_dir}/bak/
