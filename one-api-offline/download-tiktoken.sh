#!/bin/bash
# 在有外网的机器上执行，下载 tiktoken 文件

set -e
mkdir -p tiktoken_cache
cd tiktoken_cache

echo "下载 cl100k_base.tiktoken..."
curl -L -o 9b5ad71b2ce5302211f9c61530b329a4922fc6a4 \
  "https://openaipublic.blob.core.windows.net/encodings/cl100k_base.tiktoken"

echo "下载 o200k_base.tiktoken..."
curl -L -o fb374d419588a4632f3f557e76b4b70aebbca790 \
  "https://openaipublic.blob.core.windows.net/encodings/o200k_base.tiktoken"

echo "完成！文件已保存到 tiktoken_cache/"
ls -la
