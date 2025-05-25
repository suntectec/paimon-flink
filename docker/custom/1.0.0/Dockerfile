# 使用官方 Flink 基础镜像
FROM flink:1.20.1-java11

# 下载 Paimon 相关 JAR 文件
# 注意：请根据你的 Flink 版本和 Paimon 版本调整下载链接
RUN mkdir -p /opt/flink/plugins/paimon && \
    wget -P /opt/flink/plugins/paimon/ https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-flink-1.20/1.0.1/paimon-flink-1.20-1.0.1.jar && \
    wget -P /opt/flink/plugins/paimon/ https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-flink-action/0.7/paimon-flink-action-0.7.jar && \
    wget -P /opt/flink/plugins/paimon/ https://repo.maven.apache.org/maven2/org/apache/paimon/paimon-hive/0.7/paimon-hive-0.7.jar && \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/hadoop/hadoop-common/3.3.6/hadoop-common-3.3.6.jar && \
    wget -P /opt/flink/lib/ https://repo.maven.apache.org/maven2/org/apache/hadoop/hadoop-client/3.3.6/hadoop-client-3.3.6.jar

# 复制你的 Flink Job JAR 到镜像中
COPY target/paimon-flink-1.0-SNAPSHOT.jar /opt/flink/usrlib/

# 设置默认环境变量（可被 docker-compose 覆盖）
ENV FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager\nparallelism.default: 2"