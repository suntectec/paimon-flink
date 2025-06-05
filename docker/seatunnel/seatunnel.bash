docker exec -it seatunnel-test bash

# flink engine
bin/start-seatunnel-flink-15-connector-v2.sh -c /config/sqlserver2paimon.stream.conf

# zeta engine
bin/seatunnel.sh -m local -c /config/sqlserver2paimon.stream.conf


CREATE CATALOG paimon_catalog WITH (
  'type'='paimon',
  'warehouse'='s3://sqlserver/seatunnel/paimon/zeta',
  's3.endpoint'='http://minio:9000',
  's3.access-key'='minioadmin',
  's3.secret-key'='minioadmin',
  's3.path.style.access'='true'
);

USE CATALOG paimon_catalog;

USE inventory;

SELECT * FROM orders_test;

SELECT count(*) FROM orders_test;


SET 'execution.checkpointing.interval' = '5 s';
