\#!/bin/bash
pd=`cat pd.txt`
> wangka.txt
/usr/bin/expect <<EOF  &>> wangka.txt
set timeout 1
spawn ssh netscreen@172.16.20.1
expect "password:"
send "${pd}\r"
expect "ZNGD-FW1(M)-> "
send "get counter statistics interface ethernet2/1\r"
expect "ZNGD-FW1(M)-> "
send "exit\r"
#interact
EOF
cat wangka.txt | grep early | cut -d '|' -f 1,2
cat wangka.txt | grep tcp | cut -d '|' -f 1,2
