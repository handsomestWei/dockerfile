# openjdk-arthas镜像使用

## 使用示例
### docker compose镜像使用示例
```yml
java:
    image: wjy2020/openjdk-arthas:jdk8
    container_name: java
    restart: always
    privileged: true
    volumes:
      - /etc/localtime:/etc/localtime
    environment:
      TZ: ${TZ}
      CLASSPATH: ${MNT_JAVA_WORK_DIR}/bin
    entrypoint: java -jar -Dfile.encoding=utf-8 ${MNT_JAVA_WORK_DIR}/bin/server.jar -Xms6g -Xmx6g --spring.config.location=${MNT_JAVA_WORK_DIR}/config/application.yml
```

### 使用arthas监测容器内java进程
[arthas使用参考](https://arthas.aliyun.com/doc/)   
```sh
docker exec -it <容器id/名称> /bin/bash -c "java -jar /opt/arthas/arthas-boot.jar"
```