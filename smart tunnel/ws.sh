#!/bin/bash



aaa=`netstat -n | awk '/^udp/ {++S[$NF]} END {for(a in S) print a, S[a]}' |awk '{print$2}'`
test $aaa -gt 10000 && echo $aaa |mail -s '113 SERVER 53 PORT' zhengsuhong@richstonedt.com xujingrui@richstonedt.com && /etc/init.d/php-fpm restart
