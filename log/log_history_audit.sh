HISTSIZE=2000
HISTTIMEFORMAT="%Y/%m/%d %T ";export HISTTIMEFORMAT
export HISTORY_FILE=/var/log/audit.log
export PROMPT_COMMAND='{ thisHistID=`history 1|awk "{print \\$1}"`;lastCommand=`history 1| awk "{\\$1=\"\" ;print}"`;user=`id -un`;whoStr=(`who -u am i`);realUser=${whoStr[0]};logMonth=${whoStr[2]};logDay=${whoStr[3]};logTime=${whoStr[4]};pid=${whoStr[6]};ip=${whoStr[7]};if [ ${thisHistID}x != ${lastHistID}x ];then echo -E `date "+%Y/%m/%d %H:%M:%S"` $user\($realUser\)@$ip[PID:$pid][LOGIN:$logMonth $logDay $logTime] --- $lastCommand ;lastHistID=$thisHistID;fi; } >> $HISTORY_FILE'
