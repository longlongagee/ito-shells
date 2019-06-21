cat <<EOF >/etc/yum.repos.d/centos6_zabbix.repo
[zabbix]
name=Zabbix Official Repository - $basearch
baseurl=http://192.168.6.114/richstonedt_mirrors/zabbix/zabbix/zabbix/3.4/rhel/6/\$basearch/
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

[zabbix-non-supported]
name=Zabbix Official Repository non-supported - $basearch 
baseurl=http://192.168.6.114/richstonedt_mirrors/zabbix/zabbix/non-supported/rhel/6/\$basearch/
enabled=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
gpgcheck=0
EOF
