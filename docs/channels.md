# 渠道接入指南

## 渠道类型对照表

| 供应商 | Type | 官方文档 |
|:-----|:----:|:--------|
| DeepSeek | 36 | https://platform.deepseek.com |
| 通义千问（阿里云） | 17 | https://help.aliyun.com/zh/model-studio |
| 智谱 GLM | 16 | https://open.bigmodel.cn |
| 硅基流动 | 44 | https://siliconflow.cn |
| 豆包（火山方舟） | 41 | https://console.volcengine.com/ark |
| 腾讯混元 | 未知 | https://console.cloud.tencent.com/hunyuan |
| 百度文心 | 未知 | https://yiyan.baidu.com |

> 注意：One API 的 channel type 从 iota 0 开始计数，不同版本可能有差异，以源码为准。

## DeepSeek 配置

| 字段 | 值 |
|:----|:----|
| 类型 | 36 |
| 名称 | DeepSeek |
| 密钥 | 申请的 API Key |
| 分组 | default |

支持模型：deepseek-v4-flash, deepseek-v4-pro, deepseek-reasoner

## 通义千问配置

| 字段 | 值 |
|:----|:----|
| 类型 | 17 |
| 名称 | 通义千问 |
| base_url | https://dashscope.aliyuncs.com |
| 密钥 | 阿里云 DashScope 的 API Key |
| 分组 | default |

支持模型：qwen-turbo, qwen-plus, qwen-max, qwen2.5-72b-instruct

## 智谱 GLM 配置

| 字段 | 值 |
|:----|:----|
| 类型 | 16 |
| 名称 | 智谱GLM |
| base_url | https://open.bigmodel.cn |
| 密钥 | 智谱 API Key |
| 分组 | default, free_user |

支持模型：glm-4-flash, glm-4-air, glm-4-plus

> 提示：glm-4-flash 目前免费不限量，适合分配给免费用户组。

## 渠道常见问题

### 渠道显示不可用
添加渠道后需要检查 ability 表是否已更新，可以：
```bash
sqlite3 one-api.db "DELETE FROM abilities;"
```
然后重启 One API 即可自动重建 ability 表。

### base_url 怎么填
如果官方 API 地址是 `https://api.deepseek.com/v1/chat/completions`，则 base_url 填 `https://api.deepseek.com`，不要带 `/v1`。

### 模型名称映射
如果本地模型名和供应商的名称不同，可以用 model_mapping 做映射：
```json
{
  "本地名": "供应商名"
}
```
