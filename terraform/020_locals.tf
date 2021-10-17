locals {
  master_user_data = <<EOF
#!/bin/bash
echo "AWS_REGION=${var.region}" >> /etc/environment
echo "SC_PLAN_ID=${var.plan_id}" >> /etc/environment
echo "SC_PLAN_NAME=${var.plan_name}" >> /etc/environment
echo "SC_PLAN_EXECUTION_ID=${var.plan_execution_id}" >> /etc/environment
echo "SC_PLAN_EXECUTION_AUTHOR=${var.plan_execution_author}" >> /etc/environment
echo "SC_TENANT_ID=${var.tenant_id}" >> /etc/environment
echo "SC_SEARCH_HOST=${var.search_host}" >> /etc/environment 
echo "SC_SEARCH_USER=${var.search_user}" >> /etc/environment
echo "SC_SEARCH_PASS=${var.search_pass}" >> /etc/environment
echo "BEAT_LOG_OPTS=-e" >> /etc/environment
echo "BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat.yml" >> /etc/environment
echo "BEAT_PATH_OPTS=-path.home /usr/share/filebeat -path.config /etc/filebeat -path.data /var/lib/filebeat -path.logs /var/log/filebeat" >> /etc/environment
sudo service loghstash restart
sudo service filebeat restart
EOF
  slave_user_data  = <<EOF
#!/bin/bash
echo "AWS_REGION=${var.region}" >> /etc/environment
echo "SC_PLAN_ID=${var.plan_id}" >> /etc/environment
echo "SC_PLAN_NAME=${var.plan_name}" >> /etc/environment
echo "SC_PLAN_EXECUTION_ID=${var.plan_execution_id}" >> /etc/environment
echo "SC_PLAN_EXECUTION_AUTHOR=${var.plan_execution_author}" >> /etc/environment
echo "SC_TENANT_ID=${var.tenant_id}" >> /etc/environment
echo "SC_SEARCH_HOST=${var.search_host}" >> /etc/environment 
echo "SC_SEARCH_USER=${var.search_user}" >> /etc/environment
echo "SC_SEARCH_PASS=${var.search_pass}" >> /etc/environment
echo "BEAT_LOG_OPTS=-e" >> /etc/environment
echo "BEAT_CONFIG_OPTS=-c /etc/filebeat/filebeat.yml" >> /etc/environment
echo "HOSTIP=$(hostname -I | awk '{print $1}')" >> /etc/environment
echo "BEAT_PATH_OPTS=-path.home /usr/share/filebeat -path.config /etc/filebeat -path.data /var/lib/filebeat -path.logs /var/log/filebeat" >> /etc/environment
sudo service logstash stop
sudo service filebeat stop
export JVM_ARGS="-XX:+HeapDumpOnOutOfMemoryError -Xms1g -Xmx2g -XX:MaxMetaspaceSize=256m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20 -Dnashorn.args=--no-deprecation-warning"
sudo -H -u jmeter bash -c "/opt/apache-jmeter-5.4.1/bin/jmeter-server  -Dserver.rmi.localport=50000  -Dserver_port=1099 -Dserver.rmi.ssl.disable=true -Djava.rmi.server.hostname=$(hostname -I | awk '{print $1}')"
EOF
}
# 
#-Xms4g -Xmx80g -XX:MaxMetaspaceSize=512m -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:G1ReservePercent=20