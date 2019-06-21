#!/bin/bash
#by wusl 20180408
#
#1、要对list.txt列表的服务器做免密登陆
#2、由于禁止root远程，远程登陆账号要赋予sudo权限 
set -e
menu(){
    cat <<EOF
    -------------------------------
    |****Please Enter Your Choice:|
    -------------------------------
    1.外网基线扫描
    2.内网基线扫描
    3.中立区基线扫描

    ********按其他[任意字符]退出********

EOF
}

switch(){
    clear
    while true
    do
       menu
       read -p 'please input a number:' nmu1
       case "$nmu1" in
           1)
           clear
           WaiWang
           ;;    

           2) 
           clear
           NeiWang
           ;;

           3)
           clear 
           ZhongLi 
           ;;

           *) 
           clear
           break
       esac
   done
}	   

WaiWang(){
    for ip in `sed -n "16,19p" list.txt`
    do
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh tomcat;"
       sleep 1
   done
   # for ip in `sed -n "21,23p" list.txt`
   # do
   #     ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh mysql;"
   #     sleep 1
   # done
   # for ip in `sed -n "2,14p" list.txt`
   # do
   #     ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh linux;sudo chmod 751 /etc;"
   #     scp wanglingda@$ip:/tmp/*.xml /tmp/
   #     ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S chmod 750 /etc;"
   #     sleep 1
   # done
}


NeiWang(){
    for  ip in `sed -n "37,40p" list.txt`
    do
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh tomcat;"
       sleep 3
   done
   for  ip in `sed -n "42p" list.txt`
   do
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh msyql;"
       sleep 3
   done
   for ip in `sed -n "27,35p" list.txt`
   do
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh linux;sudo chmod 751 /etc;"
       scp wanglingda@$ip:/tmp/*.xml /tmp/
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S chmod 750 /etc;"
       sleep 3
   done
}


ZhongLi(){
    for  ip in `sed -n "49p" list.txt`
    do
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh tomcat;"
       sleep 3
   done
   # for  ip in `sed -n "51p" list.txt`
   # do
   #     ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh mysql;"
   #     sleep 3
   # done
   for ip in `sed -n "46,47p" list.txt`
   do
       ssh wanglingda@$ip " echo 'Hantele!17' | sudo -S /home/users/wanglingda/BaselineScan.sh linux;sudo chmod 751 /etc;"
       sudo scp wanglingda@$ip:/tmp/*.xml /tmp/
       sleep 3
   done
}

switch