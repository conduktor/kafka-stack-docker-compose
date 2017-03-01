# kafka-stack-docker-compose

This replicates as well as possible real deployment configurations, where you have your zookeeper servers and kafka servers actually all distinct from each other. This solves all the networking hurdles that comes with docker-compose, and is compatible cross platform. It only requires an update to your host files.

## Stack version

  - Zookeeper version: 3.4.9
  - Kafka version: 0.10.1.1 (Confluent 3.1.2)
  - Kafka Schema Registry: Confluent 3.1.2
  - Kafka Schema Registry UI: 0.9.0
  - Kafka Rest Proxy: Confluent 3.1.2
  - Kafka Topics UI: 0.8.2
  - Kafka Connect: Confluent 3.1.2
  - Kafka Connect UI: 0.8.2

## Single Zookeeper / Single Kafka

This configuration fits most development requirements.

 - Zookeeper will be available at `localhost:2181`
 - Kafka will be available at `localhost:9092`

Make sure to add to your `/etc/hosts` file
```
127.0.0.1     kafka1
```

Run with:
```
docker-compose -f zk-single-kafka-single.yml up
docker-compose -f zk-single-kafka-single.yml down
```

## Single Zookeeper / Multiple Kafka

If you want to have two brokers and experiment with replication / fault-tolerance.

- Zookeeper will be available at `localhost:2181`
- Kafka will be available at `localhost:9092,localhost:9093`

Make sure to add to your `/etc/hosts` file
```
127.0.0.1     kafka1
127.0.0.1     kafka2
```

Run with:
```
docker-compose -f zk-single-kafka-multiple.yml up
docker-compose -f zk-single-kafka-multiple.yml down
```

## Multiple Zookeeper / Single Kafka

If you want to have three zookeeper and experiment with zookeeper fault-tolerance.

- Zookeeper will be available at `localhost:2181,localhost:2182,localhost:2183`
- Kafka will be available at `localhost:9092`

Make sure to add to your `/etc/hosts` file
```
127.0.0.1     kafka1
```

Run with:
```
docker-compose -f zk-multiple-kafka-single.yml up
docker-compose -f zk-multiple-kafka-single.yml down
```


## Multiple Zookeeper / Multiple Kafka

If you want to have three zookeeper and two kafka brokers to experiment with production setup.

- Zookeeper will be available at `localhost:2181,localhost:2182,localhost:2183`
- Kafka will be available at `localhost:9092,localhost:9093`

Make sure to add to your `/etc/hosts` file
```
127.0.0.1     kafka1
127.0.0.1     kafka2
```

Run with:
```
docker-compose -f zk-multiple-kafka-multiple.yml up
docker-compose -f zk-multiple-kafka-multiple.yml down
```


## Full stack

 - Single Zookeeper: `localhost:2181`
 - Single Kafka: `localhost:9092`
 - Kafka Schema Registry: `localhost:8081`
 - Kafka Schema Registry UI: `localhost:8001`
 - Kafka Rest Proxy: `localhost:8082`
 - Kafka Topics UI: `localhost:8000`
 - Kafka Connect: `localhost:8083`
 - Kafka Connect UI: `localhost:8003`


 Make sure to add to your `/etc/hosts` file
 ```
 127.0.0.1     kafka1
 ```

 Run with:
 ```
 docker-compose -f full-stack.yml up
 docker-compose -f full-stack.yml down
 ```

# FAQ

## Kafka

Q: Kafka's log is too verbose, how can I reduce it?
A: Add the following line to your docker-compose environment variables: `KAFKA_LOG4J_LOGGERS: "kafka.controller=INFO,kafka.producer.async.DefaultEventHandler=INFO,state.change.logger=INFO"`. Full logging control can be accessed here: https://github.com/confluentinc/cp-docker-images/blob/master/debian/kafka/include/etc/confluent/docker/log4j.properties.template
