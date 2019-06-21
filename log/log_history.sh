#!/bin/bash
#script需要使用source command_log.sh运行
#设置command history记录

cat >> /etc/profile <<"EOF"
HISTFILESIZE=2000
HISTSIZE=2000
HISTTIMEFORMAT="%Y%m%d-%H%M%S: "
export HISTTIMEFORMAT
export PROMPT_COMMAND='{ command=$(history 1 | { read x y; echo $y; });logger -p local1.notice -t bash -i "user=$USER,ppid=$PPID,from=$SSH_CLIENT,pwd=$PWD,command:$command"; }'
EOF

#设置/etc/profile文件生效
source /etc/profile

#增加一个本地的日志策略local.notice，并设置该消息不通过messages输出
cat >> /etc/rsyslog.conf <<EOF
local1.notice /var/log/command_logs/command.log
EOF
sed -i 's/\*\.info;mail\.none;authpriv\.none;cron\.none/\*\.info;mail\.none;authpriv\.none;cron\.none;local1\.none/g' /etc/rsyslog.conf


#修改rsyslog时间格式
# sed -i 's/$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat/#$ActionFileDefaultTemplate RSYSLOG_TraditionalFileFormat/g' /etc/rsyslog.conf
# cat >>/etc/rsyslog.conf<<"EOF"
# $template myformat,"%$NOW% %TIMESTAMP:8:15% %hostname% %syslogtag% %msg%\n"
# $ActionFileDefaultTemplate myformat
# EOF

#配置command.log
cat >> /etc/logrotate.d/local1 <<EOF
/var/log/command.log{
	daily
	rotate 90
	olddir /var/log/command_logs/
	create 0600 root root
	postrotate
		/usr/bin/killall -HUP rsyslogd
	endscript
}
EOF

mkdir -p /var/log/command_logs

#重启日志服务	
service rsyslog restart
