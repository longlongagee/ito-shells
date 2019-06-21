#!/bin/bash 
# richstonedt-devops
# wushaolong,wanglingda,xujianan
# 20171122
# centos6.8

menu(){
    cat <<EOF
    -------------------------------
    |****Please Enter Your Choice:|
    -------------------------------
	1.进行普通的合规修改
	2.进行 tomcat 合规
	3.进行 mysql 合规
	4.江门新增合规项目
	5.恢复江门文件权限
	6.恢复root远程访问
	7.禁止root远程访问
	8.新增运维组账号
********按其他[任意字符]退出********

EOF
       }
	   
switch(){
clear
while true
do
 menu
 read -p 'please input a number:' nmu1
 case "$nmu1" in
     1)
         clear
         normal
         ;;    
     
     2) 
         clear
         tomcat
         ;;
     
     3)
         clear 
         mysql
         ;;

     4)
        clear 
         jmnew
         ;;

     5) 
         clear
         PermitFile
         ;;

	 6) 
         clear
         PermitRoot
         ;;
		 
	 7) 
         clear
         NoPermitRoot
         ;;
		 
	 8) 
         clear
         createuser
         ;;
		 
     *) 
         clear
         break
    esac
done
}

normal(){   
echo "操作系统版本"
cat  /etc/centos-release
echo "本脚本使用于CentOS 6的操作系统"
 

echo "一、检查项名称：检查主机访问控制（IP限制）"
echo "all:172.13.:DENY" >>  /etc/hosts.deny 
echo "all:192.:allow "  >>  /etc/hosts.allow  
echo "all:172.16.:allow"  >>  /etc/hosts.allow 
echo "all:10.:allow "  >>  /etc/hosts.allow 

sleep 10

echo "二、检查项名称：检查用户缺省UMASK 修改为027  "
echo "备份相关文件"
cp -p /etc/profile /etc/profile_bak
cp -p /etc/csh.login /etc/csh.login_bak
cp -p /etc/csh.cshrc /etc/csh.cshrc_bak
cp -p /etc/bashrc /etc/bashrc_bak
cp -p /root/.bashrc /root/.bashrc_bak
cp -p /root/.cshrc /root/.cshrc_bak

echo "观察是否有备份文件"
ls -ltr  /etc/*_bak
sleep 3
ls -a ~/*_bak

sleep 5

echo "/etc/profile    ----将UMASK值修改为027"
sed -i "/umask/s/022/027/" /etc/profile
sleep 2 

echo "/etc/csh.cshrc    ----将UMASK值修改为027"
sed -i "/umask/s/022/027/"  /etc/csh.cshrc
sleep 2 

echo "/etc/bashrc      ----将UMASK值修改为027"
sed -i "/umask/s/022/027/"  /etc/bashrc  
sleep 2 

# 第三点：
echo "三、检查项名称：检查登录提示-是否设置ssh警告Banner"

echo "步骤1 执行如下命令创建ssh banner信息文件"
touch /etc/sshbanner
chown bin:bin /etc/sshbanner
chmod 644 /etc/sshbanner
echo " Authorized users only. All activity may be monitored and reported "   >> /etc/sshbanner
sleep  5


echo "步骤2 修改vi /etc/ssh/sshd_config文件，添加如下行："
echo "Banner /etc/sshbanner"  >>   /etc/ssh/sshd_config
sleep  10


echo "四、检查项名称：检查帐号文件权限设置"
echo "1、备份："
cp -p /etc/passwd /etc/passwd_bak
cp -p /etc/shadow /etc/shadow_bak
cp -p /etc/group /etc/group_bak

sleep 5

echo "2、修改权限："
chmod 0644 /etc/passwd
chmod 0400 /etc/shadow
chmod 0644 /etc/group

sleep 10

echo "五、检查项名称：检查口令生存周期要求"
echo "1、执行备份："
cp -p /etc/login.defs /etc/login.defs_bak
echo "2、修改策略设置："
echo "修改PASS_MIN_LEN的值为8"
sed -i "/PASS_MIN_LEN/s/5/8/"  /etc/login.defs
echo "修改PASS_MAX_DAYS的值为90"
sed -i  "s/99999/90/" /etc/login.defs
sleep 10


echo "六、检查项名称：检查登录提示-是否设置登录成功后警告Banner "
echo " Authorized users only. All activity may be monitored and reported " >> /etc/motd

sleep 5


echo "八、检查项名称：检查登录提示-更改ftp警告Banner "
echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5


echo  "九、检查项名称：检查是否禁止icmp重定向"
echo "1、备份文件："
cp -p /etc/sysctl.conf /etc/sysctl.conf_bak

echo "2:执行相关命令:"
echo 'net.ipv4.conf.all.accept_redirects=0' >>/etc/sysctl.conf
sysctl -p
sleep 10

echo "十、检查项名称：检查是否禁止匿名ftp"
#1、编辑FTP配置文件
#vi /etc/vsftpd/vsftpd.conf
#在配置文件中添加行：
#anonymous_enable=NO
echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5

echo "十一、检查项名称：检查FTP配置-限制FTP用户登录后能访问的目录"
#1、修改/etc/vsftpd.conf
#vi /etc/vsftpd/vsftpd.conf
#确保以下行未被注释掉，如果没有该行，请添加：
#chroot_local_user=YES


echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5


echo "十二、检查项名称：检查FTP配置-设置FTP用户登录后对文件、目录的存取权限 "

echo "关于vsftpd的配置修改另外操作，如无安装则无需修改相关配置"
sleep 5


echo  " 十三、检查项名称：检查是否配置远程日志保存"
echo "1、执行备份： "
cp -p /etc/rsyslog.conf /etc/rsyslog.conf_bak
echo "*.*   @192.168.6.254"  >> /etc/rsyslog.conf
echo "3、重启syslog服务"
/etc/init.d/rsyslog restart
sleep 10



echo  "十四、检查项名称：检查是否设置登录超时"
echo "1、执行备份： "
cp -p /etc/profile  /etc/profile_bak

echo "清除TMOUT相关的配置："
sed -i "/TMOUT/d"  /etc/profile

echo "修改vi /etc/profile文件增加以下两行："
echo "TMOUT=180"  >> /etc/profile
echo "export TMOUT"  >> /etc/profile
sleep 3


echo "2、修改 vi /etc/csh.cshrc文件，添加如下行：" 
echo "set autologout=599"  >>  /etc/csh.cshrc
sleep 10



echo " 十五、检查项名称：检查口令重复次数限制 "
echo "1、执行备份："
cp -p /etc/pam.d/system-auth /etc/pam.d/system-auth_bak
sleep 2
echo "2、创建文件/etc/security/opasswd，并设置权限（执行以下命令）"
touch /etc/security/opasswd
chown root:root /etc/security/opasswd
chmod 600 /etc/security/opasswd
sleep 2
echo "3、修改策略设置："
echo "在password sufficient pam_unix.so sha512 shadow nullok try_first_pass use_authtok所在行
后面增加remember=5，保存退出；"
sed -i "s/use_authtok/use_authtok remember=5/"   /etc/pam.d/system-auth

sleep 10

echo "十六、检查口令锁定策略"

echo "1、修改策略设置："
sed  -i '/pam_env.so/a\auth        required      pam_tally2.so deny=6 onerr=fail no_magic_root unlock_time=120' /etc/pam.d/system-auth
sleep 5

echo "十七、检查密码复杂度策略中设置的大写、小写、数字、特殊字符个数"

sed -i '/pam_cracklib.so/s/^.*/password    requisite pam_cracklib.so ocredit=-1 lcredit=-1 dcredit=-1/' /etc/pam.d/system-auth
sleep 5

echo "十八、禁止root用户远程telnet登录"
sed -i '/pam_securetty/s/^.*/auth required pam_securetty.so/' /etc/pam.d/login
sleep 3
echo "安全合规配置初始化完成！"
}

tomcat(){
pathm=/usr/local/tomcat/webapps/manager/META-INF/context.xml
pathhm=/usr/local/tomcat/webapps/host-manager/META-INF/context.xml
pathserver=/usr/local/tomcat/conf/server.xml
pathtomusr=/usr/local/tomcat/conf/tomcat-users.xml

echo "##tomcat 生成keystone，支持https加密协议#####"
echo -e "hantele\nhantele\nrd\nrd\nrd\ngz\ngz\ncn\ny\n\n" | keytool -genkey -alias tomcat -keyalg RSA -validity 3650 -keystore /usr/local/tomcat/conf/.keystore >/dev/null 2>&1
sleep 3
set -e
sed -i '69,71s/^.*//g;/.*keystoreFile.*/d' /usr/local/tomcat/conf/server.xml
sleep 1
sed -i '69a\<Connector port="8080"  protocol="HTTP\/1.1" SSLEnabled="true" enableLookups="true"  acceptCount="10" scheme="https" secure="true" clientAuth="false" keystoreFile="\/usr\/local\/tomcat\/conf\/.keystore" keystorePass="hantele"  sslProtocol="TLS" \/>'  /usr/local/tomcat/conf/server.xml
sleep 1
sed -i 's/\r//g' /usr/local/tomcat/conf/server.xml


#####tomcat 设置多用户登陆远程管理####
echo "###tomcat 设置多用户登陆远程管理###"
sleep 2
sed -i "44,55{/.*role.*/d;/.*username.*/d}" /usr/local/tomcat/conf/tomcat-users.xml
sleep 1
sed -i '/users>/i\<role rolename="tomcat"\/>\n<role rolename="role1"\/>\n<role rolename="manager"\/>\n<role rolename="manager-gui"\/>\n<user username="tomcat" password="hantele" roles="tomcat,manager,manager-gui"\/>\n<user username="both" password="hantele" roles="tomcat,role1"\/>\n<user username="role1" password="hantele" roles="role1"\/>' /usr/local/tomcat/conf/tomcat-users.xml
sleep 1
sed -i 's/\r//g' /usr/local/tomcat/conf/tomcat-users.xml


##Tomcat 设置多用户登陆远程ip地址限制###
echo "##Tomcat 设置多用户登陆远程ip地址限制###"
sleep 2
# echo 'n' | cp $pathm{,.bak} >/dev/null 2>1&
# echo 'n' | cp $pathhm{,.bak} >/dev/null 2>&1
# sed -i "18,21{/.*className=.*/d;/.*allow=.*/d}" {$pathm,$pathhm}
# sleep 1
# sed -i 's/\r//g' {$pathm,$pathhm}
}

mysql(){
echo "进行mysql合规修改"
\cp -f /etc/my.cnf.bak /etc/my.cnf >/dev/null 2>&1
\cp -f  /etc/my.cnf /etc/my.cnf.bak >/dev/null 2>&1
echo "general_log = 1" >>/etc/my.cnf
echo "slow_query_log = 1 " >>/etc/my.cnf
echo "log_slave_updates " >>/etc/my.cnf
echo "server-id = 1" >>/etc/my.cnf
echo "log_bin = mysql-bin " >>/etc/my.cnf
sed -i "/mysql/s/var.*/var\/lib\/mysql:\/bin\/bash/" /etc/passwd
touch /var/lock/subsys/mysqld
chown mysql:mysql /var/lock/subsys/mysqld
su - mysql -c "service mysqld restart"
}

createuser(){
group=yunwei

if [ $(awk -F ':' '{print $1}' /etc/group |grep "$group" |wc -l) -eq 0 ];then
    groupadd $group
fi
[ -d /home/users ] || mkdir -p /home/users
 
for user in xujianan wushaolong wanglingda panjian
do
 if [ $(cat /etc/passwd |grep $user|wc -l) -ne 0 ] ;then
     echo "Hantele!17"| passwd --stdin $user
      usermod -a -G $group $user
else
    useradd -d /home/users/$user -g $group $user
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
}

NoPermitRoot(){
echo "检查项名称：检查是否限制root远程登录"
echo "1、执行备份"
cp -p /etc/securetty /etc/securetty_bak
cp -p /etc/ssh/sshd_config /etc/ssh/sshd_config_bak

#echo "2、创建临时用户:admin/admin123456并分配sudo权限"
#useradd admin
#echo "admin123456"  |passwd --stdin admin
#echo "admin   ALL=(ALL)  ALL " >> /etc/sudoers 

# 不关闭root用户的远程登录，否则无法进行4A平台的扫描
echo " 禁止root用户远程登录系统："
sed -i  "s/#PermitRootLogin/PermitRootLogin/" /etc/ssh/sshd_config
sed -i  "/PermitRootLogin/s/yes/no/"  /etc/ssh/sshd_config && service sshd restart
sleep 5
}

PermitRoot(){
echo " 允许root用户远程登录系统："
sed -i  "s/#PermitRootLogin/PermitRootLogin/" /etc/ssh/sshd_config
sed -i  "/PermitRootLogin/s/no/yes/"  /etc/ssh/sshd_config && service sshd restart
sleep 3
}

PermitFile(){
set -e
echo "恢复---操作系统Linux目录文件权限安全基线要求项"
sleep 2
chmod 755 /etc/rc5.d
chmod 750 /etc/shadow 
chmod 755 /etc/rc2.d/
chmod 700 /etc/ssh/ssh_host_dsa_key 
chmod 755 /etc/rc3.d/ 
chmod 755 /etc/group
chmod 755 /etc/rc1.d/
chmod 755 /etc/rc6.d/ 
chmod 644 /etc/services 
#chmod 1777 /tmp 
chmod 755 /etc/rc.d/init.d/
chmod 755 /etc/rc4.d
chmod 755 /etc/rc0.d/
chmod 755 /etc/ 
}

jmnew(){
sed -i "/TMOUT/d"  /etc/profile
echo "一、修改vi /etc/profile文件增加以下两行："
echo "TMOUT=180"  >> /etc/profile
echo "export TMOUT"  >> /etc/profile
sleep 3

echo "二、检查项名称：检查用户缺省UMASK 修改为027"
echo "/etc/profile    ----将UMASK值修改为027"
sed -i "/umask/s/002/027/" /etc/profile
sleep 2 

echo "/etc/csh.cshrc    ----将UMASK值修改为027"
sed -i "/umask/s/002/027/"  /etc/csh.cshrc
sleep 2 

cp /etc/csh.login /etc/csh.login.bak
echo "/etc/csh.login      ----将UMASK值修改为027"
sed -i "/umask/d"  /etc/csh.login 
echo "umask 027" >>/etc/csh.login 
sleep 2  

echo "/etc/bashrc      ----将UMASK值修改为027"
sed -i "/umask/s/002/027/"  /etc/bashrc  
sleep 2 
echo "三、操作系统Linux目录文件权限安全基线要求项"
touch /etc/xinetd.conf
chmod 750 /etc/xinetd.conf
chmod 750 /etc/rc5.d
chmod 750 /etc/shadow 
chmod 750 /etc/rc2.d/
chmod 700 /etc/ssh/ssh_host_dsa_key 
chmod 750 /etc/rc3.d/ 
chmod 755 /etc/group
chmod 750 /etc/rc1.d/
chmod 750 /etc/rc6.d/ 
chmod 750 /etc/services 
chmod 750 /etc/rc.d/init.d/
chmod 750 /etc/rc4.d
chmod 750 /etc/rc0.d/
chmod 750 /etc/ 

echo "四、操作系统Linux core dump 状态安全基线要求项"
sleep 2
echo "n" | cp /etc/security/limits.conf{,.bak} >/dev/null 2>&1
sed -i '/* soft core 0/d' /etc/security/limits.conf
sed -i '/* hard core 0/d' /etc/security/limits.conf
echo "* soft core 0" >>/etc/security/limits.conf
echo "* hard core 0" >>/etc/security/limits.conf
}

switch
