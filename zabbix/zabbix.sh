psql -h 0.0.0.0 -p 5432 -d zabbix -u zabbix -f create.sql
zcat XX.sql.gz | psql -h 0.0.0.0 -p 5432 -d zabbix -u zabbix
gunzip /usr/share/zabbix-server-pgsql/*.gz
postgres@ub0-1:~$ psql -U zabbix -d zabbix < /usr/share/zabbix-server-pgsql/schema.sql
postgres@ub0-1:~$ psql -U zabbix -d zabbix < /usr/share/zabbix-server-pgsql/images.sql
postgres@ub0-1:~$ psql -U zabbix -d zabbix < /usr/share/zabbix-server-pgsql/data.sql