#!/usr/bin/env bash
#@author:shao long 
#@file: 
#@time: 2018/05/31 
#@Description:

#!/bin/bash

KFILE=backup-2018_05_28.zip
ftp -i -n <<FTP
open 192.168.6.18
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