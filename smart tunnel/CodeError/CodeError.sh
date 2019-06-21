#!/bin/bash
export LANG='zh_CN.UTF-8'

error_dir='/usr/local/shell/CodeError'
#下面的$14是nginx log 倒数第4列
cat /usr/local/server/nginx/logs/host.access.log | awk  -F  '\t' '{print $14}' |sort |uniq -c | sort -rn > $error_dir/codelog
cat $error_dir/codelog  > $error_dir/maillog
sed -i 's#-#- ======>>非错误代码#g' $error_dir/maillog
sed -i 's/usedomain/usedomain ======>>非错误代码/g' $error_dir/maillog
sed -i 's/txnewspic/txnewspic ======>>非错误代码/g' $error_dir/maillog
sed -i 's/duplicaterequest/duplicaterequest ======>>非错误代码/g' $error_dir/maillog
sed -i 's/nooriurl/nooriurl ======>>非错误代码/g' $error_dir/maillog
sed -i 's/headrequest/headrequest ======>>非错误代码/g' $error_dir/maillog
sed -i 's/10086pic/10086pic ======>>非错误代码/g' $error_dir/maillog
sed -i 's/ifengnewspic/ifengnewspic ======>>非错误代码/g' $error_dir/maillog
sed -i 's/ifentcomment/ifentcomment ======>>非错误代码/g' $error_dir/maillog
sed -i 's/HeAnimal/HeAnimal ======>>非错误代码/g' $error_dir/maillog
sed -i 's/sinanewsillegal1/sinanewsillegal1 ======>>非错误代码/g' $error_dir/maillog
sed -i 's/toutiao_allpic/toutiao_allpic ======>>非错误代码/g' $error_dir/maillog
date +%Y%m%d-%H:%M >> $error_dir/maillog
echo "告警原理:not200的次数是600,其他次数均为200" >> $error_dir/maillog
grep -E "not200|taobaoiphone" $error_dir/codelog  > $error_dir/not200_codelog
#屏蔽sinaappnot200|sinawebnot200
cat $error_dir/not200_codelog |grep -vE "sinaappnot200|sinawebnot200" > $error_dir/not200_codelog
for line in `cat $error_dir/not200_codelog |awk '{print$1}'`
do
        #下面的600是状态阈值数
        if [ $line -ge 600  ];then
		echo "告警的代码 ===>>`cat $error_dir/codelog |grep $line`" >> $error_dir/maillog
        fi
done

#下面是去掉无用的信息
grep -vE "\-|usedomain|txnewspi|duplicaterequest|nooriurl|headrequest|10086pic|not200|ifengnewspic|ifentcomment|taobaoiphone|HeAnimal|sinanewsillegal1|toutiao_allpic|3wbaidu_notbrowser" $error_dir/codelog  > $error_dir/new_codelog
for line in `cat $error_dir/new_codelog |awk '{print$1}'`
do
        #下面的200是状态阈值数
        if [ $line -ge 200  ];then
                echo "告警的代码 ===>>`cat $error_dir/codelog |grep $line`" >> $error_dir/maillog
        fi
done

grep "告警的代码" $error_dir/maillog &> /dev/null
if [ $? -eq 0 ];then
	cat $error_dir/maillog |mail -s '113 code error ' 'panzhihui@richstonedt.com' 'liangyayong@richstonedt.com' 'lihuijun@hantele.com' 'zhengsuhong@richstonedt.com' 'wushaolong@richstonedt.com' 'caihancheng@richstonedt.com' 'xieyuzheng@richstonedt.com' 'dinglun@richstonedt.com' 'lanwengang@richstonedt.com'
fi

