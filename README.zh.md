# AI API 网关实战指南

> 从零搭建一个生产可用的 AI API 聚合网关，一个 Key 管所有国产大模型。

## 项目背景

管理多家 AI 模型 API 的痛点：

- 每个平台注册一遍，记一堆 Key
- 各家接口格式不统一，代码里改来改去
- 定价体系混乱，不好控制成本
- 没有一个地方能看到所有模型的调用量

本项目分享如何用开源方案搭建统一 API 网关，解决以上所有问题。

## 架构概览

```
用户请求 → Nginx (HTTPS) → One API 网关 → 多家模型供应商
                ↓
          控制台/统计
```

## 目录结构

```
├── README.md            ← 本文件
├── docs/
│   ├── deploy.md        ← 部署教程
│   ├── channels.md      ← 渠道接入指南
│   └── pricing.md       ← 定价方案参考
├── configs/
│   ├── nginx.conf       ← Nginx 配置（HTTPS + 反代）
│   └── one-api.service  ← Systemd 服务文件
└── scripts/
    ├── channel_health.sh ← 渠道健康检查
    └── balance_alert.sh  ← 余额预警
```

## 快速开始

### 前提条件

- 一台 Linux 服务器（推荐 2核2G 以上）
- 一个域名（可选，但推荐）
- 至少一个 AI 模型 API Key

### 一键部署

```bash
# 1. 安装 One API
bash <(curl -sL https://raw.githubusercontent.com/songquanpeng/one-api/main/install.sh)

# 2. 配置 Redis（可选但推荐）
apt install redis-server
systemctl enable redis-server
```

详细部署步骤见 [部署教程](docs/deploy.md)

### Nginx 配置参考

将项目中的 `configs/nginx.conf` 复制到 `/etc/nginx/sites-enabled/`，修改域名和 SSL 证书路径即可。

```nginx
# 核心配置摘要
server {
    listen 443 ssl http2;
    server_name your-domain.com;

    location /api/ {
        proxy_pass http://127.0.0.1:3000;
    }
    location /v1/ {
        proxy_pass http://127.0.0.1:3000;
    }
}
```

## 已接入渠道

| 供应商 | 类型 | 支持模型 |
|:-----|:----:|:--------|
| DeepSeek | 官方 API | deepseek-v4-flash, deepseek-v4-pro |
| 通义千问（阿里云） | 官方 API | qwen-turbo, qwen-plus, qwen-max |
| 智谱 GLM | 官方 API | glm-4-flash, glm-4-air, glm-4-plus |
| 豆包（火山方舟） | 官方 API | doubao 系列 |
| 硅基流动 | 第三方 | 多种开源模型 |
| 海外中转 | API2D / OpenRouter | GPT、Claude 等 |

## 渠道配置

不同供应商的渠道类型不同，配置方法见 [渠道接入指南](docs/channels.md)

## 监控与告警

生产环境建议定期检查渠道健康状态：

```bash
# 渠道健康检查（推荐每 10 分钟执行一次）
bash scripts/channel_health.sh

# 余额预警（每日执行）
bash scripts/balance_alert.sh
```

## 常见问题

**Q: One API 的 channel type 怎么看？**
A: type=36 是 DeepSeek，type=17 是通义千问，type=16 是智谱，type=44 是硅基流动。不同版本可能不同，以源码为准。

**Q: base_url 要不要带 /v1？**
A: 不要。gateway 会自动拼接，带上的话 URL 会变成 `/v1/v1/chat/completions`。

**Q: 模型价格不对怎么办？**
A: 检查 model_ratios 表，调整 ModelRatio 和 CompletionRatio。

## 相关资源

- [One API 官方仓库](https://github.com/songquanpeng/one-api)
- [New API（One API 分支）](https://github.com/Calcium-Ion/new-api)

---

*欢迎 Star、Fork、提 Issue。如果你需要一个现成的平台，也可以看看 [api-aiapi.cn](https://api-aiapi.cn)*
