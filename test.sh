#!/bin/bash
set -ex

all_great(){
    # for testing
    running=`docker-compose -f $1 ps | grep Up | wc -l`
    if [ "$running" != "$2" ]; then
        # for logging
        docker-compose -f $1 ps
        # debug
        docker-compose -f $1 logs
        exit 1
    fi
}

kafka_tests(){
    kafka-topics --create --topic test_topic --replication-factor 1 --partitions 12
    for x in {1..100}; do echo $x; sleep 2; done | kafka-console-producer --broker-list localhost:9092 --topic test_topic
    rows=`kafkacat -C -b localhost:9092 -t test_topic -o beginning -e | wc -l `
    if [ "$rows" != "100" ]; then
        kafkacat -C -b localhost:9092 -t test_topic -o beginning -e
        exit 1
    fi
}

# creating stack...
docker-compose -f $1 up -d
sleep 10
# logging
docker-compose -f $1 ps
# tests
all_great $1 $2
kafka_tests
all_great $1 $2
# teardown
docker-compose -f $1 down


