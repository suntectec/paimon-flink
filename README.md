# Paimon-Flink DevOps Lab 

## 1. Docker 基础镜像测试 (flink:1.20.1-java11)

### 1.1 Session Mode 测试
- 启动方式：通过 `docker run` 命令直接启动
- 测试用例：
  - Flink 官方示例程序:  
    `./bin/flink run ./examples/streaming/TopSpeedWindowing.jar`
  - 自定义 Netcat 网络通信 Demo:  
    `com.devOpsLab.flink_nc_demo1`

### 1.2 Application Mode 测试
- 启动方式：通过 `docker run` 命令直接启动
- 测试用例：
  - 自定义 Netcat 网络通信 Demo:  
    `com.devOpsLab.flink_nc_demo1`

### 1.3 Docker Compose 集成测试
- 启动方式：使用 `docker-compose.xml` 挂载 JAR 包
- 运行模式：Application Mode
- 适用场景：开发/测试环境
- 测试用例：
  - 自定义 Netcat 网络通信 Demo:  
    `com.devOpsLab.flink_nc_demo1`

## 2. 自定义镜像测试 (jagger-flink-job:1.0)

### 2.1 Application Mode 生产级部署
- 镜像构建：使用自定义 Dockerfile
- 部署特点：
  - 非挂载方式（JAR 包内置于镜像）
  - 不依赖外部挂载卷
- 适用场景：CI/CD 流水线或生产环境

## 3. paimon flink

### 3.1 paimon add to flink 1.1.1
- flink镜像加入paimon
