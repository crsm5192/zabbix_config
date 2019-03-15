#!/bin/bash
#MYSQL_PWD=`cat {{pl_zabbix_home}}/zabbix/scripts/.mysql.pwd`
MYSQL_PWD=`cat /data/monitor/zabbix/scripts/.mysql.pwd`


case $1 in
	#事务缓存命中
	Innodb_buffer_read_hit_ratios)
		x=`sudo mysqladmin -uroot -p${MYSQL_PWD} extended-status 2>/dev/null|grep -w 'Innodb_buffer_pool_reads'|awk '{print $4}'`
		y=`sudo mysqladmin -uroot -p${MYSQL_PWD} extended-status 2>/dev/null|grep -w 'Innodb_buffer_pool_read_requests'|awk '{print $4}'`
		echo "scale=2;100-($x/$y)*100" | bc
	;;
	#事务提交量
	Innodb_commit)
		x=`sudo mysqladmin -uroot -p${MYSQL_PWD} extended-status 2>/dev/null|grep -w 'Innodb_buffer_pool_reads'|awk '{print $4}'`
		y=`sudo mysqladmin -uroot -p${MYSQL_PWD} extended-status 2>/dev/null|grep -w 'Innodb_buffer_pool_read_requests'|awk '{print $4}'`
		echo "scale=4;$x+$y" | bc
	;;
	Mysql_Safe_Pid)
		ps -ef|grep mysqld_safe|grep -v grep|awk '{print $2}'
	;;
	Mysql_Pid)
		ps -ef|grep mysql|grep -v grep|grep -v mysqld_safe|grep -v zabbix|awk '{print $2}'	
	;;	
	*)
		sudo mysqladmin -uroot -p${MYSQL_PWD} extended-status 2>/dev/null|grep -w $1|awk '{print $4}'
	;;
esac
exit 0