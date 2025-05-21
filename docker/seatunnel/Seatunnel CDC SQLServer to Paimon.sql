export AWS_ACCESS_KEY_ID=minioadmin
export AWS_SECRET_ACCESS_KEY=minioadmin



-- flink engine
echo '' > config/sqlserver2paimon.conf && vim config/sqlserver2paimon.conf

bin/start-seatunnel-flink-15-connector-v2.sh --config config/sqlserver2paimon.conf


-- zeta engine
echo '' > config/sqlserver2paimon.conf && vim config/sqlserver2paimon.conf

bin/seatunnel.sh -m local -c config/sqlserver2paimon.conf


-- zeta engine & docker run
docker run --rm -it apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c config/v2.batch.config.template
docker run --rm -it -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c /config/sqlserver2console.zeta.conf
docker run --rm -it -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c /config/sqlserver2paimon.zeta.conf
docker run --rm -it -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config apache/seatunnel:2.3.10 ./bin/seatunnel.sh -m local -c /config/fake2paimon.conf
docker run --rm -it \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/fake2paimon.conf

docker run --rm -it \
  -v /home/jagger.luo/projects/paimon-flink/docker/seatunnel/config/:/config \
  -v /home/jagger.luo/repo/paimon-s3-1.1.1.jar:/opt/seatunnel/lib/paimon-s3-1.1.1.jar \
  apache/seatunnel:2.3.10 \
  ./bin/seatunnel.sh -m local -c /config/fake2paimon.conf


CREATE CATALOG paimon_catalog WITH (
  'type'='paimon',
  'warehouse'='s3://warehouse/paimon',
  's3.endpoint'='http://minio:9000',
  's3.access-key'='minioadmin',
  's3.secret-key'='minioadmin',
  's3.path.style.access'='true'
);

USE CATALOG paimon_catalog;

USE paimon_db;

select count(*) from seatunnel_sqlserver_paimon_sink;
select * from seatunnel_sqlserver_paimon_sink;


SET 'execution.checkpointing.interval' = '5 s';

-- switch to streaming mode
SET 'execution.runtime-mode' = 'streaming';
-- use tableau result mode
SET 'sql-client.execution.result-mode' = 'tableau';

-- switch to batch mode
RESET 'execution.checkpointing.interval';
SET 'execution.runtime-mode' = 'batch';

SELECT id,order_id,supplier_id,item_id,qty FROM seatunnel_sqlserver_paimon_sink where id = 247048;

