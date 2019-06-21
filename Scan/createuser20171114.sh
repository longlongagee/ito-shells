#!/bin/bash

group=yunwei
if [ $(awk -F ':' '{print $1}' /etc/group |grep "$group" |wc -l) -eq 0 ];then
    groupadd $group
fi
# [ -d /home/users ] || mkdir -p /home/users
 
# for user in xujianan wushaolong wanglingda panjian
for user in yunwei
do
if [ $(cat /etc/passwd |grep $user|wc -l) -ne 0 ] ;then
     echo "Hantele!17"| passwd --stdin $user
      usermod -a -G $group $user
else
    useradd -m -g $group $user
    echo "Hantele!17" | passwd --stdin $user
    usermod -a -G $group $user
fi
done
if [ $(cat /etc/sudoers |grep yunwei |wc -l) -eq 0 ];then
      echo "%"$group"  ALL=(ALL) ALL" >> /etc/sudoers
	  echo "$group create OK"
else
       exit 0
	   echo "$group creart OK"
fi



