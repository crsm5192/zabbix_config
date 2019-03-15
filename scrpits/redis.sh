#!/bin/bash
#RDS_PORT={{pl_redis_port}}
RDS_PORT=6379
#RDS_PWD=`cat {{pl_zabbix_home}}/zabbix/scripts/.redis.pwd`
RDS_PWD=`cat /data/monitor/zabbix/scripts/.redis.pwd`
case $1 in
	Redis_Pid)
		ps -ef|grep redis-server|grep -v grep|awk '{print $2}'
	;;
	*)
		sudo redis-cli -a $RDS_PWD -p $RDS_PORT info|grep -w $1|awk -F : '{print $2}'
	;;
esac
exit 0