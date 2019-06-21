#!/bin/sh
[ $# -ne 4 ] && { 
 echo "Usage: sh 96c221be-6ab2-ef53-1589-fe16877914a1.sh IP  SU用户名 SU密码 Apache根目录";
 exit 1;
}

pathname=`pwd`


ifbash=$(echo $0 | grep bash | wc -l)
[ $ifbash -eq 0 ] || bash
cat ""${4}"/conf/httpd.conf" | sed '/^\s*#/d' > /tmp/infile
perl $pathname/96c221be-6ab2-ef53-1589-fe16877914a1.pl "${1}" "${2}" "${3}" "${4}"
