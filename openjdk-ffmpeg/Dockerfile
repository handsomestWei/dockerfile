## Debian 11 && openjdk8 && ffmpeg 4.3.8
FROM openjdk:8-jre
MAINTAINER handsomestWei <tadie666@163.com>

ENV FFMPEG_VERSION=7:4.3.8-0+deb11u1

RUN apt-get update && \
    apt-get install -y ffmpeg=${FFMPEG_VERSION} && \
	apt-get clean && \
    rm -rf /var/lib/apt/lists/*