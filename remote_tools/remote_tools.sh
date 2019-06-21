#!/bin/bash
#201712 by wusl
#v1.1 更新 目前只使用root账号
#v1.2 更新 可选择用户，免密增加逻辑检查
#v2.0 20180802 更新加入expect

menu(){
echo -ne "
=====SELECT TOOL======
||\033[42;1m 1.scp file       \033[0m||
||\033[42;1m 2.remote command \033[0m||
||\033[42;1m 3.ssh 免密       \033[0m||
||\033[42;1m 其他键退出       \033[0m||
=====================
"
}

switch(){
while true
do
menu
read -p 'please input a number:' _num
case "$_num" in
	1)
		doScp
		;;
	2)	
		doCommand
		;;
	3)
		sshKeygen
		;;
	*)
		break
	esac
done

}

doScp(){
read -p 'usage:<本地路径/文件><远程路径/文件><ip列表>:' _spwd _dpwd _hostlist
if [[ "$_spwd" != "" ]] && [[ "$_dpwd" != "" ]] && [[ "$_hostlist" != "" ]]; then
	echo " start-------"
else
	doScp
fi
#stty -echo              
#read -p "Please enter target hosts' passwd of $1:" passwd
#stty echo

for ip in `cat ${_hostlist}`
do
        echo ${_spwd}
        if [[ -z ${_spwd} ]]; then    #z为空
        echo "Not find command"
        break
        else
        echo "------- $ip ----------"
        scp -Cpr ${ip}:${_dpwd} ${_spwd}
        # scp -Cpr $_spwd $ip:$_dpwd
			[[ $? != 0 ]] || echo "---------- scp success! ---------"
        fi
done
}

read -p "usage: "

doCommand(){
read -p "输入脚本文件 : " _command
#read -p "输入ip列表 : " _hostlist
#read -p "输入密码 : " _passwd

_hostlist=list
_passwd=hantele123

if [[ ! -f "$_command" ]];then echo "ERROR:Not find command";exit 2; fi
for ip in `cat $_hostlist`
do
    echo -e "\033[1;42;1m 执行ip： $ip \033[0m"
#	ssh $ip -l root "`cat $_command`"
	/usr/bin/expect <<EOF
set time 10
spawn ssh $ip -l root "`cat ${_command}`"
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "${_passwd}\r" }
}
expect eof
EOF

	[ $? != 0 ] && echo -e "\033[1;41;32m WARNING：COMMAND ERROR  \033[0m"
	# sleep 2
done
}

sshKeygen()
{
#免密脚本2.0
read -p "输入ip列表 : " _hostlist
read -p "要免密的用户：" _user
read -p "密码：" _passwd
if [[ "$_hostlist" != "" ]] && [[ "$_user" != "" ]]; then
	echo " start-------"
else
	echo -e "\033[1;41;32m WARNING：ERROR USAGE \033[0m"
	sshKeygen
fi

for ipaddr in `cat $_hostlist`
do
	if [[ $_user != "root" ]];then path=home/${_user}; else path=root; fi

	if [[ -e /$path/.ssh/id_rsa.pub ]];then
		grep $HOSTNAME ~/.ssh/id_rsa.pub 
		if (( $? == 0));then
		    echo 0
			use_expect $_user $ipaddr $_passwd $path
		else
		    echo 1
			ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa 
			echo 2
			use_expect $_user $ipaddr $_passwd $path
		fi
	else
	    echo 3
		ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa  >/dev/null 2>&1
		use_expect $_user $ipaddr $_passwd $path
	fi
done

}


use_expect()
{
/usr/bin/expect <<EOF
set time 10
spawn ssh-copy-id -i /$4/.ssh/id_rsa.pub $1@$2
expect {
"*yes/no" { send "yes\r"; exp_continue }
"*password:" { send "$3\r" }
}
expect eof
EOF
}

switch

