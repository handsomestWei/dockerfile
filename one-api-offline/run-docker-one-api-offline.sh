#!/bin/bash
# 运行离线版 One-API

docker stop one-api 2>/dev/null || true
docker rm one-api 2>/dev/null || true

docker run --name one-api -d --restart always -p 8300:3000 \
  -e TZ=Asia/Shanghai \
  -v ./data:/data \
  one-api-offline:latest

echo "启动完成，访问 http://localhost:8300"
echo "默认账号: root / 123456"
