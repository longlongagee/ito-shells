#!/bin/sh
[ $# -ne 4 ] && { 
 echo "Usage: sh 96c221be-6ab2-ef53-1589-fe16877914d5.sh IP  数据库用户名 端口号 数据库密码";
 exit 1;
}

pathname=`pwd`


perl $pathname/96c221be-6ab2-ef53-1589-fe16877914d5.pl "${1}" "${2}" "${3}" "${4}"
