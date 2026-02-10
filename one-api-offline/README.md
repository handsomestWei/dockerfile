# One-API 内网离线部署

**原理**：将 tiktoken 文件打包进 Docker 镜像，不依赖卷挂载，避免 Windows/Docker 路径问题。

## 为什么需要 tiktoken？里面有什么？

One-API 在统计用量、计费、限流时需要按 **token 数** 计算（例如：用户发了多少 token、模型回了多少 token）。  
这些统计依赖 OpenAI 官方的 **tiktoken** 分词器，才能和 OpenAI 接口的计费方式一致。

tiktoken 的“文件”本质是 **BPE 词表编码数据**（如 `cl100k_base.tiktoken`、`o200k_base.tiktoken`）：  
里面是「文本片段 → 整数 id」的映射数据，用来把一句话拆成 token 并数个数。  
不同模型用不同词表：GPT-3.5/GPT-4 用 `cl100k_base`，GPT-4o 用 `o200k_base`。  
One-API 启动时会按需加载这些文件；在内网/离线环境下无法从外网下载，就会报错，因此需要提前把对应文件放进镜像或挂载目录。

---

## 步骤一：有外网时准备（只需做一次）

```bash
cd one-api-offline

# 1. 下载 tiktoken 文件
bash download-tiktoken.sh

# 2. 构建镜像（tiktoken 已打包进镜像）
docker build -t one-api-offline:latest .

# 3. 可选：导出镜像供内网使用
docker save one-api-offline:latest -o one-api-offline.tar
# 拷贝 one-api-offline.tar 到内网机器后：docker load -i one-api-offline.tar
```

## 步骤二：运行

```bash
# 确保 data 目录存在
mkdir -p data

# 启动
bash run.sh

# 或手动：
docker run --name one-api -d --restart always -p 8300:3000 \
  -e TZ=Asia/Shanghai \
  -v ./data:/data \
  one-api-offline:latest
```

## 步骤三：验证

```bash
docker logs one-api
# 应看到 "token encoders initialized" 无 FATAL 错误

# 访问 http://localhost:8300
# 默认账号 root / 123456
```

## 与官方镜像的区别

| 项目 | 官方镜像 | 本方案 |
|------|----------|--------|
| tiktoken | 需挂载/环境变量 | 已打包进镜像 |
| 内网启动 | 易失败 | 可直接启动 |
| 卷挂载 | 依赖 TIKTOKEN_CACHE_DIR | 仅需 data 目录 |
