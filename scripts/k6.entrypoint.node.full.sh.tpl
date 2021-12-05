#!/bin/bash

sudo yum update -y
sudo yum install -y pcre2-devel.x86_64 python gcc python3-devel tzdata curl unzip bash java-11-amazon-corretto htop k6

#ELK
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# INSTALL FILEBEAT
wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.1.0-x86_64.rpm
sudo rpm -ivh filebeat-oss-7.1.0-x86_64.rpm

# INSTALL LOGSTASH
wget -q https://artifacts.elastic.co/downloads/logstash/logstash-oss-7.1.0.rpm
sudo rpm -ivh logstash-oss-7.1.0.rpm


export PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment

source ~/.bashrc

mkdir -p ~/.ssh
echo 'Host *' > ~/.ssh/config
echo 'StrictHostKeyChecking no' >> ~/.ssh/config

touch /tmp/finished-setup

# START JMETER NODE
jmeter -s -Dserver.rmi.localport=50000 -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$PRIVATE_IP -j /tmp/jmeter-server.log
