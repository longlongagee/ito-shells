#!/bin/sh
[ $# -ne 4 ] && { 
 echo "Usage: sh 96c221be-6ab2-ef53-1589-fe16877914a8.sh IP  SU用户名 SU用户密码 配置文件所在目录(eg:/usr/local/apache-tomcat-6.0.37/conf)";
 exit 1;
}

pathname=`pwd`


echo '#!/bin/awk -f' > /tmp/awkxmlfilter
echo 'BEGIN{flag=0;} { while(getline) {' >> /tmp/awkxmlfilter
echo 'if (index($0,"<!--")|| flag==1) {' >> /tmp/awkxmlfilter
echo 'if(index($0,"HTTP") && index($0,"-->")) { ' >> /tmp/awkxmlfilter
echo 'print $0;continue}flag=1;if (index($0,"-->")) {' >> /tmp/awkxmlfilter
echo 'flag=0} print "";continue}print $0}}' >> /tmp/awkxmlfilter
echo '#!/bin/awk -f' > /tmp/c213
echo 'BEGIN{flag=0;flag2=0;' >> /tmp/c213
echo 'rexStr="(minSpareThreads|acceptCount|maxThreads|maxSpareThreads)"}' >> /tmp/c213
echo '{ x=$0;' >> /tmp/c213
echo 'if(match($0,".*Define.*HTTP.*Connector.*")>0 || (flag==1 && flag2 < 2))' >> /tmp/c213
echo '{ flag = 1; while (match(x,rexStr)>0) { ' >> /tmp/c213
echo 'key=substr(x,RSTART,RLENGTH);' >> /tmp/c213
echo 'x = substr(x,RSTART+RLENGTH+1);' >> /tmp/c213
echo 'split(x,b,"\""); a[key]=b[2]; }' >> /tmp/c213
echo 'if(index($0,">")) { flag2++; } } }' >> /tmp/c213
echo 'END{if(a["maxThreads"] !="" || a["minSpareThreads"] !="" ||' >> /tmp/c213
echo 'a["maxSpareThreads"] !="" || a["acceptCount"] !="") {' >> /tmp/c213
echo 'print a["maxThreads"],a["minSpareThreads"],' >> /tmp/c213
echo 'a["maxSpareThreads"],a["acceptCount"] }}' >> /tmp/c213
echo '#!/bin/awk -f' > /tmp/port956
echo 'BEGIN{flag=0}{while(getline){' >> /tmp/port956
echo 'if(index($0,"<!--")){ ' >> /tmp/port956
echo 'getline;if(index($0,"Connector")){flag=1}}' >> /tmp/port956
echo 'if(index($0,"port") && flag==1){flag=0;print $0}}}' >> /tmp/port956
cd "${4}"
perl $pathname/96c221be-6ab2-ef53-1589-fe16877914a8.pl "${1}" "${2}" "${3}" "${4}"
