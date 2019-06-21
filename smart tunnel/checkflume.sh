#!/bin/bash
PATH=/usr/java/jdk1.7.0_76/bin:/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin

value=`jps |grep -c Application`
#test $value -eq 0 && echo '113 SERVER PORT FLUME ERROR' |mail -s '113 SERVER PORT FLUME ERROR' xujingrui@richstonedt.com zhengsuhong@richstonedt.com




file_dir=/usr/local/shell
#file1=/data/apache-flume-1.6.0-bin/logs/flume.log
file2=/data/apache-flume-1.6.0-bin/logs/run_error.log
hit=1
if [ ! -f $file_dir/flumelog  ];then
#	md5sum $file1 |sed 's/  /,/g' >> $file_dir/flumelog
	md5sum $file2 |sed 's/  /,/g' >> $file_dir/flumelog
fi

#grep `md5sum $file1 |awk '{print$1}'` $file_dir/flumelog &>/dev/null || tail -50  $file1  |mail -s  "113  $file1"   zhengsuhong@richstonedt.com && hit=2
grep `md5sum $file2 |awk '{print$1}'` $file_dir/flumelog &>/dev/null || tail -50  $file2  |mail -s  "113  $file2"   zhengsuhong@richstonedt.com && hit=2

if [ $hit -eq 2 ];then
	>   $file_dir/flumelog
#        md5sum $file1 |sed 's/  /,/g' >> $file_dir/flumelog
        md5sum $file2 |sed 's/  /,/g' >> $file_dir/flumelog

fi

