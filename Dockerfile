FROM openjdk:11.0.6-slim

RUN apt-get update && apt-get upgrade -y && apt-get install -y wget gpg

ENV ZOOKEEPER_VERSION 3.6.0

#Download Zookeeper
RUN wget -q http://mirror.vorboss.net/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz && \
wget -q https://www.apache.org/dist/zookeeper/KEYS && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc && \
wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512

#Verify download
RUN sha512sum -c apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.sha512 && \
gpg --import KEYS && \
gpg --verify apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz.asc

#Install
ENV ZK_HOME /opt/apache-zookeeper-${ZOOKEEPER_VERSION}
RUN mkdir -p $ZK_HOME && tar -xzf apache-zookeeper-${ZOOKEEPER_VERSION}-bin.tar.gz --strip-components 1 -C $ZK_HOME

#Configure
ADD zoo.cfg $ZK_HOME/conf/zoo.cfg
ADD log4j.properties $ZK_HOME/conf/log4j.properties

RUN mkdir /data

EXPOSE 2181 2888 3888 7000

WORKDIR $ZK_HOME
VOLUME ["${ZK_HOME}/conf", "/data"]

ENTRYPOINT /bin/bash ${ZK_HOME}/bin/zkServer.sh start-foreground
