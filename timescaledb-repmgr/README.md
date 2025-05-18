# timescaladb时序数据库高可用docker镜像使用
[timescaladb时序数据库高可用](https://hub.docker.com/r/wjy2020/timescaledb-repmgr)，基于[bitnami/postgresql-repmgr](https://hub.docker.com/r/bitnami/postgresql-repmgr) docker镜像制作，实现数据同步和故障自动转移主备切换。

## 使用示例
[参考](https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr)，附docker compose配置例。
```yml
pg-0:
    image: wjy2020/timescaledb-repmgr:pg14.15-ts2.17.2
    container_name: "pg0"
    restart: always
    ports:
      - 5432:5432
    volumes:
       # 以下三个挂载必须
       # 挂载数据目录
       - /xxx/pg-data:/bitnami/postgresql
       # 在挂载了数据目录的基础上，将自定义配置文件挂载进去
       - /xxx/pg-data/conf/conf.d/pg_custom.conf:/bitnami/postgresql/conf/conf.d/pg_custom.conf
       - /xxx/pg-log:/opt/bitnami/postgresql/logs
       # 将repmgr守护进程pid文件挂载出来
       - ${DATA_PATH}/postgres/pg-tmp:/tmp
    environment:
       # pg数据库密码
       - POSTGRESQL_PASSWORD=postgres
       # repmgr复制用的用户密码
       - REPMGR_PASSWORD=repmgr
       # 涉及网络的均填写物理机ip
       # 本节点ip
       - REPMGR_PRIMARY_HOST=192.168.89.131
       # 所有节点ip
       - REPMGR_PARTNER_NODES=192.168.89.131,192.168.89.133:5432
       # 注意名称不能纯字母数字，要带短划线-等符号
       - REPMGR_NODE_NAME=pg-0
       # 本节点ip
       - REPMGR_NODE_NETWORK_NAME=192.168.89.131
```
对端`pg-1`配置类似。先启动的是主节点。后启动的都是备节点，会自动加入集群。

## postgresql数据库配置说明
原生`bitnami/postgresql-repmgr` docker镜像支持添加自定义配置文件，自动合并参数。配置位于容器内的`/bitnami/postgresql/postgresql.conf`文件，并指定`include_dir = 'conf.d'`   
因此在挂载了数据目录的基础上，将自定义配置文件挂载进去，创建`pg_custom.conf`文件，配置示例如下
```txt
## 该配置项必须，添加timescaledb时序数据库扩展
shared_preload_libraries = 'repmgr,timescaledb'

# TimescaleDB收集匿名使用数据，以帮助我们更好地了解和协助我们的用户。
# timescaledb.telemetry_level=basic
# 禁用遥测。也可能是钓鱼
timescaledb.telemetry_level=off

## 其他pg参数按需配置和调整
```

## repmgr使用说明
[镜像environment配置参考](https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#environment-variables)   
[原生repmgr使用手册](https://www.repmgr.org/docs/5.5/index.html)   
`docker exec`进入容器后，默认使用`root`用户，使用`repmgr`命令需要先`su postgres`切换用户。

### 镜像内repmgr目录
+ 根目录 `/opt/bitnami/repmgr`
+ 配置文件 `/opt/bitnami/repmgr/conf/repmgr.conf`，会自动生成
+ 守护进程文件 `/tmp/repmgrd.pid`

### 故障转移模式配置
`environment`配置项`REPMGR_FAILOVER`值
+ automatic 发生故障时自动切换主从。默认
+ manual 手动切换

## 脑裂处理
参考[pg数据库repmgr主备双节点见证者方案](https://handsomestwei.github.io/posts/pg%E6%95%B0%E6%8D%AE%E5%BA%93repmgr%E4%B8%BB%E5%A4%87%E5%8F%8C%E8%8A%82%E7%82%B9%E8%A7%81%E8%AF%81%E8%80%85%E6%96%B9%E6%A1%88/)