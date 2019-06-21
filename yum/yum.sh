#!/bin/bash
set -e
rm -rf /etc/yum.repos.d/*.repo
cat <<EOF >/etc/yum.repos.d/Richstone_local_epel_Centos_6.repo
[epel]
name=Extra Packages for Enterprise Linux 6 - \$basearch
baseurl=http://192.168.6.114/richstonedt_mirrors/epel/6/\$basearch
#mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-6&arch=\$basearch
failovermethod=priority
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
EOF

cat <<EOF >/etc/yum.repos.d/Richstone_local_yum_Centos_6.repo
[base]
name=CentOS-6 - Base
baseurl=http://192.168.6.114/richstonedt_mirrors/centos/6/os/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=6&arch=\$basearch&repo=os
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#released updates
[updates]
name=CentOS-6 - Updates
baseurl=http://192.168.6.114/richstonedt_mirrors/centos/6/updates/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=6&arch=\$basearch&repo=updates
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that may be useful
[extras]
name=CentOS-6 - Extras
baseurl=http://192.168.6.114/richstonedt_mirrors/centos/6/extras/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=6&arch=\$basearch&repo=extras
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#additional packages that extend functionality of existing packages
[centosplus]
name=CentOS-6 - Plus
baseurl=http://192.168.6.114/richstonedt_mirrors/centos/6/centosplus/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=6&arch=\$basearch&repo=centosplus
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6

#contrib - packages by Centos Users
[contrib]
name=CentOS-6 - Contrib
baseurl=http://192.168.6.114/richstonedt_mirrors/centos/6/contrib/\$basearch/
#mirrorlist=http://mirrorlist.centos.org/?release=5.8&arch=\$basearch&repo=contrib
gpgcheck=1
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
EOF

#yum install -y zabbix-agent
#if [ $? -eq 1 ];then echo "zabbix-agent 安装失败"; exit "";else echo "success!"; fi
#service zabbix-agent start&&chkconfig zabbix-agent on
