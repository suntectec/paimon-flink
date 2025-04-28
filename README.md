# paimon-flink
paimon + flink

1.0版本：
完成测试 docker flink:1.20.1-java11：
  在控制台 docker run，启动 Session Mode 、启动 Application Mode 
    测试了包含flink官方提供的测试样例：$ ./bin/flink run ./examples/streaming/TopSpeedWindowing.jar 
    测试了包含编写的netcat nc -l -k -p 网络通信Demo项目：com.dev.flink_nc_demo1
完成测试 docker flink:1.20.1-java11：
  使用 docker-compose.xml 挂载jar包，启动 Application Mode （适用于开发/测试环境）
    测试了包含编写的netcat nc -l -k -p 网络通信Demo项目：com.dev.flink_nc_demo1
完成测试 jagger-flink-job:1.0 ：
  自定义 a custome Dockfile 镜像非挂载，不依赖挂载jar包，启动 Application Mode （使用于CI/CD或生产环境）

  
