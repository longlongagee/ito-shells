#!/bin/bash
test `netstat -an |grep  -c CLOSE_WAIT` -gt 3000 && /etc/init.d/php-fpm restart && echo '113 close wait 3000' | mail -s 'php error' xujingrui@richstonedt.com
