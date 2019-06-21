vnc()
{
yum groupinstall "GNOME Desktop" -y  # 600MB 左右
yum install tigervnc-server -y
cp /lib/systemd/system/vncserver@.service /etc/systemd/system/vncserver@:1.service
vim /etc/systemd/system/vncserver@:1.service #修改配置
systemctl daemon-reload
vncpasswd # 密码
systemctl stop firewalld.service
systemctl enable vncserver@:1.service #cent6 chkconfig vncserver on
vncserver #启动服务端口
}

vnc


kvm:
http://www.cnblogs.com/idnf/p/4645202.html

#前提：
lsmod | grep kvm
yum install qemu-kvm virt-manager libvirt
#yum groupinstall "Virtualization" "Virtualization Client" "Virtualization Platform"
service libvirtd restart

	
a. 创建 ifcfg-br0 文件，内容如下：
cd /etc/sysconfig/network-scripts/
cat <<EOF > ifcfg-br0
BOOTPROTO=static
DEVICE=br0
MTU=1500
ONBOOT=yes
TYPE=Bridge
USERCTL=no
IPADDR=192.168.8.1
NETMASK=255.255.255.0
#DNS1=114.114.114.114
#GATEWAY=
EOF

b. 移除掉原来的 ifcfg-enp0s25 ,重新创建该文件，内容如下：
cat <<EOF > ifcfg-eno1
BOOTPROTO=none
DEVICE=eno1 ##注意##
NM_CONTROLLED=no
ONBOOT=yes
BRIDGE=br0
EOF

c. 重启网络服务
service network restart && brctl show

d. 镜像压缩
virt-sparsify --compress ./win2k12r2.qcow2 Windows-Server-2012R2-sd.qcow2



