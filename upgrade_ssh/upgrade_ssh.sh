#!/bin/bash
#Author:xujianan
#modify wusl
#Version:V1.3
#CentOS6.8 CentOS7.5
#20180516
#20191022 1，修改支持ssh 7.9p1  2，文件夹及脚本重命名

# 提供源码包地址：
# https://github.com/openssl/openssl/releases
# wget http://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.6p1.tar.gz
# wget http://mirrors.ibiblio.org/openssl/source/openssl-fips-2.0.16.tar.gz
# wget https://www.openssl.org/source/openssl-fips-2.0.16.tar.gz


root(){
 [ `id -u` -eq 0 ]||
     {
         echo 'ple su root'
         exit  99
     }
}
menu(){
    cat <<EOF
    ----------------------------------------
    |****Please Enter Your Choice:[0-3]****|
    ----------------------------------------
        1.[install telnet]
        2.[install openssl-fips]
        3.[install openssl]
        4.[install openssh]
        5.[close telnet]
        6.[query version]
        7.[onkey install ALL ]
		8.[exit]
EOF
}

telnet(){
  yum install -y telnet* &>/dev/null
  REVGRS=$?
  if [ $REVGRS -eq 0 ];then
      sed -i 's#= yes#= no#g' /etc/xinetd.d/telnet
      mv /etc/securetty /etc/securetty.old
      service xinetd restart &>/dev/null
      lsof -i |grep telnet

  else
      echo 'pls install telnet'
  fi
}

closetelnet(){
if [ -f /etc/xinetd.d/telnet ]
then
    sed -i 's#= no#= yes#g' /etc/xinetd.d/telnet
    service xinetd restart
    lsof -i |grep :tel
else
    echo 'telnet not install'
fi
}

version(){
ssh -V
openssl version -a |head -1
}

opensslfisp(){
echo -e "\033[1;37;42m start yum install gcc zlib-devel pam-devel.x86_64 \033[0m"
yum install -y vim gcc zlib-devel pam-devel.x86_64 &>/dev/null
echo -e "\033[1;37;42m  yum install end \033[0m"
REV=$?
if [ $REV -ne 0 ]
then
    echo 'gcc not install'
fi

[ -d /tmp/upgrade_ssh ] || 
mkdir -p /tmp/upgrade_ssh/
cd /tmp/upgrade_ssh/
tar xf openssl-fips-2.0.16*gz ||
    exit 1


cd openssl-fips-2.0.16
pwd
echo "start config ... "
sleep 2
./config &>/tmp/config.log
REV=$?
if [ $REV -ne 0 ]
then
     echo './config erro'
     exit 1
fi

make -j4 &>/tmp/make.log
make install &>/tmp/make.log
REV=$?
if [ $REV -ne 0 ]
then
    echo 'make erro'
    exit 1
fi

echo 'openssl fisp installed'
}

installssl(){
echo -e "\033[1;37;42m start yum install gcc zlib-devel pam-devel.x86_64 \033[0m"
yum install -y vim gcc zlib-devel pam-devel.x86_64 &>/dev/null
echo -e "\033[1;37;42m  yum install end \033[0m"

\cp  -rf /usr/local/ssl{,.bak}

REV=$?
if [ $REV -ne 0 ]
then
    echo 'gcc not install'
fi

[ -d /tmp/upgrade_ssh ] || 
mkdir -p /tmp/upgrade_ssh/
cd /tmp/upgrade_ssh/
tar xf openssl-1*.tar.gz ||
    exit 1
cd openssl-OpenSSL*

./config &>/tmp/config.log
REV=$?
if [ $REV -ne 0 ]
then
     echo './config erro'
     exit 1
fi

make -j4&>/tmp/make.log
REV=$?
if [ $REV -ne 0 ]
then
    echo 'make erro'
    exit 2
fi


make install &>/tmp/makeinstall.log
REV=$?
if [ $REV -ne 0 ]
then
    echo 'make inistall erro'
    exit 3
fi
mv /usr/bin/openssl {.bak}
ln -s /usr/local/ssl/bin/openssl /usr/bin/openssl
openssl version -a |head -1
echo 'openssl  installed'
}

installssh(){
REV=$?
if [ $REV -ne 0 ]
then
    echo 'yum install erro'
    exit 1
fi

[ -d /tmp/upgrade_ssh ] || 
mkdir -p /tmp/upgrade_ssh/
cd /tmp/upgrade_ssh/
tar xf openssh-*.tar.gz||
    {
        echo 'tar erro'
        exit 1
    }
cd openssh-*
./configure   --prefix=/usr   --sysconfdir=/etc/ssh   --with-md5-passwords   --with-pam   --with-tcp-wrappers   --with-ssl-dir=/usr/local/ssl   --without-hardening &>/tmp/config.log
REV=$?
if [ $REV -ne 0 ]
then
     echo './config erro'
     exit 1
fi

make -j4&>/tmp/make.log
REV=$?
if [ $REV -ne 0 ]
then
    echo 'make erro'
    exit 2
fi


make install &>/tmp/makeinstall.log
REV=$?
if [ $REV -ne 0 ]
then
    echo 'make inistall erro'
    exit 1
fi
 [ -f /etc/init.d/sshd ]&&
     mv /etc/init.d/sshd /etc/init.d/sshd.bak
 [ -d /etc/ssh ]&&
     cp -r /etc/ssh /etc/ssh.bak

if ((`cat /etc/redhat-release |grep -o -P '\d'|head -1` > 6));then
    yum -y remove openssh-server
fi

/bin/cp -a /tmp/upgrade_ssh/openssh-*/contrib/redhat/sshd.init /etc/init.d/sshd
chmod +x /etc/init.d/sshd
chkconfig --add sshd
/bin/cp -a /tmp/upgrade_ssh/openssh-*/ssh_config /etc/ssh/ssh_config
/bin/cp -a /tmp/upgrade_ssh/openssh-*/sshd_config /etc/ssh/sshd_config
/bin/cp -a /tmp/upgrade_ssh/openssh-*/sshd /usr/sbin/
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "KexAlgorithms diffie-hellman-group1-sha1,diffie-hellman-group14-sha1,diffie-hellman-group-exchange-sha1,diffie-hellman-group-exchange-sha256
" >> /etc/ssh/sshd_config
sed -i "/PermitRootLogin/s/no/yes/g" /etc/ssh/sshd_config
chmod 0600 /etc/ssh/ssh_host_*
service sshd restart

REV=$?
if [ $REV -eq 0 ]
then
    echo 'openssh  installed'
else
    echo 'openssh start failed '
fi

ssh -V
}

onkey(){
echo "install openssl-fisp"
sleep 1
opensslfisp
echo "install openssl"
sleep 1
installssl
echo "install openssh"
sleep 1
installssh
}

mase(){
clear
while true
do
 menu
 read -p 'please input a number:' nmu1
 case "$nmu1" in
     1)
         clear
         telnet
         ;;    
     
     2) 
         clear
         opensslfisp
         ;;
     
     3)
         clear 
         installssl
         ;;

     4)
        clear 
         installssh
         ;;

     5) 
         clear
         closetelnet
         ;;
     6) 
         clear
         version
         ;;
     7)
 	 clear
	 onkey
 	 ;;

     *) 
         clear
         break
    esac
done
}

root
mase
#onkey