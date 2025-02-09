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
    environment:
       # pg数据库密码
       - POSTGRESQL_PASSWORD=postgres
       # repmgr复制用的用户密码
       - REPMGR_PASSWORD=repmgr
       # 涉及网络的均填写物理机ip
       - REPMGR_PRIMARY_HOST=192.168.89.131
       - REPMGR_PARTNER_NODES=192.168.89.131,192.168.89.133:5432
       # 注意名称不能纯字母数字，要带短划线-等符号
       - REPMGR_NODE_NAME=pg-0
       - REPMGR_NODE_NETWORK_NAME=192.168.89.131
```

## postgresql数据库配置说明
原生`bitnami/postgresql-repmgr` docker镜像支持添加自定义配置文件，自动合并参数。配置位于容器内的`/bitnami/postgresql/postgresql.conf`文件，并指定`include_dir = 'conf.d'`   
因此在挂载了数据目录的基础上，将自定义配置文件挂载进去，创建`pg_custom.conf`文件，配置示例如下
```txt
## 该配置项必须，添加timescaledb时序数据库扩展
shared_preload_libraries = 'repmgr,timescaledb'

## 其他pg参数按需配置和调整
```

## repmgr使用说明
[镜像environment配置参考](https://github.com/bitnami/containers/tree/main/bitnami/postgresql-repmgr#environment-variables)   
[原生repmgr使用手册](https://www.repmgr.org/docs/5.5/index.html)   
`docker exec`进入容器后，默认使用`root`用户，使用`repmgr`命令需要先`su postgres`切换用户。

### 故障转移模式
`environment`配置项`REPMGR_FAILOVER`值
+ automatic 发生故障时自动切换主从。默认
+ manual 手动切换