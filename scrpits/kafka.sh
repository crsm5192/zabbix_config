#!/bin/bash
#CMDLINE={{pl_zabbix_home}}/zabbix/scripts/cmdline-jmxclient-0.10.3.jar
CMDLINE=/data/monitor/zabbix/scripts/cmdline-jmxclient-0.10.3.jar
#JDK={{pl_zabbix_home}}/zabbix/jdk{{pl_jdk_version}}
JDK=/data/monitor/zabbix/jdk1.8.0_191
#JMX_USER={{pl_kafka_jmx_user}}
JMX_USER=-
#JMX_PWD={{pl_kafka_jmx_password}}
JMX_PWD=-
#KFK_SRV={{pl_kafka_server}}
KFK_SRV=localhost
#KFK_PORT={{pl_kafka_port}}
KFK_PORT=9092
#KFK_JMX_PORT={{pl_kafka_jmx_port}}
KFK_JMX_PORT=9999

case $1 in
	kfk_pid)
		ps -ef|grep kafka|grep server.properties|grep -v grep|awk '{print $2}'
	;;
	#运行时间
	Uptime)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT} "java.lang:type=Runtime" "Uptime" &> /tmp/zabbix.kafka.Uptime.log
		awk '{print $6}' /tmp/zabbix.kafka.Uptime.log
	;;
	#JVM线程
	Threading)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT}  "java.lang:type=Threading" "$2" &> /tmp/zabbix.kafka.Threading.log
		awk '{print $6}' /tmp/zabbix.kafka.Threading.log
	;;
	#JVM内存
	Memory)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT}  "java.lang:type=Memory" "$2" &> /tmp/zabbix.kafka.Memory.log
		grep $3 /tmp/zabbix.kafka.Memory.log|awk '{print $2}'
	;;
	#暂挂对象
	ObjectPendingFinalizationCount)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT}  "java.lang:type=Memory" "ObjectPendingFinalizationCount" &> /tmp/zabbix.kafka.ObjectPendingFinalizationCount.log
		awk '{print $6}' /tmp/zabbix.kafka.ObjectPendingFinalizationCount.log
	;;
	#缓存
	CodeCache)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT} "java.lang:name=Code Cache,type=MemoryPool" "Usage" &> /tmp/zabbix.kafka.CodeCache.log
		grep $2 /tmp/zabbix.kafka.CodeCache.log|awk '{print $2}'
	;;
	#垃圾回收
	GarbageCollector)
	if [ "$3" == "G1YoungGeneration" ];then
		NAME='G1 Young Generation'
	elif [ "$3" == "G1OldGeneration" ];then
		NAME='G1 Old Generation'
	fi
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT} "java.lang:name=${NAME},type=GarbageCollector" "$2" &> /tmp/zabbix.kafka.GarbageCollector.log
		awk '{print $6}' /tmp/zabbix.kafka.GarbageCollector.log
	;;
	#BrokerTopicMetrics
	BrokerTopicMetrics)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT} "kafka.server:type=BrokerTopicMetrics,name=$3" "$2" &> /tmp/zabbix.kafka.BrokerTopicMetrics.log
		awk '{print $6}' /tmp/zabbix.kafka.BrokerTopicMetrics.log
	;;
	#MaxLag
	MaxLag)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT} "kafka.server:type=ReplicaFetcherManager,name=MaxLag,clientId=Replica" "Value" &> /tmp/zabbix.kafka.MaxLag.log
		awk '{print $6}' /tmp/zabbix.kafka.MaxLag.log
	;;
	ReplicaManager)
		${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${KFK_SRV}:${KFK_JMX_PORT} "kafka.server:type=ReplicaManager,name=$2" "$3" &> /tmp/zabbix.kafka.ReplicaManager.log
		awk '{print $6}' /tmp/zabbix.kafka.ReplicaManager.log
	;;
	*)
		echo mntr |nc $KFK_SRV $KFK_PORT |grep $1 |awk '{print $2}'
	;;
esac
exit 0



