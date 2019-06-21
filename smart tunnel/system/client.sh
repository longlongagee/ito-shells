#!/bin/bash



#HOSTNAME
echo "HOSTNAME:`hostname`"

#运行时间
echo "UPTIME:`uptime |awk '{print $3}'`"

#CPU AVG-1
#echo "AVG-1:`uptime |cut -d ':' -f 5 |cut -d ',' -f 1 |cut -d ' ' -f 2`"
echo "AVG-1:`uptime |awk '{print$10}' |cut -c -4`"

#CPU AVG-5
#echo "AVG-5:`uptime |cut -d ':' -f 5 |cut -d ',' -f 2 |cut -d ' ' -f 2`"
echo "AVG-5:`uptime |awk '{print$11}' |cut -c -4`"

#CPU AVG-15
#echo "AVG-15:`uptime |cut -d ':' -f 5 |cut -d ',' -f 3 |cut -d ' ' -f 2`"
echo "AVG-15:`uptime |awk '{print$12}' |cut -c -4`"

#CPU 使用率
echo "CPUUSED:`sar -u 1 1 |tail -1 |awk '{print$3}'`%"

#MEM USE
echo "MEMUSE:`free -m |grep buffers |tail -1 |awk '{print$3}'`"

#MEM FREE
echo "MEMFREE:`free -m |grep buffers |tail -1 |awk '{print$4}'`"

#MEM 使用率
echo "MEMUSED:`free -m |grep "buffers" |awk 'NR==2{print$3/($3+$4)*100}'|cut -c -5`%"

#DISK 根目录
echo "ROOTDIR:`df -h |grep /$ |awk '{print$4}'`"

#DISK 数据盘
echo "DATADIR:`df -h |grep /home |awk '{print$4}'`"

#DISK IO


#NETWORK 接受正确数/包
echo "NETWORKRXOK:`netstat -i |grep bond0 |awk '{print$4}'`"

#NETWORK 接受错误数/包
#echo "NETWORKRXERR:`netstat -i |grep bond0 |awk '{print$5}'`"
echo "NETWORKRXERR:0"

#NETWORK 发送正确数/包
echo "NETWORKTXOK:`netstat -i |grep bond0 |awk '{print$8}'`"

#NETWORK 发送错误数/包
echo "NETWORKTXERR:`netstat -i |grep bond0 |awk '{print$9}'`"

#NETWORK 上传/KB
echo "NETWORKUPDATA:`sar -n DEV 1 1 |tail -1 |awk '{print$6}'`"

#NETWORK 下载/KB
echo "NETWORKDOWNLOAD:`sar -n DEV 1 1 |tail -1 |awk '{print$5}'`"

#NETWORK 并发数
echo "NETWORKCONCURRENCY:`netstat -n | grep ESTABLISHED | wc -l `"

#APP NGINX
echo "APPNGINX:`ps aux |grep nginx |wc -l`"

#APP TOMCAT
echo "APPTOMCAT:`ps aux |grep tomcat |wc -l`"

#APP PHP
echo "APPPHP:`ps aux |grep php |wc -l`"

#APP MYSQL
echo "APPMYSQL:`ps aux |grep mysql |wc -l`"

