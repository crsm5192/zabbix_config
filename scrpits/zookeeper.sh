#!/bin/bash
#CMDLINE={{pl_zabbix_home}}/zabbix/scripts/cmdline-jmxclient-0.10.3.jar
CMDLINE=/data/monitor/zabbix/scripts/cmdline-jmxclient-0.10.3.jar
#JDK={{pl_zabbix_home}}/zabbix/jdk{{pl_jdk_version}}
JDK=/data/monitor/zabbix/jdk1.8.0_191
#JMX_USER={{pl_zookeeper_jmx_user}}
JMX_USER=-
#JMX_PWD={{pl_zookeeper_jmx_password}}
JMX_PWD=-
#ZK_SRV={{pl_zookeeper_server}}
ZK_SRV=localhost
#ZK_PORT={{pl_zookeeper_port}}
ZK_PORT=2181
#ZK_JMX_PORT={{pl_zookeeper_jmx_port}}
ZK_JMX_PORT=9998

case $1 in
	zk_pid)
		ps -ef|grep java|grep "org.apache.zookeeper.server.quorum.QuorumPeerMain" |grep -v grep |awk '{print $2}'
	;;
	zk_status)
		echo ruok |nc $ZK_SRV $ZK_PORT
	;;
	zk_status)
		echo ruok |nc $ZK_SRV $ZK_PORT
	;;
	#运行时间
	Uptime)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${ZK_SRV}:${ZK_JMX_PORT} "java.lang:type=Runtime" "Uptime" &> /tmp/zabbix.zookeeper.Uptime.log
		awk '{print $6}' /tmp/zabbix.zookeeper.Uptime.log
	;;
	#JVM线程
	Threading)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${ZK_SRV}:${ZK_JMX_PORT}  "java.lang:type=Threading" "$2" &> /tmp/zabbix.zookeeper.Threading.log
		awk '{print $6}' /tmp/zabbix.zookeeper.Threading.log
	;;
	#JVM内存
	Memory)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${ZK_SRV}:${ZK_JMX_PORT}  "java.lang:type=Memory" "$2" &> /tmp/zabbix.zookeeper.Memory.log
		grep $3 /tmp/zabbix.zookeeper.Memory.log|awk '{print $2}'
	;;
	#暂挂对象
	ObjectPendingFinalizationCount)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${ZK_SRV}:${ZK_JMX_PORT}  "java.lang:type=Memory" "ObjectPendingFinalizationCount" &> /tmp/zabbix.zookeeper.ObjectPendingFinalizationCount.log
		awk '{print $6}' /tmp/zabbix.zookeeper.ObjectPendingFinalizationCount.log
	;;
	#缓存
	CodeCache)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${ZK_SRV}:${ZK_JMX_PORT} "java.lang:name=Code Cache,type=MemoryPool" "Usage" &> /tmp/zabbix.zookeeper.CodeCache.log
		grep $2 /tmp/zabbix.zookeeper.CodeCache.log|awk '{print $2}'
	;;
	*)
		echo mntr |nc $ZK_SRV $ZK_PORT |grep $1 |awk '{print $2}'
	;;
esac
exit 0



