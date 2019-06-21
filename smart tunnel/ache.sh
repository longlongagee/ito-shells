#!/bin/bash


for i in {1..60}
do
	date >> /usr/local/shell/pslog
	ps -rlf >> /usr/local/shell/pslog
	sleep 1
done
