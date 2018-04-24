[12]时间服务器 http://www.linuxidc.com/Linux/2014-07/104371.htm

注释掉 
#restrict default kod nomodify notrap nopeer noquery  
vim /etc/ntpd.conf
restrict default nomodify 
server 182.92.12.11
server  127.127.1.0     #  当服务器与公用的时间服务器失去联系时，就是连不上互联网时，以局域网内的时
fudge   127.127.1.0 stratum 10

service ntpd restart
chkconfig ntpd on

crontab -e
0 */24 * * * /usr/sbin/ntpdate 192.168.8.110 && hwclock -w >/dev/null 2>&1

### 其他命令 ##
0 */24 * * * root /usr/sbin/ntpdate master

ntpstat
ntpq -p

rm -f /etc/localtime
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
ntpdate 182.92.12.11 && hwclock -w 


fsdjfi

asdasdasda
asdasdasdasdasd
asdasd
asdasdasd