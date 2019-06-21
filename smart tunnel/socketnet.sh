echo ==========TCP===========
netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
echo
echo ==========UDP===========
netstat -n | awk '/^udp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
