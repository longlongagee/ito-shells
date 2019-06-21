#!/usr/bin/env bash
#@author:shao long 
#@file: 
#@time: 2018/05/10 
#@Description: 接入省公司日志审计，服务器配置修改


### 配置备份
cp -a /etc/rsyslog.conf{,.`date +%Y%m%d`}
cp -a /etc/ssh/sshd_config{,.`date +%Y%m%d`}
cp -a /etc/profile{,.`date +%Y%m%d`}


### rsyslog.conf 修改
echo "检查是否存在 authpriv.* /var/log/secure "
grep '/var/log/secure' /etc/rsyslog.conf
sleep 3

sed -i "/188.0.56.53/d;/192.168.6.254/d" /etc/rsyslog.conf  #删除合规生成的无用日志服务器
cat << EOFF >> /etc/rsyslog.conf
authpriv.*      @188.0.56.53
local2.info     @188.0.56.53
EOFF

echo "检查是SyslogFacility 属性，并修改为AUTHPRIV"
grep "SyslogFacility" /etc/ssh/sshd_config
sleep 2
sed -i "s/#SyslogFacility AUTH/SyslogFacility AUTHPRIV/g" /etc/ssh/sshd_config
grep "SyslogFacility" /etc/ssh/sshd_config
sleep 2


### profile 修改
echo "profile 配置修改 检查是否已经修改PROMPT_OOMMAND"
grep PROMPT_COMMAND /etc/profile
if (( $? == 0 )); then
sed -i /PROMPT_COMMAND/d /etc/profile
fi
cat <<EOF >> /etc/profile
export PROMPT_COMMAND='{ msg=\$(history 1 | { read x y; echo \$y; });logger -p local2.info "[euid=\$(whoami)]":\$(who am i):[\`pwd\`]"\$msg"; }'
EOF

grep PROMPT_COMMAND /etc/profile
sleep 2


### 服务重启/配置生效
source /etc/profile
service rsyslog restart
service sshd reload


### 应用日志接入
yum install ftp -y
if [[ $? != 0 ]];then echo "ftp客户端未安装"; fi
mkdir -p /var/log/operation
cat << EOF > /usr/SOAPLOG.sh
#!/bin/bash
ftp -n<<!
open 188.0.56.52
user testuser 13#applog4%
binary
hash
cd /var/soap/operation
lcd /var/log/operation
prompt
mput *
close
bye
!
EOF

sed -i "/SOAPLOG/d" /etc/crontab
cat << EOF >> /etc/crontab
0 */1 * * * sh /usr/SOAPLOG.sh >/dev/null 2>&1
EOF
