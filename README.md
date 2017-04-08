# kafka-stack-docker-compose

This replicates as well as possible real deployment configurations, where you have your zookeeper servers and kafka servers actually all distinct from each other. This solves all the networking hurdles that comes with docker-compose, and is compatible cross platform. It only requires an update to your host files.

## Stack version

  - Zookeeper version: 3.4.9
  - Kafka version: 0.10.1.1 (Confluent 3.2.0)
  - Kafka Schema Registry: Confluent 3.2.0
  - Kafka Schema Registry UI: 0.9.0
  - Kafka Rest Proxy: Confluent 3.2.0
  - Kafka Topics UI: 0.8.2
  - Kafka Connect: Confluent 3.2.0
  - Kafka Connect UI: 0.8.2

# Requirements

## Host File changes

See https://support.rackspace.com/how-to/modify-your-hosts-file/ to detailed instructions on how to modify your host files.

If you are using Docker for Mac >= 1.12, Docker for Linux, or Docker for Windows 10, then please add the following lines to `/etc/hosts` or `C:\Windows\System32\Drivers\etc\hosts`:
```
127.0.0.1     kafka1
127.0.0.1     kafka2
127.0.0.1     kafka3
127.0.0.1     zoo1
127.0.0.1     zoo2
127.0.0.1     zoo3
127.0.0.1     kafka-schema-registry
127.0.0.1     kafka-schema-registry-ui
127.0.0.1     kafka-rest-proxy
127.0.0.1     kafka-topics-ui
127.0.0.1     kafka-connect-ui
```

If you are using Docker for Mac <= 1.11, or Docker Toolbox for Windows
(your docker machine IP is usually `192.168.99.100`)
Please add the following lines to `/etc/hosts` or `C:\Windows\System32\Drivers\etc\hosts`:
```
192.168.99.100    kafka1
192.168.99.100    kafka2
192.168.99.100    kafka3
192.168.99.100    zoo1
192.168.99.100    zoo2
192.168.99.100    zoo3
192.168.99.100    kafka-schema-registry
192.168.99.100    kafka-schema-registry-ui
192.168.99.100    kafka-rest-proxy
192.168.99.100    kafka-topics-ui
192.168.99.100    kafka-connect-ui
```

## Single Zookeeper / Single Kafka

This configuration fits most development requirements.

 - Zookeeper will be available at `zoo1:2181`
 - Kafka will be available at `kafka1:9092`


Run with:
```
docker-compose -f zk-single-kafka-single.yml up
docker-compose -f zk-single-kafka-single.yml down
```

## Single Zookeeper / Multiple Kafka

If you want to have two brokers and experiment with replication / fault-tolerance.

- Zookeeper will be available at `zoo1:2181`
- Kafka will be available at `kafka1:9092,kafka2:9093,kafka3:9094`


Run with:
```
docker-compose -f zk-single-kafka-multiple.yml up
docker-compose -f zk-single-kafka-multiple.yml down
```

## Multiple Zookeeper / Single Kafka

If you want to have three zookeeper and experiment with zookeeper fault-tolerance.

- Zookeeper will be available at `zoo1:2181,zoo2:2182,zoo3:2183`
- Kafka will be available at `kafka1:9092`

Run with:
```
docker-compose -f zk-multiple-kafka-single.yml up
docker-compose -f zk-multiple-kafka-single.yml down
```


## Multiple Zookeeper / Multiple Kafka

If you want to have three zookeeper and two kafka brokers to experiment with production setup.

- Zookeeper will be available at `zoo1:2181,zoo2:2182,zoo3:2183`
- Kafka will be available at `kafka1:9092,kafka2:9093,kafka3:9094`

Run with:
```
docker-compose -f zk-multiple-kafka-multiple.yml up
docker-compose -f zk-multiple-kafka-multiple.yml down
```


## Full stack

 - Single Zookeeper: `zoo1:2181`
 - Single Kafka: `kafka1:9092`
 - Kafka Schema Registry: `kafka-schema-registry:8081`
 - Kafka Schema Registry UI: `kafka-schema-registry-ui:8001`
 - Kafka Rest Proxy: `kafka-rest-proxy:8082`
 - Kafka Topics UI: `kafka-topics-ui:8000`
 - Kafka Connect: `kafka-connect:8083`
 - Kafka Connect UI: `kafka-connect-ui:8003`


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
