#! /bin/sh 
# Failover command for streaming replication. 
# Arguments: $1: new master hostname. 

new_master=$1 
trigger_command="$PGHOME/bin/pg_ctl promote -D $PGDATA" 

# Prompte standby database. 
/usr/bin/ssh -T $new_master $trigger_command 

exit 0;
