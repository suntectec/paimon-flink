docker pull apache/seatunnel:2.3.10
docker run --rm -it apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c config/v2.batch.config.template
docker run --rm -it apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c config/v2.streaming.conf.template

# Example
# If you config file is in /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config
docker run --rm -it -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c /config/sqlserver2console.conf
docker run --rm -it -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c /config/sqlserver2paimon.zeta.conf
docker run --rm -it -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c /config/fake2paimon.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/sqlserver2console.batch.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/sqlserver2console.stream.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/fake2console.batch.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/fake2console.stream.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/fake2paimon.batch.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/fake2paimon.stream.conf

docker run --rm -it \
  --name test \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/sqlserver2paimon.stream1.conf

docker exec -it seatunnel-test bash

./bin/seatunnel.sh -m local -c /config/sqlserver2console.stream.conf
./bin/seatunnel.sh -m local -c /config/sqlserver2paimon.stream.conf
./bin/seatunnel.sh -m local -c /config/sqlserver2paimon.stream2.conf

#docker run --rm -it \
#  --name test \
#  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
#  -v /home/jagger.luo/plugins/mssql-jdbc-12.10.0.jre11.jar:/opt/seatunnel/lib/mssql-jdbc-12.10.0.jre11.jar \
#  apache/seatunnel:2.3.10 \
#  ./bin/seatunnel.sh -m local -c /config/sqlserver2console.conf


#docker run --rm -it \
#  --name test \
#  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
#  -v /home/jagger.luo/plugins/paimon-s3-1.1.1.jar:/opt/seatunnel/lib/paimon-s3-1.1.1.jar \
#  apache/seatunnel:2.3.10 \
#  ./bin/seatunnel.sh -m local -c /config/fake2paimon.conf


docker run -itd \
  --name seatunnel-lab \
  -v ~/seatunnel-lab/config:/opt/seatunnel/config \
  -v ~/seatunnel-lab/logs:/opt/seatunnel/logs \
  -e FLINK_HOME=/opt/flink \
  -e FLINK_MASTER="flink-jobmanager:8081" \
  apache/seatunnel:2.3.10

./bin/seatunnel.sh --config /opt/seatunnel/config/v2.streaming.conf.template \
  --mode flink \
  --flink-master flink-jobmanager:8081 \
  --flink-run-mode cluster
  --network app_network


./bin/seatunnel.sh --config /opt/seatunnel/config/v2.streaming.conf.template \
  --mode flink \
  --flink-master dev-ds-trm01.tailb6e5ab.ts.net:8081 \
  --flink-run-mode cluster
  --network app_network



  # 进入 Flink JobManager 容器（或主机）
docker ps | grep jobmanager
curl http://flink-jobmanager:8081  # 应返回 Flink Web UI


docker run -it --name seatunnel \
  --network flink-net \
  -v ~/seatunnel-lab/config:/opt/seatunnel/config \
  apache/seatunnel:2.3.10


# 2. 启动 SeaTunnel 并提交作业
docker run -it --name seatunnel \
  --network flink-net \
  -v /your/config:/opt/seatunnel/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh --config /opt/seatunnel/config/your_config.conf \
    --mode flink \
    --flink-master flink-jobmanager:8081 \
    --flink-run-mode cluster


./bin/seatunnel.sh --config /opt/seatunnel/config/v2.streaming.conf.template \
  --mode flink \
  --flink-master flink-jobmanager:8081 \
  --flink-run-mode cluster
  --network app_network
