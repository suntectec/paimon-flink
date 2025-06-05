-- load AWS credentials from environment variables AWS KEY
export AWS_ACCESS_KEY_ID=minioadmin
export AWS_SECRET_ACCESS_KEY=minioadmin

DROP CATALOG paimon_catalog;
-- 创建目录
CREATE CATALOG paimon_catalog WITH (
  'type'='paimon',
  'warehouse'='s3://sqlserver/flinkcdc/',
  's3.endpoint'='http://minio:9000',
  's3.access-key'='minioadmin',
  's3.secret-key'='minioadmin',
  's3.path.style.access'='true'
);

USE CATALOG paimon_catalog;

CREATE DATABASE IF NOT EXISTS paimon;

USE paimon;

-- register a SqlServer table in Flink SQL
CREATE TEMPORARY TABLE sqlserver_source (
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
SELECT * FROM sqlserver_source;

SELECT count(*) FROM sqlserver_source;


CREATE TABLE IF NOT EXISTS orders (
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


INSERT INTO orders SELECT * FROM sqlserver_source;

SELECT * FROM orders;
SELECT count(*) FROM orders;

SELECT * FROM orders order by created_at desc;

SELECT id,order_id,supplier_id,qty FROM orders where id in (1,40);

-- switch to streaming mode
SET 'execution.runtime-mode' = 'streaming';
-- use tableau result mode
SET 'sql-client.execution.result-mode' = 'tableau';

-- switch to batch mode
RESET 'execution.checkpointing.interval';
SET 'execution.runtime-mode' = 'batch';

-- track the changes of table and calculate the count interval statistics
SELECT `status`, SUM(qty) AS qty_total FROM orders GROUP BY `status`;



-- Way 2 - Not Catalog
CREATE TABLE sqlserver_source (
                                  id INT,
                                  name VARCHAR(50),
                                  PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'sqlserver-cdc',
      'hostname' = 'dev-ds-trm01.tailb6e5ab.ts.net',
      'port' = '1433',
      'username' = 'flink',
      'password' = 'flink',
      'database-name' = 'poc_db',
      'table-name' = 'lab.users'
      );

CREATE TABLE orders (
                             id INT,
                             name VARCHAR(50),
                             PRIMARY KEY (id) NOT ENFORCED
) WITH (
      'connector' = 'paimon',
      'path' = 'file:///tmp/paimon/warehouse',
      'auto-create' = 'true'
      );

INSERT INTO orders SELECT * FROM sqlserver_source;

SET 'execution.checkpointing.interval' = '5 s';

-- read
SELECT * FROM sqlserver_source;
SELECT * FROM orders;