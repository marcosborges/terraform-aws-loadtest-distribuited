#!/bin/bash

sudo curl https://d3g5vo6xdbdb9a.cloudfront.net/yum/opendistroforelasticsearch-artifacts.repo -o /etc/yum.repos.d/opendistroforelasticsearch-artifacts.repo

sudo yum update -y
sudo yum install -y pcre2-devel.x86_64 python gcc python3-devel tzdata curl wget unzip bash java-11-amazon-corretto htop httpd k6

sudo yum install opendistroforelasticsearch-1.13.2
sudo systemctl start elasticsearch.service
curl -XGET https://localhost:9200 -u 'admin:admin' --insecure
curl -XGET https://localhost:9200/_cat/nodes?v -u 'admin:admin' --insecure
curl -XGET https://localhost:9200/_cat/plugins?v -u 'admin:admin' --insecure

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable elasticsearch.service

#ELK
sudo rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

# INSTALL FILEBEAT
wget -q https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-oss-7.1.0-x86_64.rpm
sudo rpm -ivh filebeat-oss-7.1.0-x86_64.rpm

# INSTALL LOGSTASH
wget -q https://artifacts.elastic.co/downloads/logstash/logstash-oss-7.1.0.rpm
sudo rpm -ivh logstash-oss-7.1.0.rpm


# APACHE
sudo systemctl enable httpd
sudo systemctl start httpd
sudo chmod -r 777 /var/www/html
sudo rm -rf /var/www/html/*

export PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment

mkdir -p ~/.ssh
echo 'Host *' > ~/.ssh/config
echo 'StrictHostKeyChecking no' >> ~/.ssh/config

touch /tmp/finished-setup
