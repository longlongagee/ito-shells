
Cobbler + Kickstart

cobbler setting edit --name=allow_dynamic_settings --value=1
cobbler setting edit --name=pxe_just_once --value=1
service cobblerd restart
#http://www.mamicode.com/info-detail-1428848.html
#
*********************************************************
http://werewolftj.blog.51cto.com/1606482/1673779
http://blog.csdn.net/qq3401247010/article/details/77104173
http://debugo.com/kickstart-install-centos/
*********************************************************
密码
openssl passwd -1 -salt 'random-phrase-here' 'your-password-here'
htdigest /etc/cobbler/users.digest "Cobbler" admin
启动菜单
cat /var/lib/tftpboot/pxelinux.cfg/default 
1. 指定一个网段使用特定的装机配置
cobbler system add --name=test_000 --ip=192.168.1.0/24 --profile=CentOS-5.9-x86_64
2. 添加一个指定服务器的装机配置
指定服务器的mac地址，并设置好主机名、IP地址等信息，需要提示知道服务器MAC地址，根据MAC应用到具体机器上。
cobbler import --path=/mnt/dvd --name=CentOS-7.6 --arch=x86_64  #导入系统镜像文件

cobbler system add --name=test_001 --hostname=test_001 --mac=00:50:56:25:6A:61  --interface=eth0 --ip-address=192.168.1.123 --subnet=255.255.255.0 --gateway=192.168.1.1 --static=1 --profile=CentOS-6.6-x86_64
-------------------------------------1------------------------------------------------------------------------------
cobbler profile edit --name=CentOS-6.6-x86_64  --distro=CentOS-6.6-x86_64  --kickstart=/var/lib/cobbler/kickstarts/cent6.6.ks
--------------------------------------2-------------------------------------------------------------------------------
cobbler system add --name=cen2 --hostname=slave01  --interface=eth0 --mac=00:50:56:27:BE:EE --ip-address=192.168.1.102 --netmask=255.255.255.0 --profile=CentOS6.8-x86_64 --kickstart=/var/lib/cobbler/kickstarts/cent6.7.ks --static=1
还可以指定ks参数。--kickstart=/var/lib/cobbler/kickstarts/cent6.6.ks

cobbler system add --name=172.16.1.102 --hostname=slave01  --interface=eth0 --mac=00:50:56:25:10:4B --ip-address=172.16.1.102 --netmask=255.255.255.0 --gateway=172.16.1.1 --profile=Cent7.4-x86_64 --kickstart=/var/lib/cobbler/kickstarts/cent7.4.ks --static=1

00:50:56:25:10:4B
3. 修改system配置
机器IP地址变更为192.168.21.118

cobbler system add --name=test_001 --ip=192.168.21.118
变更system配置名称

cobbler system rename --name=test001 --newname=abc
4. 删除system配置
需要删除的profile名称为test_001

cobbler system remove --name=test_001
5. 查看定义的系统列表

cobbler system list
test_001
设置好后，需要执行排错和同步


cobbler check
cobbler sync
为Cobbler添加RPM仓库

命令行下操作，添加epel和epel-test的repo
把repo添加到profle
cobbler repo add --mirror=http://mirrors.ustc.edu.cn/epel/6/x86_64/ --name=epel6-x86_64 --arch=x86_64 --breed=yum
cobbler repo add --mirror=http://mirrors.ustc.edu.cn/epel/testing/6/x86_64/ --name=epel6-x86_64-testing --arch=x86_64 --breed=yum


ks例子--------------------------------------
# This kickstart file should only be used with centos6.6
# For newer distributions please use the sample_end.ks

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
#Partition information
part /boot --fstype="ext4" --size=200
part / --fstype="ext4" --size=10000
part /data --fstype="ext4" --size=6000
part swap --fstype="swap" --size=4096
 
# Use text mode install
text
# Firewall configuration
firewall --disable
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard us
# System language
lang en_US
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
#network --bootproto=dhcp   --device=em1
# Reboot after installation
reboot
 
#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
skipx
# System timezone
timezone   Asia/Shanghai
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
  
%packages
@base
@compat-libraries
@debugging
@development
#tree
#nmap
#sysstat
#lrzsz
#dos2unix
#telnet

%post --interpreter=/bin/bash
(
#install Extra Packages
/bin/cat <<EOF >/etc/yum.repos.d/local.repo
[development]
name=iso6
baseurl=file:///mnt/cdrom
enable=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
EOF
/bin/cat <<EOF >/etc/sysconfig/network-scripts/ifcfg-eth0
DEVICE=eth0
BOOTP=dhcp
ONBOOT=yes
TYPE=Ethernet
USERCTL=no
NM_CONTROLLED=no
EOF
/bin/mkdir /mnt/cdrom
/bin/cat <<EOF >>/etc/fstab

/dev/sr0	/mnt/cdrom	iso9660	defaults        0 0
EOF
)2>&1 >> /root/post-install.log
%end





ksvalidator 检查
cobbler web错误
 vim /etc/httpd/conf.d/cobbler_web.conf

http://lx.wxqrcode.com/index.php/post/116.html


ssh192.168.8.10   (root/hantele123)

操作步骤如下：
 yum -y install cobbler cobbler-web dhcp tftp-server pykickstart httpd
1.检查 并修改dhcp网络配置vim /etc/cobbler/dhcp.template
cobbler sync  同步配置文件
2.检查vim /var/lib/cobbler/kickstarts/ks2017ann.cfg
检查url
url --url="http://192.168.8.10/cobbler/ks_mirror/6.8-x86_64/"
检查network字段
network --onboot yes --device em1 --mtu=1 --bootproto static --ip 192.168.6.93 --netmask 255.255.255.0 --gateway 192.168.6.254 --noipv6 --hostname=node  

3.执行主机配置地址
/root/sys.sh

sed -i '/wait/s/yes/no/g' /etc/xinetd.d/telnet  把telnet文件wait=yes改为no
cobbler system remove --name=mac地址
4./var/lib/cobbler/kickstarts/目录下修改生成的ip相应配置文件

