# kafka-stack-docker-compose

This replicates as well as possible real deployment configurations, where you have your zookeeper servers and kafka servers actually all distinct from each other. This solves all the networking hurdles that comes with docker-compose, and is compatible cross platform. It only requires an update to your host files.

## Stack version

 - Zookeeper version: 3.4.9
 - Kafka version: 0.10.1.0

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
 - Kafka Rest Proxy: `localhost:8082`
 - Kafka Topics UI: `localhost:8000`


 Make sure to add to your `/etc/hosts` file
 ```
 127.0.0.1     kafka1
 ```

 Run with:
 ```
 docker-compose -f full-stack.yml up
 docker-compose -f full-stack.yml down
 ```
