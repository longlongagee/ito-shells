#!/usr/bin/env bash
#@author:shao long 
#@file: 
#@time: 2018/07/25 
#@Description:


echo 'http_proxy=http://192.168.108.251:1080
https_proxy=http://192.168.108.251:1080
export http_proxy https_proxy
'  >> /etc/profile

source /etc/profile


#要取消该设置：
unset http_proxy
unset https_proxy



# docker 代理
mkdir /etc/systemd/system/docker.service.d
cat >/etc/systemd/system/docker.service.d/http_proxy.conf << EOF
[Service]
Environment="HTTP_PROXY=http://192.168.108.251:1080/"       #代理服务器地址
Environment="HTTPS_PROXY=http://192.168.108.251:1080/"       #代理服务器地址
Environment="NO_PROXY=localhost,192.168.6.96,127.0.0.0/8,192.168.6.0/24,192.168.0.0/16,docker-registry.somecorporation.com"
EOF
systemctl daemon-reload
systemctl restart docker