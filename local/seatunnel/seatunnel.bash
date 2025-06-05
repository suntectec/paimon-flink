local:

/opt/apache-seatunnel-2.3.10/bin/seatunnel.sh \
-m local \
-c /home/Data.Eng/jagger/local/seatunnel/config/kafka2paimon.protobuf.stream.conf


CREATE CATALOG paimon_catalog WITH (
  'type'='paimon',
  'warehouse'='s3a://warehouse/paimon/seatunnel/',
  's3.endpoint'='http://minio:9000',
  's3.access-key'='minioadmin',
  's3.secret-key'='minioadmin',
  's3.path.style.access'='true'
);

USE CATALOG paimon_catalog;

USE paimon;

select count(*) from order_protobuf_format;
select * from order_protobuf_format;

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

