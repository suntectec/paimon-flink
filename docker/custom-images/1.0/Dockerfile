# 使用官方 Flink 基础镜像
FROM flink:1.20.1-java11

# 复制你的 Flink Job JAR 到镜像中
COPY target/paimon-flink-1.0-SNAPSHOT.jar /opt/flink/usrlib/

# 设置默认环境变量（可被 docker-compose 覆盖）
ENV FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager\nparallelism.default: 2"