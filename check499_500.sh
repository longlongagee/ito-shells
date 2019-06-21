#!/usr/bash

sum499=`cat /usr/local/server/nginx/logs/host.access.log |awk '{print $9}' |grep -c 499`
sum500=`cat /usr/local/server/nginx/logs/host.access.log |awk '{print $9}' |grep -c 500`


if [ $sum499 -gt 0 ];then
#    echo "ToolBar RTB: ERROR CONNECTION" |mailx -s 'ToolBar 邮件报警: --- RTB --- : ERROR CONNECTION' wushaolong@richstonedt.com panzhihui@richstonedt.com caihancheng@richstonedt.com xieyuzheng@richstonedt.com   liangyayong@richstonedt.com lihuijun@hantele.com zhengsuhong@richstonedt.com  lanwengang@richstonedt.com
    echo "ToolBar RTB: ERROR 499 sum =" $499sum |mailx -s 'ToolBar 邮件报警: RTB: ERROR CONNECTION' wushaolong@richstonedt.com
fi
if [ $sum500 -gt 0 ];then
#    echo "ToolBar RTB: ERROR CONNECTION" |mailx -s 'ToolBar 邮件报警: --- RTB --- : ERROR CONNECTION' wushaolong@richstonedt.com panzhihui@richstonedt.com caihancheng@richstonedt.com xieyuzheng@richstonedt.com   liangyayong@richstonedt.com lihuijun@hantele.com zhengsuhong@richstonedt.com  lanwengang@richstonedt.com
    echo "ToolBar RTB: ERROR CONNECTION" |mailx -s 'ToolBar 邮件报警: RTB: ERROR CONNECTION' wushaolong@richstonedt.com
fi
