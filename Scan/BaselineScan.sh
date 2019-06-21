#!/bin/bash
set -e
sh1=$1
addr=`ip a|egrep -v "127|inet6"|awk -F '/' '{print $1}'|egrep -ow "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"|head -1`
echo 'Hantele!17' | sudo -S echo $addr

if [ "$sh1" = 'linux' ];then
	cd linux
	sudo chmod 777 9*
	echo "执行 linux 基线扫描：..."
	sleep 3
	sudo sh 96c221be-6ab2-ef53-1589-fe16877914ce.sh $addr root Hantele@1234!
elif [ "$sh1" = 'mysql' ];then
	cd mysql
	sudo chmod 777 9*
#	read -p "please input DBpasswd:" pw
	echo "执行 mysql 基线扫描：..."
	sleep 3
	sudo sh 96c221be-6ab2-ef53-1589-fe16877914d5.sh $addr root 3306 Hantele@17
elif [ "$sh1" = 'tomcat' ];then
	cd tomcat
	sudo chmod 777 9*
	echo "执行 tomcat 基线扫描：..."
	sleep 3
	sudo sh 96c221be-6ab2-ef53-1589-fe16877914a8.sh $addr root Hantele@1234! /usr/local/tomcat/conf
elif [ "$sh1" = 'apache' ];then
	exit 0;
else
	echo "输入错误，退出"
fi
sudo chmod 777 /tmp/*.xml


