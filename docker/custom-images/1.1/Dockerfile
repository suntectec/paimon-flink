# 生产环境建议做增强，扩展Dockerfile，提高可靠性
FROM flink:1.20.1-java11

# 安装额外依赖（如 Python 或系统工具）
RUN apt-get update && apt-get install -y python3

# 复制 JAR 和配置文件
COPY target/paimon-flink-1.0-SNAPSHOT.jar /opt/flink/usrlib/
# COPY conf/flink-conf.yaml /opt/flink/conf/

# 设置健康检查
HEALTHCHECK --interval=10s CMD curl -f http://localhost:8081 || exit 1

# 固定时区（中国时区示例）
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime