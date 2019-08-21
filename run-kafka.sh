#!/bin/bash
cd /usr/share/kafka
echo "Starting Zookeeper"
bin/zookeeper-server-start.sh config/zookeeper.properties &
echo "Sleeping to wait for Zookeeper"
sleep 15s
echo "Starting Kafka server"
bin/kafka-server-start.sh config/server.properties