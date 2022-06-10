#!/bin/bash

sudo yum update -y
sudo yum install -y pcre2-devel.x86_64 python gcc python3-devel tzdata curl unzip bash java-11-amazon-corretto htop httpd k6

# APACHE
sudo systemctl enable httpd
sudo systemctl start httpd
sudo chmod -r 777 /var/www/html
sudo rm -rf /var/www/html/*

# TAURUS
export BZT_VERSION="1.16.0"
sudo pip3 install bzt==$BZT_VERSION

# LOCUST
export LOCUST_VERSION="2.9.0"
sudo pip3 install locust==$LOCUST_VERSION

# JMETER
export MIRROR_HOST=https://archive.apache.org/dist/jmeter
export JMETER_VERSION="5.4.1"
export JMETER_HOME=/opt/apache-jmeter-$JMETER_VERSION
export JMETER_BIN=$JMETER_HOME/bin
export JMETER_DOWNLOAD_URL=$MIRROR_HOST/binaries/apache-jmeter-$JMETER_VERSION.tgz
export JMETER_PLUGINS_DOWNLOAD_URL=http://repo1.maven.org/maven2/kg/apc
export JMETER_PLUGINS_FOLDER=$JMETER_HOME/lib/ext/

# DOWNLOAD JMETER
curl -L --silent $JMETER_DOWNLOAD_URL > /tmp/apache-jmeter-$JMETER_VERSION.tgz

# UNCOMPRESS JMETER PACKAGE
sudo mkdir -p /opt
sudo tar -xzf /tmp/apache-jmeter-$JMETER_VERSION.tgz -C /opt

# ADD JMETER UM PATH
export PATH="$PATH:$JMETER_BIN"
echo "PATH=$PATH" >> /etc/environment

sudo echo "#!/bin/bash" > /etc/profile.d/script.sh
sudo echo "export PATH=\"\$PATH:\$JMETER_BIN\"" >> /etc/profile.d/script.sh
sudo chmod +x /etc/profile.d/script.sh

export PRIVATE_IP=$(hostname -I | awk '{print $1}')
echo "PRIVATE_IP=$PRIVATE_IP" >> /etc/environment

export JVM_ARGS="${JVM_ARGS}  "
echo "JVM_ARGS=${JVM_ARGS}  " >> /etc/environment

# INSTALL PLUGINS
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-cmn-jmeter/0.6/jmeter-plugins-cmn-jmeter-0.6.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-cmn-jmeter-0.6.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-dummy/0.4/jmeter-plugins-dummy-0.4.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-dummy-0.4.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-casutg/2.9/jmeter-plugins-casutg-2.9.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-casutg-2.9.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-ffw/2.0/jmeter-plugins-ffw-2.0.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-ffw-2.0.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-fifo/0.2/jmeter-plugins-fifo-0.2.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-fifo-0.2.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-functions/2.1/jmeter-plugins-functions-2.1.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-functions-2.1.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-json/2.7/jmeter-plugins-json-2.7.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-json-2.7.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-perfmon/2.1/jmeter-plugins-perfmon-2.1.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-perfmon-2.1.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-prmctl/0.4/jmeter-plugins-prmctl-0.4.jar  -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-prmctl-0.4.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-tst/2.5/jmeter-plugins-tst-2.5.jar -o $JMETER_PLUGINS_FOLDER/jmeter-plugins-tst-2.5.jar


mkdir -p ~/.ssh
echo 'Host *' > ~/.ssh/config
echo 'StrictHostKeyChecking no' >> ~/.ssh/config

touch /tmp/finished-setup
