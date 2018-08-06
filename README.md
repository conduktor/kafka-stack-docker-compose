[![Build Status](https://travis-ci.org/simplesteph/kafka-stack-docker-compose.svg?branch=master)](https://travis-ci.org/simplesteph/kafka-stack-docker-compose)


# kafka-stack-docker-compose

This replicates as well as possible real deployment configurations, where you have your zookeeper servers and kafka servers actually all distinct from each other. This solves all the networking hurdles that comes with Docker and docker-compose, and is compatible cross platform.

[UPDATE]: No /etc/hosts file changes are necessary anymore. Explanations at: https://rmoff.net/2018/08/02/kafka-listeners-explained/

## Stack version

  - Zookeeper version: 3.4.9
  - Kafka version: 1.1.1 (Confluent 4.1.2)
  - Kafka Schema Registry: Confluent 4.1.2
  - Kafka Schema Registry UI: 0.9.4
  - Kafka Rest Proxy: Confluent 4.1.2
  - Kafka Topics UI: 0.9.3
  - Kafka Connect: Confluent 4.1.2
  - Kafka Connect UI: 0.9.4
  - Zoonavigator: 0.4.0

# Requirements

## Docker

Please export your environment before starting the stack:
```
export DOCKER_HOST_IP=127.0.0.1
```
(that's the default value and you actually don't need to do a thing)

## Docker-Toolbox
If you are using Docker for Mac <= 1.11, or Docker Toolbox for Windows
(your docker machine IP is usually `192.168.99.100`)

Please export your environment before starting the stack:
```
export DOCKER_HOST_IP=192.168.99.100
```

## Single Zookeeper / Single Kafka

This configuration fits most development requirements.

 - Zookeeper will be available at `$DOCKER_HOST_IP:2181`
 - Kafka will be available at `$DOCKER_HOST_IP:9092`


Run with:
```
docker-compose -f zk-single-kafka-single.yml up
docker-compose -f zk-single-kafka-single.yml down
```

## Single Zookeeper / Multiple Kafka

If you want to have two brokers and experiment with replication / fault-tolerance.

- Zookeeper will be available at `$DOCKER_HOST_IP:2181`
- Kafka will be available at `$DOCKER_HOST_IP:9092,$DOCKER_HOST_IP:9093,$DOCKER_HOST_IP:9094`


Run with:
```
docker-compose -f zk-single-kafka-multiple.yml up
docker-compose -f zk-single-kafka-multiple.yml down
```

## Multiple Zookeeper / Single Kafka

If you want to have three zookeeper and experiment with zookeeper fault-tolerance.

- Zookeeper will be available at `$DOCKER_HOST_IP:2181,$DOCKER_HOST_IP:2182,$DOCKER_HOST_IP:2183`
- Kafka will be available at `$DOCKER_HOST_IP:9092`

Run with:
```
docker-compose -f zk-multiple-kafka-single.yml up
docker-compose -f zk-multiple-kafka-single.yml down
```


## Multiple Zookeeper / Multiple Kafka

If you want to have three zookeeper and two kafka brokers to experiment with production setup.

- Zookeeper will be available at `$DOCKER_HOST_IP:2181,$DOCKER_HOST_IP:2182,$DOCKER_HOST_IP:2183`
- Kafka will be available at `$DOCKER_HOST_IP:9092,$DOCKER_HOST_IP:9093,$DOCKER_HOST_IP:9094`

Run with:
```
docker-compose -f zk-multiple-kafka-multiple.yml up
docker-compose -f zk-multiple-kafka-multiple.yml down
```


## Full stack

 - Single Zookeeper: `$DOCKER_HOST_IP:2181`
 - Single Kafka: `$DOCKER_HOST_IP:9092`
 - Kafka Schema Registry: `$DOCKER_HOST_IP:8081`
 - Kafka Schema Registry UI: `$DOCKER_HOST_IP:8001`
 - Kafka Rest Proxy: `$DOCKER_HOST_IP:8082`
 - Kafka Topics UI: `$DOCKER_HOST_IP:8000`
 - Kafka Connect: `$DOCKER_HOST_IP:8083`
 - Kafka Connect UI: `$DOCKER_HOST_IP:8003`
 - Zoonavigator Web: `$DOCKER_HOST_IP:8004`


 Run with:
 ```
 docker-compose -f full-stack.yml up
 docker-compose -f full-stack.yml down
 ```

# FAQ

## Kafka

Q: Kafka's log is too verbose, how can I reduce it?
A: Add the following line to your docker-compose environment variables: `KAFKA_LOG4J_LOGGERS: "kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO"`. Full logging control can be accessed here: https://github.com/confluentinc/cp-docker-images/blob/master/debian/kafka/include/etc/confluent/docker/log4j.properties.template

Q: How do I delete data to start fresh?
A: Your data is persisted from within the docker compose folder, so if you want for example to reset the data in the full-stack docker compose, first do a `docker-compose -f full-stack.yml down`, then remove the directory `full-stack`, for example by doing `rm -r -f full-stack`.
