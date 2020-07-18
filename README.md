[![Build Status](https://travis-ci.org/simplesteph/kafka-stack-docker-compose.svg?branch=master)](https://travis-ci.org/simplesteph/kafka-stack-docker-compose)

# kafka-stack-docker-compose

This replicates as well as possible real deployment configurations, where you have your zookeeper servers and kafka servers actually all distinct from each other. This solves all the networking hurdles that comes with Docker and docker-compose, and is compatible cross platform.

**UPDATE**: No /etc/hosts file changes are necessary anymore. Explanations at: https://rmoff.net/2018/08/02/kafka-listeners-explained/

## Stack version

  - Zookeeper version: 3.4.9
  - Kafka version: 2.5.0 (Confluent 5.5.1)
  - Kafka Schema Registry: Confluent 5.5.1
  - Kafka Schema Registry UI: 0.9.5
  - Kafka Rest Proxy: Confluent 5.5.1
  - Kafka Topics UI: 0.9.4
  - Kafka Connect: Confluent 5.5.1
  - Kafka Connect UI: 0.9.7
  - ksqlDB Server: Confluent 5.5.1
  - Zoonavigator: 0.8.0


## Optional: Kafka Desktop Application

Once you have started your cluster, you can use [Conduktor](https://www.conduktor.io/) to easily manage it. 
Just connect against `localhost:9092` if using Docker, or `192.168.99.100` if using Docker Toolbox

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

If you want to have three brokers and experiment with kafka replication / fault-tolerance.

- Zookeeper will be available at `$DOCKER_HOST_IP:2181`
- Kafka will be available at `$DOCKER_HOST_IP:9092,$DOCKER_HOST_IP:9093,$DOCKER_HOST_IP:9094`


Run with:
```
docker-compose -f zk-single-kafka-multiple.yml up
docker-compose -f zk-single-kafka-multiple.yml down
```

## Multiple Zookeeper / Single Kafka

If you want to have three zookeeper nodes and experiment with zookeeper fault-tolerance.

- Zookeeper will be available at `$DOCKER_HOST_IP:2181,$DOCKER_HOST_IP:2182,$DOCKER_HOST_IP:2183`
- Kafka will be available at `$DOCKER_HOST_IP:9092`

Run with:
```
docker-compose -f zk-multiple-kafka-single.yml up
docker-compose -f zk-multiple-kafka-single.yml down
```


## Multiple Zookeeper / Multiple Kafka

If you want to have three zookeeper nodes and three kafka brokers to experiment with production setup.

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
 - KSQL Server: `$DOCKER_HOST_IP:8088`
 - Zoonavigator Web: `$DOCKER_HOST_IP:8004`


 Run with:
 ```
 docker-compose -f full-stack.yml up
 docker-compose -f full-stack.yml down
 ```

# FAQ

## Kafka

**Q: Kafka's log is too verbose, how can I reduce it?**

A: Add the following line to your docker-compose environment variables: `KAFKA_LOG4J_LOGGERS: "kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO"`. Full logging control can be accessed here: https://github.com/confluentinc/cp-docker-images/blob/master/debian/kafka/include/etc/confluent/docker/log4j.properties.template

**Q: How do I delete data to start fresh?**

A: Your data is persisted from within the docker compose folder, so if you want for example to reset the data in the full-stack docker compose, first do a `docker-compose -f full-stack.yml down`, then remove the directory `full-stack`, for example by doing `rm -r -f full-stack`.

**Q: Can I change the zookeeper ports?**

A: yes. Say you want to change `zoo1` port to `12181` (only relevant lines are shown):
```
  zoo1:
    ports:
      - "12181:12181"
    environment:
        ZOO_PORT: 12181
        
  kafka1:
    environment:
      KAFKA_ZOOKEEPER_CONNECT: "zoo1:12181"
```

**Q: Can I change the Kafka ports?**

A: yes. Say you want to change `kafka1` port to `12345` (only relevant lines are shown). Note only `LISTENER_DOCKER_EXTERNAL` changes:
```
  kafka1:
    image: confluentinc/cp-kafka:5.5.1
    hostname: kafka1
    ports:
      - "12345:12345"
    environment:
      KAFKA_ADVERTISED_LISTENERS: LISTENER_DOCKER_INTERNAL://kafka1:19092,LISTENER_DOCKER_EXTERNAL://${DOCKER_HOST_IP:-127.0.0.1}:12345
```

**Q: Kafka is using a lot of disk space for testing. Can I reduce it?**

A: yes. This is for testing only!!! Reduce the KAFKA_LOG_SEGMENT_BYTES to 16MB and the KAFKA_LOG_RETENTION_BYTES to 128MB

```
  kafka1:
    image: confluentinc/cp-kafka:5.5.1
    ...
    environment:
      ...
      # For testing small segments 16MB and retention of 128MB
      KAFKA_LOG_SEGMENT_BYTES: 16777216
      KAFKA_LOG_RETENTION_BYTES: 134217728
```
