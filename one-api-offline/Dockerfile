# One-API 离线部署镜像 - 将 tiktoken 文件打包进镜像，不依赖卷挂载
FROM justsong/one-api:latest

# 创建 tiktoken 缓存目录并复制文件
RUN mkdir -p /app/tiktoken_cache
COPY tiktoken_cache/ /app/tiktoken_cache/
RUN chmod -R 755 /app/tiktoken_cache

# 设置环境变量（镜像内生效，无需挂载）
ENV TIKTOKEN_CACHE_DIR=/app/tiktoken_cache
