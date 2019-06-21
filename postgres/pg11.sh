#!/usr/bin/env bash
#@author:shao long 
#@file: ${NAME}
#@time: 2019/01/04 
#@Description:
#@version: 1.0
# https://blog.csdn.net/ChenHui_Felix/article/details/83276585

groupadd postgres
useradd -g postgres postgres
passwd postgres

mkdir -p /home/data/pgdata/pgsql /home/data/pgdata/pgtbs /home/data/archivelog /backups
chmod -R 775 /home/data
chown -R postgres:postgres /home/data

yum install -y gcc gcc-c++ epel-release llvm5.0 llvm5.0-devel clang libicu-devel perl-ExtUtils-Embed zlib-devel openssl openssl-devel pam-devel libxml2-devel libxslt-devel openldap-devel systemd-devel tcl-devel python-devel

yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-centos11-11-2.noarch.rpm
yum install -y postgresql11*

vim /usr/lib/systemd/system/postgresql-11.service
#添加内容：
[Unit]
Description=PostgreSQL 11 database server
Documentation=https://www.postgresql.org/docs/11/static/
After=syslog.target
After=network.target
 
[Service]
Type=notify
User=postgres
Group=postgres
Environment=PGDATA=/home/data/pgdata/pgsql/
OOMScoreAdjust=-1000
Environment=PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj
Environment=PG_OOM_ADJUST_VALUE=0
ExecStart=/usr/pgsql-11/bin/postmaster -D ${PGDATA}
ExecReload=/bin/kill -HUP $MAINPID
KillMode=mixed
KillSignal=SIGINT
TimeoutSec=0
 
[Install]
WantedBy=multi-user.target


vi /home/postgres/.bash_profile
#添加内容：
export PGPORT=25432
export PGDATA=/home/data/pgdata/pgsql
export PGHOME=/usr/pgsql-11
export MANPATH=$PGHOME/share/man:$MANPATH
export LANG=en_US.UTF-8
export DATE='date +"%Y%m%d%H%M"'
export LD_LIBRARY_PATH=$PGHOME/lib:$LD_LIBRARY_PATH
export PGHOST=$PGDATA
export PGUSER=postgres
export PGDATABASE=postgres
export PATH=$PGHOME/bin:$PATH

cd $PGDATA
mv pg_hba.conf{,.bak}
cat << EOF >> pg_hba.conf
local all all trust
host replication repl 0.0.0.0/0 md5  # 流复制
host all postgres 0.0.0.0/0 reject # 拒绝超级用户从网络登录
host all all 0.0.0.0/0 md5  # 其他用户登陆
EOF


vim postgresql.conf
#修改内容:
listen_addresses = '*'
unix_socket_directories = '.'
port = 25432


systemctl enable postgresql-11.service
systemctl start postgresql-11.service

