#!/usr/bin/env bash
#@author:wanglingda wusl
#@file: compliance.sh
#@time: 2018/09/1
#@Description: 用于服务器初始化或外网服务器防护
#@version: 1.0


echo "一、检查项名称：检查口令生存周期要求"
sleep 1

echo "1、执行备份："
cp -p /etc/login.defs{,.`date +%y%m%d`.bak}
echo "2、修改策略设置："
echo "修改PASS_MIN_LEN的值为8"
sed -i "/PASS_MIN_LEN/s/5/8/"  /etc/login.defs
echo "修改PASS_MAX_DAYS的值为90"
sed -i  "/PASS_MAX_DAYS/s/99999/90/" /etc/login.defs
sed -i "/PASS_MIN_DAYS/s/0/6/" /etc/login.defs
sed -i "/PASS_WARN_AGE/s/7/30/" /etc/login.defs


echo "二、检查项名称：检查用户缺省UMASK 修改为027  "
sleep 3

echo "备份相关文件"
cp -p /etc/profile{,.`date +%y%m%d`.bak}
cp -p /etc/csh.login{,.`date +%y%m%d`.bak}
cp -p /etc/csh.cshrc{,.`date +%y%m%d`.bak}
cp -p /etc/bashrc{,.`date +%y%m%d`.bak}
cp -p /root/.bashrc{,.`date +%y%m%d`.bak}
cp -p /root/.cshrc{,.`date +%y%m%d`.bak}

echo "/etc/profile    ----将UMASK值修改为027"
sed -i "/umask/s/022/027/;/umask/s/002/027/" /etc/profile

echo "/etc/csh.cshrc    ----将UMASK值修改为027"
sed -i "/umask/s/022/027/;/umask/s/002/027/"  /etc/csh.cshrc

echo "/etc/bashrc      ----将UMASK值修改为027"
sed -i "/umask/s/022/027/;/umask/s/002/027/"  /etc/bashrc

echo "/etc/csh.login      ----将UMASK值修改为027"
sed -i "/umask/d"  /etc/csh.login
echo "umask 027" >>/etc/csh.login


#修改相关文件权限
echo "三、检查项名称：检查帐号文件权限设置"
sleep 2
echo "1、备份："
cp -p /etc/passwd{,.`date +%y%m%d`.bak}
cp -p /etc/shadow{,.`date +%y%m%d`.bak}
cp -p /etc/group{,.`date +%y%m%d`.bak}

echo "2、修改权限："
chmod 0644 /etc/passwd
chmod 0400 /etc/shadow
chmod 0644 /etc/group


echo "四、操作系统Linux core dump 状态安全基线要求项"
sleep 2
echo "n" | cp /etc/security/limits.conf{,.bak} >/dev/null 2>&1
sed -i '/* soft core 0/d' /etc/security/limits.conf
sed -i '/* hard core 0/d' /etc/security/limits.conf
echo "* soft core 0" >>/etc/security/limits.conf
echo "* hard core 0" >>/etc/security/limits.conf

#chattr +a /etc/passswd
#chattr +a /etc/shadow
#chattr +a /etc/gshadow
#chattr +a /etc/group

#账号超时设置
echo  "五、检查项名称：检查是否设置登录超时"
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


echo "六、 禁止root用户远程登录系统："
cp -p /etc/securetty{,.`date +%Y%m%d`.bak}
cp -p /etc/ssh{,.`date +%Y%m%d`.bak}

# 不关闭root用户的远程登录，否则无法进行4A平台的扫描
sed -i  "s/#PermitRootLogin/PermitRootLogin/" /etc/ssh/sshd_config
sed -i  "/PermitRootLogin/s/yes/no/"  /etc/ssh/sshd_config
service sshd restart


echo "七、禁止root用户远程telnet登录"
sed -i '/pam_securetty/s/^.*/auth required pam_securetty.so/' /etc/pam.d/login
sleep 1


echo '八，锁定系统创建、不使用账户.';
sleep 1
cp /etc/shadow{,.`date +%Y%m%d`.bak}
cp /etc/passwd{,.`date +%Y%m%d`.bak}
for _usr in lp nobody uucp games rpm smmsp nfsnobody listen gdm webservd nobody4 noaccess
do
    passwd -l ${_usr}
    sed -i "/^$_usr/s/sbin\/nologin/bin\/false/" /etc/passwd
done


# 日志审计
echo "七、添加系统日志审计："
echo -e "\033[0;41;1m 注意已接入省移动日志系统服务器，不能使用本项目！ \033[0m"
sleep 2

echo '1、删除旧日志设置'
sed -i "75,\${/HIST/d}" /etc/profile
sleep 1

echo '
HISTSIZE=1000

HISTTIMEFORMAT="%Y/%m/%d %T ";export HISTTIMEFORMAT

export HISTORY_FILE=/var/log/audit.log
' >> /etc/profile

cat << EOF >> /etc/profile
export PROMPT_COMMAND='{ thisHistID=\`history 1|awk "{print \\\\\$1}"\`;lastCommand=\`history 1| awk "{\\\\\$1=\"\" ;print}"\`;user=\`id -un\`;whoStr=(\`who -u am i\`);realUser=\${whoStr[0]};logMonth=\${whoStr[2]};logDay=\${whoStr[3]};logTime=\${whoStr[4]};pid=\${whoStr[6]};ip=\${whoStr[7]};if [ \${thisHistID}x != \${lastHistID}x ];then echo -E \`date "+%Y/%m/%d %H:%M:%S"\` \$user\(\$realUser\)@\$ip[PID:\$pid][LOGIN:\$logMonth \$logDay \$logTime][\$PWD] --- \$lastCommand ;lastHistID=\$thisHistID;fi; } >> \$HISTORY_FILE'
EOF
echo '2、添加新规则并启用'
source /etc/profile
sleep 1


echo '3、更新日志文件权限'
touch /var/log/audit.log
chown nobody:nobody /var/log/audit.log
chmod 002 /var/log/audit.log
chattr +a /var/log/audit.log
sleep 1

echo '4、创建定时任务切割日志'
sed -i "/audit.log/d" /etc/crontab
cat >> /etc/crontab <<EOOF
* 1 * * * root /bin/cp -a /var/log/audit.log{,.\`date +%F\`.bak}
EOOF

echo '八、对挖矿地址进行屏蔽：'
sleep 1
echo '
iptables -A INPUT -s xmr.crypto-pool.fr -j DROP
iptables -A OUTPUT -d xmr.crypto-pool.fr -j DROP
iptables -A INPUT -s mine.moneropool.com -j DROP
iptables -A OUTPUT -d mine.moneropool.com -j DROP
' > /etc/rc.local
chmod +x /etc/rc.d/rc.local

iptables -A INPUT -s xmr.crypto-pool.fr -j DROP
iptables -A OUTPUT -d xmr.crypto-pool.fr -j DROP
iptables -A INPUT -s mine.moneropool.com -j DROP
iptables -A OUTPUT -d mine.moneropool.com -j DROP

iptables -A INPUT -s aluka.info -j DROP
iptables -A OUTPUT -d aluka.info -j DROP

echo '九、扫描高危默认端口:'

for i in 1521 6379 5432 3306 23 22 21 445 3389 139
do
    if [[ `netstat -anutp |grep -w ${i} |wc -l` -ge 1 ]]; then
        if [[ ${i} -eq 6379 ]]; then
            echo -e "\033[0;41;1m 扫描到Redis 开放默认端口 6379，请检查是否设置密码！ \033[0m"
            echo -e '\033[0;41;1m redis-cli -p 6379 \033[0m'
            sleep 5
        elif [[ ${i} -eq 5432 ]]; then
            echo -e "\033[0;41;1m 扫描到postgres 开放默认端口 5432 ！ \033[0m"
            sleep 5
        else
            echo -e "\033[0;41;1m 扫描到开放默认端口" ${i} "！\033[0m"
        fi
    else
        echo -e "\033[0;32;1m 扫描不存在高危默认端口"${i} " \033[0m"
    fi
done

