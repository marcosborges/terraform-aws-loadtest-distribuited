#!/bin/bash

sudo yum update -y
sudo yum install -y pcre2-devel.x86_64 python gcc python3-devel tzdata curl unzip bash java-11-amazon-corretto htop

export JMETER_VERSION="5.4.1"
export BZT_VERSION="1.16.0"

export JMETER_HOME=/opt/apache-jmeter-${JMETER_VERSION}
export JMETER_BIN=${JMETER_HOME}/bin
export MIRROR_HOST=https://archive.apache.org/dist/jmeter
export JMETER_DOWNLOAD_URL=${MIRROR_HOST}/binaries/apache-jmeter-${JMETER_VERSION}.tgz
export JMETER_PLUGINS_DOWNLOAD_URL=http://repo1.maven.org/maven2/kg/apc
export JMETER_PLUGINS_FOLDER=${JMETER_HOME}/lib/ext/

#echo "SC_SEARCH_PASS=${var.search_pass}" >> /etc/environment

sudo adduser jmeter -d $JMETER_HOME -U -b $JMETER_HOME -s /bin/bash
sudo usermod -a -G jmeter ec2-user
sudo mkdir -p /tmp/dependencies
sudo chown -R jmeter:jmeter /tmp/dependencies
sudo chmod -R 777 /tmp/dependencies

curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz
sudo mkdir -p /opt
sudo tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt
sudo rm -rf /tmp/dependencies

sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-cmn-jmeter/0.6/jmeter-plugins-cmn-jmeter-0.6.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-cmn-jmeter-0.6.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-dummy/0.4/jmeter-plugins-dummy-0.4.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-dummy-0.4.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-casutg/2.9/jmeter-plugins-casutg-2.9.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-casutg-2.9.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-ffw/2.0/jmeter-plugins-ffw-2.0.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-ffw-2.0.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-fifo/0.2/jmeter-plugins-fifo-0.2.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-fifo-0.2.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-functions/2.1/jmeter-plugins-functions-2.1.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-functions-2.1.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-json/2.7/jmeter-plugins-json-2.7.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-json-2.7.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-perfmon/2.1/jmeter-plugins-perfmon-2.1.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-perfmon-2.1.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-prmctl/0.4/jmeter-plugins-prmctl-0.4.jar  -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-prmctl-0.4.jar
sudo curl -L --silent https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-tst/2.5/jmeter-plugins-tst-2.5.jar -o ${JMETER_PLUGINS_FOLDER}/jmeter-plugins-tst-2.5.jar

sudo chown -R jmeter:jmeter ${JMETER_PLUGINS_FOLDER}
sudo chmod -R 777 ${JMETER_PLUGINS_FOLDER} 
sudo chown -R jmeter:jmeter ${JMETER_HOME}
sudo chmod -R 777 ${JMETER_HOME}

export PATH="$PATH:$JMETER_BIN"
echo $PATH

sudo pip3 nstall bzt==${BZT_VERSION}

cd ${JMETER_HOME}