#!/usr/bin/env bash
#@author:shao long 
#@file: 
#@time: 2018/05/31 
#@Description:


KFILE=2018-5-31.zip
ftp -i -n <<FTP
open 192.168.6.18
user fs_server1 hantele123
binary
passive
cd jira
lcd /home/data/application-data/jira/export
prompt
put $KFILE
close
quit
FTP