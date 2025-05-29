local:

/opt/apache-seatunnel-2.3.10/bin/seatunnel.sh -m local \
-c /home/jagger.luo/projects/paimon-flink/docker/practice/kafka-seatunnel/config/kafka2paimon.stream.conf



CREATE CATALOG paimon_catalog WITH (
  'type'='paimon',
  'warehouse'='s3://tmp/kafka/seatunnel',
  's3.endpoint'='http://minio:9000',
  's3.access-key'='minioadmin',
  's3.secret-key'='minioadmin',
  's3.path.style.access'='true'
);

USE CATALOG paimon_catalog;

USE _test;

select count(*) from order_json_format_test;
select * from order_json_format_test;

# org.apache.flink.table.api.TableException: Column 'id' is NOT NULL, however, a null value is being written into it. You can set job configuration 'table.exec.sink.not-null-enforcer'='DROP' to suppress this exception and drop such records silently.
set 'table.exec.sink.not-null-enforcer'='DROP';


SET 'execution.checkpointing.interval' = '5 s';

-- switch to streaming mode
SET 'execution.runtime-mode' = 'streaming';
-- use tableau result mode
SET 'sql-client.execution.result-mode' = 'tableau';

-- switch to batch mode
RESET 'execution.checkpointing.interval';
SET 'execution.runtime-mode' = 'batch';

SELECT id,order_id,supplier_id,item_id,qty FROM seatunnel_sqlserver_paimon_sink where id = 247048;

