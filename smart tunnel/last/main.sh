#!/bin/bash



dir='/usr/local/shell/last'
old='/usr/local/shell/last/old'
new='/usr/local/shell/last/new'
source /etc/profile



utmpdump /var/log/wtmp > $old
sleep 1
cat $old |grep 10.201.38 > $new
sleep 1
utmpdump -r $new  > /var/log/wtmp




 