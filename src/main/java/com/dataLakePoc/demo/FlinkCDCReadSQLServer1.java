package com.dataLakePoc.demo;

import org.apache.flink.cdc.connectors.sqlserver.SqlServerSource;
import org.apache.flink.cdc.debezium.JsonDebeziumDeserializationSchema;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.streaming.api.functions.source.SourceFunction;

public class FlinkCDCReadSQLServer1 {
    public static void main(String[] args) throws Exception {
        SourceFunction<String> sourceFunction = SqlServerSource.<String>builder()
                .hostname("dev-ds-trm01.tailb6e5ab.ts.net")
                .port(1433)
                .database("poc_db")
                .tableList("lab.orders")
                .username("flink")
                .password("flink")
                .deserializer(new JsonDebeziumDeserializationSchema()) // converts SourceRecord to JSON String
                .build();

        StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        env
                .addSource(sourceFunction)
                .print().setParallelism(1); // use parallelism 1 for sink to keep message ordering

        env.execute();

    }
}
