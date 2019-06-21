#! /bin/sh
# Failover command for streaming replication.
# This script assumes that DB node 0 is primary, and 1 is standby.
#
# If standby goes down, do nothing. If primary goes down, create a
# trigger file so that standby takes over primary node.
#
# Arguments: $1: failed node id. $2: new master hostname. $3: path to
new_master=$1 
trigger_command="$PGHOME/bin/pg_ctl promote -D $PGDATA" 

# Prompte standby database. 
/usr/bin/ssh -T $new_master $trigger_command 

exit 0;
