#!/bin/bash
#CMDLINE={{pl_zabbix_home}}/zabbix/scripts/cmdline-jmxclient-0.10.3.jar
CMDLINE=/data/monitor/zabbix/scripts/cmdline-jmxclient-0.10.3.jar
#JDK={{pl_zabbix_home}}/zabbix/jdk{{pl_jdk_version}}
JDK=/data/monitor/zabbix/jdk1.8.0_191
#JMX_PORT={{pl_tomcat_jmx_port}}
JMX_PORT=10000
#JMX_USER={{pl_tomcat_jmx_user}}
JMX_USER=-
#JMX_PWD={{pl_tomcat_jmx_password}}
JMX_PWD=-
#JMX_HOST={{pl_tomcat_jmx_host}}
JMX_HOST=localhost
VALUE=$2
NAME=$3

#java -jar cmdline-jmxclient-0.10.3.jar -:- localhost:10000
#JVM堆内存
function HeapMemoryUsage {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=Memory" "HeapMemoryUsage" &> /tmp/zabbix.dscore.HeapMemoryUsage.log
	grep ${VALUE} /tmp/zabbix.dscore.HeapMemoryUsage.log|awk '{print $2}'
}
#JVM非堆内存
function NonHeapMemoryUsage {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=Memory" "NonHeapMemoryUsage" &> /tmp/zabbix.dscore.NonHeapMemoryUsage.log
	grep ${VALUE} /tmp/zabbix.dscore.NonHeapMemoryUsage.log|awk '{print $2}'
}
#JVM线程
function Threading {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=Threading" "${VALUE}" &> /tmp/zabbix.dscore.Threading.log
    awk '{print $6}' /tmp/zabbix.dscore.Threading.log
}
#JVM文件
function OperatingSystem {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=OperatingSystem" "${VALUE}" &> /tmp/zabbix.dscore.OperatingSystem.log
    awk '{print $6}' /tmp/zabbix.dscore.OperatingSystem.log
}
#JVM运行时间
function Uptime {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=Runtime" "Uptime" &> /tmp/zabbix.dscore.Uptime.log
    awk '{print $6}' /tmp/zabbix.dscore.Uptime.log
}
#JVM缓存
function CodeCache {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:name=Code Cache,type=MemoryPool" "Usage" &> /tmp/zabbix.dscore.CodeCache.log
    grep ${VALUE} /tmp/zabbix.dscore.CodeCache.log|awk '{print $2}'
}
#JVM类加载
function ClassLoading {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=ClassLoading" "${VALUE}" &> /tmp/zabbix.dscore.ClassLoading.log
    awk '{print $6}' /tmp/zabbix.dscore.ClassLoading.log
}
#JVM暂挂对象
function Memory {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:type=Memory" "${VALUE}" &> /tmp/zabbix.dscore.Memory.log
    awk '{print $6}' /tmp/zabbix.dscore.Memory.log
}
#JVM-内存池-G1GC-幸存者区
function MemoryPool {
	if [ "${NAME}" == "G1SurvivorSpace" ];then
		NAME='G1 Survivor Space'
	elif [ "${NAME}" == "G1EdenSpace" ];then
		NAME='G1 Eden Space'
	elif [ "${NAME}" == "G1OldSpace" ];then
		NAME='G1 Old Gen'
	fi
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:name=${NAME},type=MemoryPool" "Usage" &> /tmp/zabbix.dscore.MemoryPool.log
	grep ${VALUE} /tmp/zabbix.dscore.MemoryPool.log|awk '{print $2}'
}
#JVM-内存池-G1GC-内存回收
function GarbageCollector {
	if [ "${NAME}" == "G1YoungGeneration" ];then
		NAME='G1 Young Generation'
	elif [ "${NAME}" == "G1OldGeneration" ];then
		NAME='G1 Old Generation'
	fi
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "java.lang:name=${NAME},type=GarbageCollector" "${VALUE}" &> /tmp/zabbix.dscore.GarbageCollector.log
	awk '{print $6}' /tmp/zabbix.dscore.GarbageCollector.log
}
#tomcat-线程池
function ThreadPool {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "Catalina:name=\"${NAME}\",type=ThreadPool" "${VALUE}" &> /tmp/zabbix.dscore.ThreadPool.log
	awk '{print $6}' /tmp/zabbix.dscore.ThreadPool.log
}
#tomcat-请求池
function GlobalRequestProcessor {
	${JDK}/bin/java -jar ${CMDLINE} ${JMX_USER}:${JMX_PWD} ${JMX_HOST}:${JMX_PORT} "Catalina:name=\"${NAME}\",type=GlobalRequestProcessor" "${VALUE}" &> /tmp/zabbix.dscore.GlobalRequestProcessor.log
	awk '{print $6}' /tmp/zabbix.dscore.GlobalRequestProcessor.log
}
#tomcat-pid
function DsCorePid {
	ps -ef|grep tomcat|grep dscore|grep -v grep|awk '{print $2}'
}


${1}