#!/usr/bin/env bash
#@author:shao long 
#@file: ${NAME}
#@time: 2018/12/18 
#@Description:
#@version: 1.0

yum -y install dnsmasq bind-utils
chkconfig dnsmasq on

\cp -a /etc/dnsmasq.conf{,.`date +%s`-bak}

echo "# Include all files in /etc/dnsmasq.d except RPM backup files
conf-dir=/etc/dnsmasq.d
#定义dnsmasq从哪里获取上游DNS服务器的地址，默认是从/etc/resolv.conf获取
resolv-file=/etc/resolv.dnsmasq.conf
#严格按照resolv-file文件中的顺序从上到下进行DNS解析，直到第一个解析成功为止
strict-order
#定义dnsmasq监听的地址，默认是监控本机的所有网卡上。局域网内主机若要使用dnsmasq服务时，指定本机的IP地址
listen-address=`hostname -I|awk '{print $1}'`
#本地域名配置文件（不支持泛域名），添加内部需要解析的地址和域名（重新加载即可生效）
addn-hosts=/etc/dnsmasq.hosts
#缓存条数
cache-size=100
#为防止DNS污染，使用参数定义的DNS解析的服务器。注意：如果是阿里云服务器上配置dnsmasq要启用此项。
bogus-nxdomain=114.114.114.114
#可以通过server对不通的网站使用不通的DNS服务器进行解析。如下表示对于google的服务，使用谷歌的DNS解析
server=/google.com/8.8.8.8
#记录dns查询日志服务器
log-queries
#设置日志记录器
log-facility=/var/log/dnsmasq.log
" > /etc/dnsmasq.conf

\cp -a /etc/resolv.conf /etc/resolv.dnsmasq.conf
echo '192.168.108.72 rancher.com
' > /etc/dnsmasq.hosts

echo '
#启用泛域名解析，即自定义解析a记录
#访问baidu.com时的所有域名都会被解析成10.77.3.8
address=/k8s.com/192.168.108.74
' > /etc/dnsmasq.d/k8s.conf

service dnsmasq restart

nslookup http://jenkins.k8s.com `hostname -I|awk '{print $1}'`
