CREATE CATALOG my_catalog WITH (
    'type'='paimon',
    'warehouse'='file:/tmp/paimon'
);

USE CATALOG my_catalog;

-- register a SqlServer table 'orders' in Flink SQL
CREATE TEMPORARY TABLE orders (
    id INT,
    type VARCHAR(45),
    qty INT,
    net_price DECIMAL(20, 10),
    status VARCHAR(10),
    ordered_at TIMESTAMP,
    completed_at TIMESTAMP,
    catalog_id VARCHAR(45),
    user_id VARCHAR(50),
    PRIMARY KEY (id) NOT ENFORCED
) WITH (
    'connector' = 'sqlserver-cdc',
    'hostname' = 'dev-ds-trm01.tailb6e5ab.ts.net',
    'port' = '1433',
    'username' = 'flink',
    'password' = 'flink',
    'database-name' = 'poc_db',
    'table-name' = 'lab.orders'
);

-- read snapshot and binlogs from orders table
SELECT * FROM orders;

CREATE TABLE paimon_orders (
                               id INT PRIMARY KEY NOT ENFORCED,
                               type VARCHAR(45),
                               qty INT,
                               net_price DECIMAL(20, 10),
                               status VARCHAR(10),
                               ordered_at TIMESTAMP,
                               completed_at TIMESTAMP,
                               catalog_id VARCHAR(45),
                               user_id VARCHAR(50)
);


SET 'execution.checkpointing.interval' = '5 s';


INSERT INTO paimon_orders SELECT * FROM orders;

SELECT * FROM paimon_orders;




-- to paimon

CREATE CATALOG my_catalog WITH (
    'type'='paimon',
    'warehouse'='file:/tmp/paimon'
);

USE CATALOG my_catalog;

CREATE TABLE paimon_users (
                              id INT PRIMARY KEY NOT ENFORCED,
                              name VARCHAR(50)
);


CREATE TEMPORARY TABLE users (
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

SELECT * FROM users;


SET 'execution.checkpointing.interval' = '5 s';


INSERT INTO paimon_users SELECT id, name FROM users;

SELECT * FROM paimon_users;




-- switch to streaming mode
SET 'execution.runtime-mode' = 'streaming';

-- track the changes of table and calculate the count interval statistics
SELECT `type`, SUM(qty) AS qty_total FROM paimon_orders GROUP BY `type`;

