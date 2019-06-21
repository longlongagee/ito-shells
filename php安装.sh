1. 首先安装开发软件包：

yum -y groupinstall  "Development Tools"
2. 下载PHP最新稳定版，解压安装包，本示例使用的是PHP 5.6.25
wget http://cn2.php.net/distributions/php-5.6.0.tar.xz
tar -zxvf php-5.6.0.tar.xz -C /usr/local/src/
3. 切换到PHP目录，运行configure：

 ./configure -prefix=/usr/local/php -with-config-file-path=/usr/local/php/etc -with-bz2 -with-curl -enable-ftp -enable-sockets -disable-ipv6 -with-gd -with-jpeg-dir=/usr/local -with-png-dir=/usr/local --with-ldap-with-freetype-dir=/usr/local -enable-gd-native-ttf -with-iconv-dir=/usr/local -enable-mbstring -enable-calendar -with-gettext -with-libxml-dir=/usr/local -with-zlib -with-pdo-mysql=mysqlnd -with-mysqli=mysqlnd --with-ldap -with-mysql=mysqlnd -enable-dom -enable-xml -enable-fpm -with-libdir=lib64 -enable-bcmath
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-inline-optimization --disable-debug --disable-rpath --enable-shared --enable-opcache --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-gettext --enable-mbstring --with-iconv --with-mcrypt --with-mhash --with-openssl --enable-bcmath --enable-soap --with-libxml-dir --with-ldap --enable-pcntl --enable-shmop --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-sockets --with-curl --with-zlib --enable-zip --with-bz2 --with-readline
./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-pdo-mysql=/usr/local/mysql --with-mysqli=/usr/local/mysql/bin/mysql_config --with-mysql-sock=/tmp/mysql.sock --with-pdo-mysql=/usr/local/mysql --with-gd --with-png-dir=/usr/local/libpng --with-jpeg-dir=/usr/local/jpeg --with-freetype-dir=/usr/local/freetype --with-xpm-dir=/usr/ --with-zlib-dir=/usr/local/zlib --with-iconv --enable-libxml --with-ldap --enable-xml --enable-bcmath --enable-shmop --enable-sysvsem --enable-inline-optimization --enable-opcache --enable-mbregex --enable-fpm --enable-mbstring --enable-ftp --enable-gd-native-ttf --with-openssl --enable-pcntl --enable-sockets --with-xmlrpc --enable-zip --enable-soap --without-pear --with-gettext --enable-session --with-mcrypt --with-curl --enable-ctype
参数说明：

""" 安装路径 """
--prefix=/usr/local/php56 \
""" php.ini 配置文件路径 """
--with-config-file-path=/usr/local/php56/etc \
""" 优化选项 """
--enable-inline-optimization \
--disable-debug \
--disable-rpath \
--enable-shared \
""" 启用 opcache，默认为 ZendOptimizer+(ZendOpcache) """
--enable-opcache \
""" FPM """
--enable-fpm \
--with-fpm-user=www \
--with-fpm-group=www \
""" MySQL """
--with-mysql=mysqlnd \
--with-mysqli=mysqlnd \
--with-pdo-mysql=mysqlnd \
""" 国际化与字符编码支持 """
--with-gettext \
--enable-mbstring \
--with-iconv \
""" 加密扩展 """
--with-mcrypt \
--with-mhash \
--with-openssl \
""" 数学扩展 """
--enable-bcmath \
""" Web 服务，soap 依赖 libxml """
--enable-soap \
--with-libxml-dir \
""" 进程，信号及内存 """
--enable-pcntl \
--enable-shmop \
--enable-sysvmsg \
--enable-sysvsem \
--enable-sysvshm \
""" socket & curl """
--enable-sockets \
--with-curl \
""" 压缩与归档 """
--with-zlib \
--enable-zip \
--with-bz2 \
""" GNU Readline 命令行快捷键绑定 """
--with-readline
如果你的 Web Server 使用的 Apache 请添加类似：--with-apxs2=/usr/local/apache-xx/bin/apxs 参数。

关于 mysqlnd 请查看 什么是 PHP 的 MySQL Native 驱动? 或查看 MySQL 官方介绍：MySQL native driver for PHP， 或 Installation on Unix。

PHP 5.6 內建了 phpdbg 交互式调试器，通过 --enable-phpdbg 开启，会在 PREFIX/bin 目录下产生一个 phpdbg 命令，感兴趣的可以试一下。

更多编译参数请使用 ./configure --help 查看。
 
 本文总结了一些常见的configure错误信息和解决这些错误的经验。
1、configure: error: No curses/termcap library found
网上有的说法是：–with-named-curses-libs=/usr/lib/libncursesw.so.5
其实是不对的，虽然能解决configure的错误，但是make的时候会提示错误，正确的做法应该是
centos: yum -y install ncurses-devel
debian: apt-get install libncurses5-dev
2、configure: error: xml2-config not found. Please check your libxml2 installation.
centos: yum -y install libxml2 libxml2-devel
debian: apt-get install libxml2-dev
3、configure: error: Cannot find OpenSSL’s
centos: yum -y install openssl-devel
4、configure: error: libjpeg.(a|so) not found
centos: yum -y install gd
centos: yum -y install gd-devel
debian: apt-get install libjpeg-dev
5、configure: error: libpng.(a|so) not found.
apt-get install libpng12-dev
6、configure: error: cannot find output from lex; giving up
yum -y install flex
7、configure: error: mod_deflate has been requested but can not be built due to prerequisite failures
centos: yum -y install zlib-devel openssl-devel
debian: apt-get install zlib1g-dev
8、configure: error: libxpm.(a|so) not found.
centos: yum -y install libxpm-dev
debian: apt-get install libxpm-dev
9、configure: error: freetype.h not found.
centos: yum install freetype-devel
debian: apt-get install libfreetype6-dev
10、configure: error: …No recognized SSL/TLS toolkit detected
centos: yum -y install libssl-dev
debian: apt-get install libssl-dev
11、Configure: error: Please reinstall the BZip2 distribution
centos: yum install bzip2 bzip2-devel
debian: apt-get install bzip2-devel
12、Configure: error: Please reinstall the libcurl distribution – easy.h should be in /include/curl/
centos: yum install curl curl-devel (For Redhat & Fedora)
# install libcurl4-gnutls-dev (For Ubuntu)
13、Configure: error: Unable to locate gmp.h
centos: yum install gmp-devel
14、Configure: error: Cannot find MySQL header files under /usr. Note that the MySQL client library is not bundled anymore!
yum install mysql-devel (For Redhat & Fedora)
# apt-get install libmysql++-dev (For Ubuntu)
15、Configure: error: Please reinstall the ncurses distribution
Solutions :
centos: yum install ncurses ncurses-devel
16、Checking for unixODBC support… configure: error: ODBC header file ‘/usr/include/sqlext.h’ not found!
Solutions :
centos: yum install unixODBC-devel
17、Configure: error: Cannot find pspell
Solutions :
centos: yum install pspell-devel
18、configure: error: mcrypt.h not found. Please reinstall libmcrypt.
Solutions :
yum install libmcrypt libmcrypt-devel (For Redhat & Fedora)
# apt-get install libmcrypt-dev
19、Configure: error: snmp.h not found. Check your SNMP installation.
Solutions :
yum install net-snmp net-snmp-devel
20、开启LDAP服务还需要
yum -y install openldap-devel openldap-servers openldap-clients
21、configure: error: cannot find output from lex; giving up
centos: yum -y install flex
22、configure: error: mod_deflate has been requested but can not be built due to prerequisite failures
centos: yum -y install zlib-devel openssl-devel
debian: apt-get install zlib1g-dev
 
 
 4. 
make
make install
5. 复制安装包中的php.ini-production到 /usr/local/php/etc/php.ini

cp php.ini-production /usr/local/php/etc/php.ini
cp /usr/local/php/etc/php-fpm.conf.default.conf  php-fpm.conf
6. 测试PHP安装是否成功。

/usr/local/php/sbin/php-fpm -t

7. 测试成功之后启动PHP

cp /usr/local/src/php-5.6.0/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
chmod 755 /etc/init.d/php-fpm
service php-fpm start
 
8. 添加到开机启动

chkconfig php-fpm on
9. 检查是否启动

ps aux |grep php-fpm
netstat -ant |grep 9000

添加 PHP 命令到环境变量

编辑 ~/.bash_profile，将：

PATH=$PATH:$HOME/bin
改为：
PATH=$PATH:$HOME/bin:/usr/local/php/bin
使 PHP 环境变量生效：

source ~/.bash_profile
查看看 PHP 版本

php -v
PHP 5.6.0 (cli) (built: Sep 23 2014 03:44:18) 
Copyright (c) 1997-2014 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2014 Zend Technologies
