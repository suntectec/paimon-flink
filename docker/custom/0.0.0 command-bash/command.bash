docker run \
    --mount type=bind,src=/home/jagger.luo/projects/paimon-flink/target/paimon-flink-1.0-SNAPSHOT.jar,target=/opt/flink/usrlib/paimon-flink.jar \
    --rm \
    --env FLINK_PROPERTIES="jobmanager.rpc.address: jobmanager" \
    --name=jobmanager \
    --network flink-network \
    flink:1.20.1-java11 standalone-job \
    --job-classname com.dev.flink_nc_demo1
