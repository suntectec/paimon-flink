docker exec -it paimon-kafka-broker bash

/opt/kafka/bin/kafka-topics.sh --bootstrap-server localhost:9092 --list

/opt/kafka/bin/kafka-topics.sh --create --topic test-topic --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1


/opt/kafka/bin/kafka-consumer-groups.sh \
  --bootstrap-server localhost:9092 \
  --list

/opt/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server localhost:9092 \
  --topic test-topic \
  --group test-group


/opt/kafka/bin/kafka-console-producer.sh \
  --bootstrap-server localhost:9092 \
  --topic test-topic


/opt/kafka/bin/kafka-console-consumer.sh \
  --bootstrap-server 192.168.138.15:9092 \
  --topic test-topic \
  --from-beginning
# ---------------------------------------------------------------------------------


docker pull apache/seatunnel:2.3.10
docker run --rm -it apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c config/v2.batch.config.template
docker run --rm -it apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c config/v2.streaming.conf.template

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/sqlserver2paimon.stream.conf

docker exec -it paimon-seatunnel bash

./bin/seatunnel.sh -m local -c /config/kafka2console.batch.conf

