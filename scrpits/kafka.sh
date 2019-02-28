#!export JAVA_HOME=${JAVA_HOME};/bin/bash
GROUP=ds_group
HOST_IP=`ip a|grep inet|grep -v inet6|grep -v 127.0.0.1|awk '{print $2}'|awk -F/ '{print $1}'`
KCC=
KRC=
JAVA_HOME=/etc/zabbix/jdk1.8.0_191
JAVA_CMD=/etc/zabbix/scripts/kafka/cmdline-jmxclient-0.10.3.jar
KAFKA_PORT=9092
JMXPORT=9999
JMX_USER=-
JMX_PASS=-
#partition
function ds.medical_service_partition {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.medical_service|awk '{print $2}'
}

function ds.wechat_partition {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.wechat|awk '{print $2}'
}

function log_srv_init_partition {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.log_srv_init|awk '{print $2}'
}
#current-offset
function ds.medical_service_current_offset {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.medical_service|awk '{print $3}'
}

function ds.wechat_current_offset {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.wechat|awk '{print $3}'
}

function log_srv_init_current_offset {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.log_srv_init|awk '{print $3}'
}
#log-end-offset
function ds.medical_service_log_end_offset {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.medical_service|awk '{print $4}'
}

function ds.wechat_log_end_offset {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.wechat|awk '{print $4}'
}

function log_srv_init_log_end_offset {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.log_srv_init|awk '{print $4}'
}
#lag
function ds.medical_service_lag {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.medical_service|awk '{print $5}'
}

function ds.wechat_lag {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.wechat|awk '{print $5}'
}

function log_srv_init_lag {
        export JAVA_HOME=${JAVA_HOME};/bin/bash ${KCC} --bootstrap-server $HOST_IP:$KAFKA_PORT --group $GROUP --describe |grep ds.log_srv_init|awk '{print $5}'
}
#BrokerTopicMetrics
function MessagesInPerSec {
	${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=BrokerTopicMetrics,name=MessagesInPerSec" "OneMinuteRate" &> /tmp/kafka_topic_tmp 
	awk '{print $6}' /tmp/kafka_topic_tmp
	rm -f /tmp/kafka_topic_tmp
}
function BytesInPerSec {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec" "OneMinuteRate" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function BytesOutPerSec {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec" "OneMinuteRate" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function UnderReplicatedPartitions {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=ReplicaManager,name=UnderReplicatedPartitions" "Value" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function IsrShrinksPerSec {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=ReplicaManager,name=IsrShrinksPerSec" "Value" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function IsrExpandsPerSec {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=ReplicaManager,name=IsrExpandsPerSec" "Value" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function MaxLag {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=ReplicaFetcherManager,name=MaxLag,clientId=Replica" "Value" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function Produce_PurgatorySize {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=DelayedOperationPurgatory,name=PurgatorySize,delayedOperation=Produce" "Value" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function Fetch_PurgatorySize {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=DelayedOperationPurgatory,name=PurgatorySize,delayedOperation=Fetch" "Value" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function RequestHandlerAvgIdlePercent {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.server:type=KafkaRequestHandlerPool,name=RequestHandlerAvgIdlePercent" "OneMinuteRate" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function RequestQueueTimeMs_Produce {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=RequestQueueTimeMs,request=Produce" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function RequestQueueTimeMs_FetchFollower {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=RequestQueueTimeMs,request=FetchFollower" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function RequestQueueTimeMs_FetchConsumer {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=RequestQueueTimeMs,request=FetchConsumer" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function TotalTimeMs_Produce {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=TotalTimeMs,request=Produce" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function TotalTimeMs_FetchFollower {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=TotalTimeMs,request=FetchFollower" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function TotalTimeMs_FetchConsumer {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=TotalTimeMs,request=FetchConsumer" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function ResponseSendTimeMs_Produce {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=ResponseSendTimeMs,request=Produce" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function ResponseSendTimeMs_FetchFollower {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=ResponseSendTimeMs,request=FetchFollower" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
function ResponseSendTimeMs_FetchConsumer {
        ${JAVA_BIN}/bin/java -jar ${JAVA_CMD} ${JMX_USER}:${JMX_PASS} ${HOST_IP}:${JMXPORT} "kafka.network:type=RequestMetrics,name=ResponseSendTimeMs,request=FetchConsumer" "Mean" &> /tmp/kafka_topic_tmp
        awk '{print $6}' /tmp/kafka_topic_tmp
        rm -f /tmp/kafka_topic_tmp
}
























${1}

