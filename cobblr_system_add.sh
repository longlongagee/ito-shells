#!/bin/bash
set -e

hname1=localhost
mask1="255.255.255.0"
gw1=""

read -p "请输入ip：" ip1
read -p "掩码：" mask1
read -p "网关：" gw1
read -p "hostname：" hname1 
read -p "MAC ：" mac


cobbler system add --name=$hname1 --hostname=$hname1  --interface=eth0 --mac=$mac --ip-address=$ip1 --netmask=$mask1 --gateway=$gw1 --profile=Cent7.4-x86_64 --kickstart=/var/lib/cobbler/kickstarts/cent7.4.ks --static=1