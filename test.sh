#!/bin/bash
set -ex

docker-compose -f $1 up -d
sleep 10
# some tests on Kafka
running = `docker-compose -f $1 ps | grep Up | wc -l`
if [ "$running" != "$2" ]; then
   exit 1
fi
docker-compose -f $1 down


