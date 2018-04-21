#!/bin/bash
set -e

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
    topic="test_topic"
    sleep 2 && kafka-topics --create --topic $topic --replication-factor 1 --partitions 12 --zookeeper localhost:2181
    for x in {1..100}; do echo $x; done | kafka-console-producer --broker-list localhost:9092 --topic $topic
    rows=`kafka-console-consumer --bootstrap-server localhost:9092 --topic $topic --from-beginning --timeout-ms 2000 | wc -l`
    # rows=`kafkacat -C -b localhost:9092 -t $topic -o beginning -e | wc -l `
    if [ "$rows" != "100" ]; then
        kafka-console-consumer --bootstrap-server localhost:9092 --topic test-topic --from-beginning --timeout-ms 2000 | wc -l
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


