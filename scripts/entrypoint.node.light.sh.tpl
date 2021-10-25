#!/bin/bash
export HOSTNAME=$(hostname -I | awk '{print $1}')
export JVM_ARGS="-XX:+HeapDumpOnOutOfMemoryError -Xms10g -Xmx36g -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 -Dnashorn.args=--no-deprecation-warning"
jmeter -s -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$HOSTNAME