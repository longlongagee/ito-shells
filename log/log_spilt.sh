#!/bin/bash
PATH=/usr/jdk1.7.0_76/bin:/usr/jdk1.7.0_76/jre/bin:/usr/jdk1.7.0_76/bin:/usr/jdk1.7.0_76/jre/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
log_file=/web/logs/nginx_error.log
log_if=`du ${log_file} |awk '{print $1}'`
log_spdir=/web/logs/error
if [ ! -d ${log_spdir} ];then
        mkdir ${log_spdir}
fi
if [ ${log_if} -gt 5000000 ];then
        rm -rf ${log_spdir}/webnginxlog*
        split -b 500m ${log_file} ${log_spdir}/webnginxlog$(date +%F)
        sleep 5
        > ${log_file}
fi
