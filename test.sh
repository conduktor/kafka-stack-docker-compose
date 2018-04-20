#!/bin/bash
set -ex

docker-compose -f $1 up -d
sleep 10
# for logging
docker-compose -f $1 ps

# TODO: some tests on Kafka

# for testing
running=`docker-compose -f $1 ps | grep Up | wc -l`
if [ "$running" != "$2" ]; then
    # for logging
    docker-compose -f $1 ps
    # debug
    docker-compose -f $1 logs
    exit 1
fi
docker-compose -f $1 down


