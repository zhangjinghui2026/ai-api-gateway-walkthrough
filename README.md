# AI API Gateway Walkthrough

> Build a production-ready AI API aggregation gateway from scratch. One key to rule all Chinese LLMs.

## Why This Project

Managing multiple AI model APIs is painful:

- Register on every platform, keep track of dozens of API keys
- Each provider has its own API format — your code becomes a mess
- Pricing systems are confusing, hard to control costs
- No single dashboard to see all your model usage

This project shares how to build a unified API gateway using open-source solutions to solve all of the above.

## Architecture

```
User Request → Nginx (HTTPS) → One API Gateway → Multiple Model Providers
                   ↓
            Dashboard / Analytics
```

## Directory Structure

```
├── README.md              ← This file (English)
├── README.zh.md           ← Chinese version
├── docs/
│   ├── deploy.md          ← Deployment guide (Chinese)
│   └── channels.md        ← Channel setup guide (Chinese)
├── configs/
│   ├── nginx.conf         ← Nginx config (HTTPS + reverse proxy)
│   └── one-api.service    ← Systemd service file
└── scripts/
    ├── channel_health.sh  ← Channel health checker
    └── balance_alert.sh   ← Balance alert script
```

## Quick Start

### Prerequisites

- A Linux server (2 vCPU / 2GB RAM recommended)
- A domain name (optional but recommended)
- At least one AI model API key

### One-Click Deploy

```bash
bash <(curl -sL https://raw.githubusercontent.com/songquanpeng/one-api/main/install.sh)
```

Full deployment guide: [docs/deploy.md](docs/deploy.md) (Chinese)

## Supported Providers

| Provider | Type | Models |
|:---------|:----:|:-------|
| **DeepSeek** | Official API | deepseek-v4-flash, deepseek-v4-pro |
| **Qwen (Alibaba Cloud)** | Official API | qwen-turbo, qwen-plus, qwen-max |
| **GLM (Zhipu AI)** | Official API | glm-4-flash *(free)*, glm-4-air, glm-4-plus |
| **Doubao (ByteDance)** | Official API | doubao series |
| **SiliconFlow** | Third-party | Various open-source models |
| **Overseas relay** | API2D / OpenRouter | GPT, Claude, Gemini |

## Pricing Comparison

| Model | Input Price (per 1M tokens) | Output Price (per 1M tokens) |
|:------|:--------------------------:|:---------------------------:|
| deepseek-v4-flash | ¥0.5 (~$0.07) | ¥2.0 (~$0.28) |
| qwen-turbo | ¥0.3 (~$0.04) | ¥0.6 (~$0.08) |
| qwen-plus | ¥0.8 (~$0.11) | ¥2.0 (~$0.28) |
| glm-4-flash | **Free** | **Free** |
| glm-4-plus | ¥10 (~$1.39) | ¥10 (~$1.39) |
| qwen-max | ¥10 (~$1.39) | ¥30 (~$4.17) |

**Vs GPT-4o**: GPT-4o costs ~$2.50/1M input and ~$10/1M output. Chinese LLMs are **10-60x cheaper** while delivering comparable quality.

## Why Chinese LLMs?

- **Cost**: 10-60x cheaper than GPT-4o/Claude
- **Code**: DeepSeek V4 Flash performs on par with GPT-4o in coding tasks
- **Chinese**: Native-level Chinese understanding (obviously)
- **Math & Reasoning**: Competitive with top-tier models

## Monitoring

For production use, schedule health checks:

```bash
# Check channel health every 10 minutes
bash scripts/channel_health.sh

# Check balances daily
bash scripts/balance_alert.sh
```

## Channels

Channel type reference, model mappings, and provider-specific configs: [docs/channels.md](docs/channels.md) (Chinese)

## Quick Tips

- **`base_url`**: Do NOT include `/v1`. The gateway appends it automatically.
- **Channel types**: DeepSeek=36, Qwen=17, GLM=16, SiliconFlow=44
- **Ability table**: After adding a channel, refresh the abilities cache or restart the service.
- **Model mapping**: Use `model_mapping` JSON field to alias model names.

## Resources

- [One API (official)](https://github.com/songquanpeng/one-api)
- [New API (fork)](https://github.com/Calcium-Ion/new-api)
- [DeepSeek Platform](https://platform.deepseek.com)
- [Alibaba Cloud Model Studio](https://help.aliyun.com/zh/model-studio)
- [Zhipu AI Open Platform](https://open.bigmodel.cn)

---

## 🚀 One Key, 50+ Models — Try the Live Platform

If you don't want to build your own gateway, just use ours:

> **🌐 [api-aiapi.cn](https://api-aiapi.cn) — One API Key to call 50+ models**
>
> DeepSeek / Qwen / GLM / Doubao / GPT / Claude / Gemini — all with one Key.
> Free trial available, no deployment needed.

### Quick Test

```bash
curl https://api-aiapi.cn/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_KEY" \
  -d '{"model": "qwen-turbo", "messages": [{"role": "user", "content": "Hello!"}]}'
```

---

## 📝 Read More on CSDN

Technical deep dives and real-world ops notes:

- [AI API聚合平台从零到营收](https://blog.csdn.net/2601_96194608/article/details/161490478) — 一个Key调50+模型
- [国产AI API省钱指南](https://blog.csdn.net/2601_96194608/article/details/161572251) — 价格差60倍怎么选？
- [从零部署到100用户运维实录](https://blog.csdn.net/2601_96194608/article/details/161828523) — 真实踩坑记录
- [API Key安全防护全攻略](https://blog.csdn.net/2601_96194608/article/details/161632604) — 被入侵后的复盘

---

*Star, fork, and PRs welcome. If you want a ready-to-use platform, check out [api-aiapi.cn](https://api-aiapi.cn)*