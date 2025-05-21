-- load AWS credentials from environment variables AWS KEY
export AWS_ACCESS_KEY_ID=minioadmin
export AWS_SECRET_ACCESS_KEY=minioadmin

DROP CATALOG paimon_catalog;
-- 创建 Paimon 目录
CREATE CATALOG paimon_catalog WITH (
  'type'='paimon',
  'warehouse'='s3://warehouse/paimon',
  's3.endpoint'='http://minio:9000',
  's3.access-key'='minioadmin',
  's3.secret-key'='minioadmin',
  's3.path.style.access'='true'
);

USE CATALOG paimon_catalog;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS paimon_db;
USE paimon_db;

-- register a SqlServer table in Flink SQL
CREATE TEMPORARY TABLE sqlserver_paimon_source (
    id BIGINT,
    order_id VARCHAR(36),
    supplier_id INT,
    item_id INT,
    status VARCHAR(20),
    qty INT,
    net_price INT,
    issued_at TIMESTAMP,
    completed_at TIMESTAMP,
    spec VARCHAR(1024),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'sqlserver-cdc',
    'hostname' = 'dev-ds-trm01.tailb6e5ab.ts.net',
    'port' = '1433',
    'username' = 'sa',
    'password' = 'StrongPassword123!',
    'database-name' = 'inventory',
    'table-name' = 'INV.orders'
);

-- read snapshot and binlogs from table
SELECT * FROM sqlserver_paimon_source;

SELECT count(*) FROM sqlserver_paimon_source;


CREATE TABLE IF NOT EXISTS sqlserver_paimon_sink (
    id BIGINT,
    order_id VARCHAR(36),
    supplier_id INT,
    item_id INT,
    status VARCHAR(20),
    qty INT,
    net_price INT,
    issued_at TIMESTAMP,
    completed_at TIMESTAMP,
    spec VARCHAR(1024),
    created_at TIMESTAMP,
    updated_at TIMESTAMP,
    PRIMARY KEY (id) NOT ENFORCED
);


SET 'execution.checkpointing.interval' = '5 s';


INSERT INTO sqlserver_paimon_sink SELECT * FROM sqlserver_paimon_source;

SELECT * FROM sqlserver_paimon_sink;

SELECT * FROM sqlserver_paimon_sink order by created_at desc;

SELECT count(*) FROM sqlserver_paimon_sink;

SELECT id,order_id,supplier_id,qty FROM sqlserver_paimon_sink where id in (1,40);




-- switch to streaming mode
SET 'execution.runtime-mode' = 'streaming';
-- use tableau result mode
SET 'sql-client.execution.result-mode' = 'tableau';

-- switch to batch mode
RESET 'execution.checkpointing.interval';
SET 'execution.runtime-mode' = 'batch';

-- track the changes of table and calculate the count interval statistics
SELECT `status`, SUM(qty) AS qty_total FROM sqlserver_paimon_sink GROUP BY `status`;

