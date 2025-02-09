## https://docs.timescaledb.cn/self-hosted/latest/install/installation-source/
FROM bitnami/postgresql-repmgr:14.15.0
MAINTAINER handsomestWei <tadie666@163.com>
USER root
RUN apt-get update \
 && apt-get -y install \
    gcc cmake git clang-format clang-tidy openssl libssl-dev \
 && git clone https://github.com/timescale/timescaledb.git
RUN cd timescaledb \
 && git checkout 2.17.2 \
 && ./bootstrap -DREGRESS_CHECKS=OFF \
 && cd build \
 && make \
 && make install