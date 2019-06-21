repo 与 epel

******************************************************************************************
CentOS 6
wget -O /etc/yum.repos.d/ali.repo http://mirrors.aliyun.com/repo/Centos-6.repo
wget -O /etc/yum.repos.d/epel-ali.repo http://mirrors.aliyun.com/repo/epel-6.repo
或者
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-6.repo

CentOS 7
wget -O /etc/yum.repos.d/CentOS-ali.repo http://mirrors.aliyun.com/repo/Centos-7.repo
                                         http://mirrors.aliyun.com/repo/

*******************************************************************************************


epel(RHEL 7)
wget -O /etc/yum.repos.d/epel-ali.repo http://mirrors.aliyun.com/repo/epel-7.repo

epel(RHEL 6)
wget -O /etc/yum.repos.d/epel-ali.repo http://mirrors.aliyun.com/repo/epel-6.repo


163:
http://mirrors.163.com/.help/centos.html

wget -O /etc/yum.repos.d/Cent0S6.repo /CentOS6-Base-163.repo
rpm -Uvh 	epel-release-6-8.noarch.rpm   #中国科技大学

wget -O /etc/yum.repos.d/163.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo
追加CentOS 6.5的epel及remi源。


********************************************************************************************
# rpm -Uvh http://ftp.iij.ad.jp/pub/linux/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

# rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
以下是CentOS 7.0的源。


# yum install epel-release

# rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
使用yum list命令查看可安装的包(Packege)。


# yum list --enablerepo=remi --enablerepo=remi-php56 | grep php

yum install --downloadonly --downloaddir=/home/java java