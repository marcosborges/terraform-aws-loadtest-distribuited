#!/bin/bash

export HOSTNAME=$(hostname -I | awk '{print $1}')
echo "HOSTNAME=$HOSTNAME" >> /etc/environment

export JVM_ARGS="${JVM_ARGS}"
echo "JVM_ARGS=${JVM_ARGS}" >> /etc/environment



# START JMETER NODE
jmeter -s -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$HOSTNAME