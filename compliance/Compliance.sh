#!/bin/bash
#modified_1 20171122
#modified_2 20180423
#modified_2 20180516 增加重复执行脚本的可靠性
# by Richstone

normal(){
echo "操作系统版本"
cat  /etc/centos-release
echo "本脚本使用于CentOS 6/7 的操作系统"
 

echo "一、检查项名称：检查主机访问控制（IP限制）"
sed -i "/DENY/d" /etc/hosts.deny
echo "all:172.13.:DENY" >>  /etc/hosts.deny
sed -i "/allow/d" /etc/hosts.allow
echo "all:192.:allow "  >>  /etc/hosts.allow
echo "all:172.16.:allow"  >>  /etc/hosts.allow 
echo "all:10.:allow "  >>  /etc/hosts.allow
sleep 1


echo "二、检查项名称：检查用户缺省UMASK 修改为027  "
echo "备份相关文件"
cp -p /etc/profile{,.`date +%y%m%d`.bak}
cp -p /etc/csh.login{,.`date +%y%m%d`.bak}
cp -p /etc/csh.cshrc{,.`date +%y%m%d`.bak}
cp -p /etc/bashrc{,.`date +%y%m%d`.bak}
cp -p /root/.bashrc{,.`date +%y%m%d`.bak}
cp -p /root/.cshrc{,.`date +%y%m%d`.bak}

echo "/etc/profile    ----将UMASK值修改为027"
sed -i "/umask/s/022/027/;/umask/s/002/027/" /etc/profile
sleep 1

echo "/etc/csh.cshrc    ----将UMASK值修改为027"
sed -i "/umask/s/022/027/;/umask/s/002/027/"  /etc/csh.cshrc
sleep 1

echo "/etc/bashrc      ----将UMASK值修改为027"
sed -i "/umask/s/022/027/;/umask/s/002/027/"  /etc/bashrc  
sleep 1

echo "/etc/csh.login      ----将UMASK值修改为027"
sed -i "/umask/d"  /etc/csh.login 
echo "umask 027" >>/etc/csh.login 
sleep 1


echo "三、检查项名称：检查登录提示-是否设置ssh警告Banner"
echo "步骤1 执行如下命令创建ssh banner信息文件"
touch /etc/sshbanner
chown bin:bin /etc/sshbanner
chmod 644 /etc/sshbanner
sed -i "/Authorized/d" /etc/sshbanner
echo " Authorized users only. All activity may be monitored and reported "   >> /etc/sshbanner
echo "步骤2 修改vi /etc/ssh/sshd_config文件，添加如下行："
sed -i "/Banner \/etc\/sshbanner/d" /etc/ssh/sshd_config
echo "Banner /etc/sshbanner"  >>   /etc/ssh/sshd_config
sleep 1


echo "四、检查项名称：检查帐号文件权限设置"
echo "1、备份："
cp -p /etc/passwd{,.`date +%y%m%d`.bak}
cp -p /etc/shadow{,.`date +%y%m%d`.bak}
cp -p /etc/group{,.`date +%y%m%d`.bak}
sleep 1
echo "2、修改权限："
chmod 0644 /etc/passwd
chmod 0400 /etc/shadow
chmod 0644 /etc/group
sleep 1


echo "五、检查项名称：检查口令生存周期要求"
echo "1、执行备份："
cp -p /etc/login.defs{,.`date +%y%m%d`.bak}
echo "2、修改策略设置："
echo "修改PASS_MIN_LEN的值为8"
sed -i "/PASS_MIN_LEN/s/5/8/"  /etc/login.defs
echo "修改PASS_MAX_DAYS的值为90"
sed -i  "/PASS_MAX_DAYS/s/99999/90/" /etc/login.defs
sleep 1


echo "六、检查项名称：检查登录提示-是否设置登录成功后警告Banner "
sed -i "/Authorized/d" /etc/motd
echo " Authorized users only. All activity may be monitored and reported " >> /etc/motd
sleep 1


echo  "七、检查项名称：检查是否禁止icmp重定向"
echo "1、备份文件："
cp -p /etc/sysctl.conf{,.`date +%y%m%d`.bak}
echo "2:执行相关命令:"
sed -i "/net.ipv4.conf.all.accept_redirects=0/d" /etc/sysctl.conf
echo 'net.ipv4.conf.all.accept_redirects=0' >>/etc/sysctl.conf
sysctl -p
sleep 1


echo  " 八、检查项名称：检查是否配置远程日志保存"
echo "1、执行备份： "
cp -p /etc/rsyslog.conf{,.`date +%y%m%d`.bak}
sed -i "/188.0.56.53/d" /etc/rsyslog.conf
echo "*.*   @188.0.56.53"  >> /etc/rsyslog.conf
echo "3、重启syslog服务"
service rsyslog restart
sleep 1


echo  "九、检查项名称：检查是否设置登录超时"
echo "1、执行备份： "
cp -p /etc/profile{,.`date +%y%m%d`.bak}
echo "清除TMOUT相关的配置："
sed -i "/TMOUT/d"  /etc/profile
echo "修改vi /etc/profile文件增加以下两行："
echo "TMOUT=180"  >> /etc/profile
echo "export TMOUT"  >> /etc/profile
sleep 1
echo "2、修改 vi /etc/csh.cshrc文件，添加如下行："
sed -i "/autologout/d"  /etc/csh.cshrc
echo "set autologout=599"  >>  /etc/csh.cshrc
sleep 1


echo " 十、检查项名称：检查口令重复次数限制 "
echo "1、执行备份："
cp /etc/pam.d/system-auth{,.`date +%Y%m%d`.bak}
sleep 1
echo "2、创建文件/etc/security/opasswd，并设置权限（执行以下命令）"
touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd
sleep 1
echo "3、修改策略设置："
echo "在password sufficient pam_unix.so sha512 shadow nullok try_first_pass use_authtok所在行
后面增加remember=5;"
sed -i "/md5/s/^.*/password sufficient pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5/" /etc/pam.d/system-auth
sed -i "/sha512/s/^.*/password sufficient pam_unix.so sha512 shadow nullok try_first_pass use_authtok remember=5/" /etc/pam.d/system-auth
sleep 1


echo "十一、检查口令锁定策略"
echo "1、修改策略设置："
sed -i "/pam_tally2.so/d"  /etc/pam.d/system-auth
sed -i '15a\auth        required      pam_tally2.so deny=6 onerr=fail no_magic_root unlock_time=120' /etc/pam.d/system-auth
sleep 1


echo "十二、检查密码复杂度策略中设置的大写、小写、数字、特殊字符个数"
sed -i '/pam_cracklib.so/d' /etc/pam.d/system-auth
sed -i '15a\password    requisite     pam_cracklib.so  minclass=2 minlen=8' /etc/pam.d/system-auth
sleep 1


echo "十三、禁止root用户远程telnet登录"
sed -i '/pam_securetty/s/^.*/auth required pam_securetty.so/' /etc/pam.d/login
sleep 1


echo '十四，锁定指定账户.';
sleep 1
cp /etc/shadow{,.`date +%Y%m%d`.bak}
cp /etc/passwd{,.`date +%Y%m%d`.bak}
for _usr in lp nobody uucp games rpm smmsp nfsnobody listen gdm webservd nobody4 noaccess
do
    passwd -l ${_usr}
    sed -i "/^$_usr/s/sbin\/nologin/bin\/false/" /etc/passwd
done


echo '十五，创建运维账号'
createuser
sleep 1

echo '十六，限制root远程登录'
#NoPermitRoot
sleep 1

echo '十七，延长口令生存周期'
sed -i '/chage/d' /etc/crontab
cat >> /etc/crontab <<EOOF
* * 1 * * root for i in \`cut -d : -f 1 /etc/passwd\`; do chage -M -1 \${i};  done;
EOOF
for i in `cut -d : -f 1 /etc/passwd`; do chage -M -1 ${i};  done;

echo "安全合规配置初始化完成！"
}


createuser(){
group=yunwei
if [ $(awk -F ':' '{print $1}' /etc/group |grep "$group" |wc -l) -eq 0 ];then groupadd $group; fi
for user in yunwei
do
if [ $(cat /etc/passwd |grep ${user}|wc -l) -ne 0 ] ;then
    echo "Hantele@17"| passwd --stdin ${user}
    usermod -a -G ${group} ${user}
else
    useradd -m -g $group $user
    echo "Hantele@17" | passwd --stdin ${user}
    usermod -a -G ${group} ${user}
fi
done
if [ $(cat /etc/sudoers |grep yunwei |wc -l) -eq 0 ];then
      echo "%"$group"  ALL=(ALL) ALL" >> /etc/sudoers
      echo " $group create succeed"
fi
}


NoPermitRoot(){
echo " 禁止root用户远程登录系统："
cp -p /etc/securetty{,.`date +%Y%m%d`.bak}
cp -p /etc/ssh{,.`date +%Y%m%d`.bak}

# 不关闭root用户的远程登录，否则无法进行4A平台的扫描
sed -i  "s/#PermitRootLogin/PermitRootLogin/" /etc/ssh/sshd_config
sed -i  "/PermitRootLogin/s/yes/no/"  /etc/ssh/sshd_config 
#service sshd restart
sleep 1
}

normal

