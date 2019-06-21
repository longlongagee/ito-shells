keepalive + nginx + tomcat
https://www.cnblogs.com/sayou/p/3711918.html
https://www.cnblogs.com/liwei0526vip/p/6370103.html
https://www.cnblogs.com/youzhibing/p/7327342.html

==============================Nginx==================================
wget http://nginx.org/download/nginx-1.10.3.tar.gz
wget http://nginx.org/download/nginx-1.13.8.tar.gz

vim src/core/nginx.h
【隐藏版本】
#define nginx_version      1013008
#define NGINX_VERSION      "1.13.8"
#define NGINX_VER          "nginx/" NGINX_VERSION

#ifdef NGX_BUILD
#define NGINX_VER_BUILD    NGINX_VER " (" NGX_BUILD ")"
#else
#define NGINX_VER_BUILD    NGINX_VER
#endif

#define NGINX_VAR          "NGINX"
#define NGX_OLDPID_EXT     ".oldbin"


#endif /* _NGINX_H_INCLUDED_ */

yum install -y pcre-devel openssl-devel
#./configure  --user=www --group=www   --with-http_ssl_module
1:
./configure \
--user=nginx \
--group=nginx \
--prefix=/usr/local/nginx \
--sbin-path=/usr/local/nginx/nginx \
--conf-path=/usr/local/nginx/nginx.conf \
--pid-path=/usr/local/nginx/nginx.pid \
--with-http_stub_status_module \
--with-http_ssl_module 
2:
./configure \
--user=nginx \
--group=nginx \
--prefix=/etc/nginx \
--sbin-path=/etc/nginx/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/etc/nginx/nginx.pid \
--with-http_stub_status_module \
--with-http_ssl_module 
3
./configure \
--user=www \
--group=www \
--prefix=/usr/local/server/nginx1.13.8 \
--sbin-path=/usr/local/server/nginx1.13.8/sbin/nginx \
--conf-path=/usr/local/server/nginx1.13.8/conf/nginx.conf \
--pid-path=/usr/local/server/nginx1.13.8/conf/logs/nginx.pid \
--with-http_stub_status_module \
--with-http_ssl_module 


./configure --prefix=/usr/local/server/nginx --with-http_ssl_module

make && make install 

kill -USR2 `cat /usr/local/server/nginx/logs/nginx.pid`
kill -WINCH `cat /usr/local/server/nginx/logs/nginx.pid.oldbin`
kill -QUIT `cat /usr/local/server/nginx/logs/nginx.pid.oldbin`

# 4.修改完nginx配置文件后，使用平滑重启命令，重启nginx：
#[root@localhost ]# killall -s HUP nginx
#5.浏览器验证，下载pdf文件
#注：pdf文件的属主与属组必须和文件属性一样。目录权限为755，文件权限为644，否则下载时报错

cat /usr/local/nginx/conf/nginx.conf

user www www;
worker_processes 8; #设置值和CPU核心数一致
error_log /usr/local/nginx/logs/nginx_error.log crit; #日志位置和日志级别
pid /usr/local/nginx/nginx.pid;
#Specifies the value for maximum file descriptors that can be opened by this process.
worker_rlimit_nofile 65535;
events
{
  use epoll;
  worker_connections 65535;
}
http
{
  server_tokens off;	
  include mime.types;
  default_type application/octet-stream;
  log_format main  '$remote_addr - $remote_user [$time_local] "$request" '
               '$status $body_bytes_sent "$http_referer" '
               '"$http_user_agent" $http_x_forwarded_for';
  
#charset gb2312;
     
  server_names_hash_bucket_size 128;
  client_header_buffer_size 32k;
  large_client_header_buffers 4 32k;
  client_max_body_size 8m;
  client_header_buffer_size 4K;
  open_file_cache max=100000 inactive=20s;
  open_file_cache_min_uses 1;
  open_file_cache_valid 30s;
  
  sendfile on;
  tcp_nopush on;
  keepalive_timeout 60;
  tcp_nodelay on;
  fastcgi_connect_timeout 300;
  fastcgi_send_timeout 300;
  fastcgi_read_timeout 300;
  fastcgi_buffer_size 64k;
  fastcgi_buffers 4 64k;
  fastcgi_busy_buffers_size 128k;
  fastcgi_temp_file_write_size 128k;
  gzip on; 
  gzip_min_length 1k;
  gzip_buffers 4 16k;
  gzip_http_version 1.0;
  gzip_comp_level 2;
  gzip_types text/plain application/x-javascript text/css application/xml;
  gzip_vary on;
 
  #limit_zone crawler $binary_remote_addr 10m;
 #下面是server虚拟主机的配置
 server
  {
    listen 80;#监听端口
    server_name localhost;#域名
    index index.html index.htm index.php;
    root /var/www/html;#站点目录
    access_log  logs/host.access.log  main;
	location ~ .*\.(php|php5)?$
    {
      #fastcgi_pass unix:/tmp/php-cgi.sock;
      fastcgi_pass 127.0.0.1:9000;
      fastcgi_index index.php;
      include fastcgi.conf;
    }
    location ~ .*\.(gif|jpg|jpeg|png|bmp|swf|ico)$
    {
      expires 30d;
  # access_log off;
    }
    location ~ .*\.(js|css)?$
    {
      expires 15d;
   # access_log off;
    }
    
  }

}

============================= keepalive =================================

wget http://www.keepalived.org/software/keepalived-1.2.24.tar.gz

 yum install gcc openssl openssl-devel ipvsadm libnl-devel glibc
# yum install libnfnetlink-devel
yum install  gcc openssl-devel popt-devel ipvsadm 
不然会编译不成功的。然后：

./configure --prefix=/usr/local//keepalived/
make && make install 
cp /usr/local/keepalived/etc/sysconfig/keepalived /etc/sysconfig/
cp /usr/local//keepalived/etc/rc.d/init.d/keepalived /etc/init.d/
chmod +x /etc/init.d/keepalived
chkconfig keepalived on
mkdir /etc/keepalived
cp /usr/local/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/
ln -s /usr/local/keepalived/sbin/keepalived /usr/sbin/


vim keepalived.conf
! Configuration File for keepalived

global_defs {
   notification_email {
}
   router_id LVS_DEVEL
}

vrrp_script chk_nginx {
    script "/etc/keepalived/check_nginx.sh"
    interval 2
    weight 2
}

vrrp_instance VI_1 {
    state MASTER
    interface eth0
    virtual_router_id 51
    priority 100
    advert_int 1
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    virtual_ipaddress {
        192.168.184.131
    }
    track_script {
        chk_nginx
    }

}

virtual_server 192.168.184.131 80 {
    delay_loop 6             //延迟轮询时间（单位秒）;
    lb_algo rr               //后端调度算法（load balancing algorithm）;
    lb_kind DR               //LVS工作模式NAT/DR/TUN;
#    nat_mask 255.255.255.0
    persistence_timeout 0   //会话保持时间,秒为单位,即同一个用户在50秒内被分配到同一个后端realserver;
    protocol TCP             //健康检查用的是TCP还是UDP;

    real_server 192.168.184.128 80 {
        weight 1
        TCP_CHECK {
            connect_timeout 10
            nb_get_retry 3
            delay_before_retry 3
            connect_port 80
        }
    }
    real_server 192.168.184.129 80 {
        weight 1
        TCP_CHECK {
            connect_timeout 10
            nb_get_retry 3
            delay_before_retry 3
            connect_port 80
        }
    }
#    sorry_server 127.0.0.1 80
}


【备机keepalived配置】
global_defs {
    notification_email {
        997914490@qq.com
    }
    notification_email_from sns-lvs@gmail.com
    smtp_server smtp.hysec.com
    smtp_connection_timeout 30
    router_id nginx_backup              # 设置nginx backup的id，在一个网络应该是唯一的
}
vrrp_script chk_http_port {
    script "/usr/local/src/check_nginx_pid.sh"
    interval 2                          #（检测脚本执行的间隔）
    weight 2
}
vrrp_instance VI_1 {
    state BACKUP                        # 指定keepalived的角色，MASTER为主，BACKUP为备
    interface eth0                      # 当前进行vrrp通讯的网络接口卡(当前centos的网卡)
    virtual_router_id 66                # 虚拟路由编号，主从要一直
    priority 99                         # 优先级，数值越大，获取处理请求的优先级越高
    advert_int 1                        # 检查间隔，默认为1s(vrrp组播周期秒数)
    authentication {
        auth_type PASS
        auth_pass 1111
    }
    track_script {
        chk_http_port                   #（调用检测脚本）
    }
    virtual_ipaddress {
        192.168.0.200                   # 定义虚拟ip(VIP)，可多设，每行一个
    }
}





touch /etc/keepalived/check_nginx.sh
#!/bin/bash
A=`ps -C nginx --no-header |wc -l`
if [ $A -eq 0 ];then
    /usr/local/nginx/sbin/nginx                #重启nginx
    if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then    #nginx重启失败
        exit 1
    else
        exit 0
    fi
else
    exit 0
fi


=======================================LVS========================================
touch /etc/keepalived/realserver.sh
vim /etc/keepalived/realserver.sh
#!/bin/bash
#description: Config realserver

VIP=192.168.1.110
#read -p "VIP is :" VIP
chmod +x /etc/rc.d/init.d/functions
/etc/rc.d/init.d/functions
case "$1" in
start)
       /sbin/ifconfig lo:0 $VIP netmask 255.255.255.255 broadcast $VIP
       /sbin/route add -host $VIP dev lo:0
       echo "1" >/proc/sys/net/ipv4/conf/lo/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/lo/arp_announce
       echo "1" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "2" >/proc/sys/net/ipv4/conf/all/arp_announce
       sysctl -p >/dev/null 2>&1
       echo "RealServer Start OK"
       ;;
stop)
       /sbin/ifconfig lo:0 down
       /sbin/route del $VIP >/dev/null 2>&1
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/lo/arp_announce
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_ignore
       echo "0" >/proc/sys/net/ipv4/conf/all/arp_announce
       echo "RealServer Stoped"
       ;;
status)
       islothere=`/sbin/ifconfig lo:0 | grep $VIP`   
       isrothere=`netstat -rn | grep "lo:0" | grep $VIP`   
       if [ ! "$islothere" -o ! "isrothere" ];then   
           echo "LVS-DR real server Stopped."   
       else   
           echo "LVS-DR real server Running."   
       fi   
	   ;;

*)
       echo "Usage: $0 {start|stop}"
       exit 1
esac



echo 1 > /proc/sys/net/ipv4/ip_forward && sysctl -p

永久打开方法：修改/etc/sysctl.conf文件，net.ipv4.ip_forward = 1，然后执行sysctl -p


nginx 修改 url

server
{
    listen 80;
    server_name _;
location / {
deny all;

}

location /long/shao {
        alias /var/www/html;
        index index.php;
    }
}

		location = / {
        deny all;
        }
        location  /login/ {
        proxy_pass http://web/login/;
        proxy_redirect http://web/ /super/set/;
        }
        location /toolbar {
        proxy_pass http://172.16.30.17:5000/config_php/dive_data;

        }
        location /logout/ {
        proxy_pass http://web/logout/;
        proxy_redirect http://web/ /super/set/;
        }
#       location ~ ^/[A-Za-z]+/$ {
        location  /super/set/ {
        proxy_pass http://web/;
        proxy_redirect http://web/ /super/set/;
        }
        location / {
                proxy_pass http://web;
       }
        location /static {
                alias /usr/local/server/nginx/html/static;
        }
		
		location ~ .*\.(jsp|do|action|php|asp|rar|zip|txt|html|htm|shtml)$ {
             proxy_pass http://127.0.0.1:8866;
         }

server_tokens off;



user  nginx;
worker_processes  8;
worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000 10000000;
#error_log      /home/data/nginx/error.log      warn;
#error_log      /home/data/nginx/error.log      info;
error_log       /home/data/nginx/error.log      crit;
pid        /var/run/nginx.pid;

worker_rlimit_nofile 100000;

events {
    use epoll;
    worker_connections  65536;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /home/data/nginx/access.log  main;

    client_max_body_size    1000m;
    client_header_buffer_size 4K;
    open_file_cache max=100000 inactive=20s;
    open_file_cache_min_uses 1;
    open_file_cache_valid 30s;

    sendfile        on;
    #tcp_nopush     on;
    tcp_nopush on;
    tcp_nodelay on;

    keepalive_timeout  65;

    gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
 
 
upstream apicontroller {
  server 192.168.213.137:8090;
  server 192.168.213.137:8091;
  server 192.168.213.134:8093;
}
server {
    listen       50004;
    server_name  localhost;



    access_log  /home/data/nginx/access50004.log  main;
    error_log       /home/data/nginx/error50004.log      info;


    location / {
            proxy_pass http://apicontroller;
            proxy_set_header   Host             $http_host;
            proxy_set_header   X-Real-IP        $remote_addr;
            proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header   X-Up-Calling-Line-Id $http_x_up_calling_line_id;
    }
}




####性能测试
yum install httpd-tools
================================================================================
Installing:
 httpd-tools      x86_64      2.2.15-60.el6.centos.6         updates       80 k
Installing for dependencies:
 apr              x86_64      1.3.9-5.el6_9.1                updates      124 k
 apr-util         x86_64      1.3.9-3.el6_0.1                base          87 k


