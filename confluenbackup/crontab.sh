#!/usr/bin/env bash
#@author:shao long 
#@file: 
#@time: 2018/05/31 
#@Description:

/root/shell/backup_confluence_2.sh
#!/bin/bash
DATE=$(date +%Y_%m_%d)
KFILE=backup-$DATE.zip
ftp -i -n <<FTP
open 192.168.6.7
user fs_server1 hantele123
binary
passive
cd /System-Backup/confluence/
lcd /home/data/application-data/confluence/backups/
prompt
put $KFILE
close
quit
FTP

#########################################
/root/shell/backup_jira_2.sh
#!/bin/bash
DATE=$(date +%Y_%m_%d)
KFILE=backup-$DATE.tar.gz
ftp -i -n <<FTP
open 192.168.6.7
user fs_server1 hantele123
binary
passive
cd /System-Backup/jira/
lcd /root/jira_backup/
prompt
put $KFILE
close
quit
FTP


#######################################
/root/shell/jira_backup.sh

#!/bin/bash
DATE=$(date +%Y_%m_%d)
cd /home/data/application-data/jira/export/
tar -zcvf /root/jira_backup/backup-$DATE.tar.gz *

sleep 5
cd /home/data/application-data/jira/data/
tar -zcvf /root/jira_backup/backup_att-$DATE.tar.gz *


############################################
/root/shell/backup_del.sh
#!/bin/bash

cd /root/jira_backup
rm -rf *


############################################
/root/shell/clean_old_data.sh
#!/bin/bash
# 只保留20天数据
find /home/data/application-data/confluence/backups/ -mtime +20 -type f |xargs rm -f

##########################################
/root/shell/restart_jira.sh
#!/bin/bash
# stop jira service
/etc/init.d/jira stop
# sleep 30s
sleep 30
# start jira service
/etc/init.d/jira start


