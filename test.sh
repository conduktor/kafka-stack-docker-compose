#!/bin/bash

all_great(){
    # for testing
    echo "Verifying Process"
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
    echo "Testing Kafka"
    topic="test_topic"
    replication_factor="1"
    for i in 1 2 3 4 5; do kafka-topics --create --topic $topic --replication-factor $replication_factor --partitions 12 --zookeeper localhost:2181 && break || sleep 5; done
    for x in {1..100}; do echo $x; done | kafka-console-producer --broker-list localhost:9092 --topic $topic
    rows=`kafka-console-consumer --bootstrap-server localhost:9092 --topic $topic --from-beginning --timeout-ms 2000 | wc -l`
    # rows=`kafkacat -C -b localhost:9092 -t $topic -o beginning -e | wc -l `
    if [ "$rows" != "100" ]; then
        kafka-console-consumer --bootstrap-server localhost:9092 --topic test-topic --from-beginning --timeout-ms 2000 | wc -l
        exit 1
    else;
        echo "Kafka Test Success"
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
echo "Success!"
