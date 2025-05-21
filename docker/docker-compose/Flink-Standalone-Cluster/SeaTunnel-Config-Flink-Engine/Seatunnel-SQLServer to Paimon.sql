export AWS_ACCESS_KEY_ID=minioadmin
export AWS_SECRET_ACCESS_KEY=minioadmin

echo '' > config/sqlserver2paimon.conf && vim config/sqlserver2paimon.conf


-- flink engine
bin/start-seatunnel-flink-15-connector-v2.sh --config config/sqlserver2paimon.conf
-- zeta engine
bin/seatunnel.sh -m local -c config/sqlserver2paimon.conf



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

