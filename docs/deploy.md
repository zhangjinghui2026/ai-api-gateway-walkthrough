# 部署教程

## 环境要求

- 操作系统：Ubuntu 20.04+ / CentOS 7+
- 配置：最低 1核1G，推荐 2核2G
- 需安装：curl、wget、git

## 第一步：安装 One API

### 方式一：一键安装（推荐）

```bash
bash <(curl -sL https://raw.githubusercontent.com/songquanpeng/one-api/main/install.sh)
```

安装完成后访问 `http://your-server:3000`，默认账号 `root`，密码 `123456`。

### 方式二：手动安装

```bash
# 下载最新版本
wget https://github.com/songquanpeng/one-api/releases/latest/download/one-api-linux-amd64.tar.gz
tar -xzf one-api-linux-amd64.tar.gz
chmod +x one-api

# 运行
./one-api --port 3000 --log-dir ./logs
```

## 第二步：配置 Redis（可选但推荐）

```bash
apt install redis-server -y
systemctl enable redis-server
systemctl start redis-server
```

然后在 One API 的环境变量中配置：
```
REDIS_CONN_STRING=redis://localhost:6379
SYNC_FREQUENCY=60
```

## 第三步：配置 systemd 服务

将项目中的 `one-api.service` 复制到系统目录：

```bash
cp configs/one-api.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable one-api
systemctl start one-api
```

## 第四步：配置 Nginx 反代

```bash
# 安装 Nginx
apt install nginx -y

# 复制配置
cp configs/nginx.conf /etc/nginx/sites-enabled/api-aiapi.cn

# 修改域名和 SSL 证书路径
# 如果你没有域名，可以用 http://ip:3000 直接访问

# 申请 SSL 证书
curl https://get.acme.sh | sh
~/.acme.sh/acme.sh --issue -d your-domain.com --nginx

# 重载 Nginx
nginx -s reload
```

## 第五步：添加渠道

登录 One API 管理后台 → 渠道 → 添加渠道

以 DeepSeek 为例：
- 类型：DeepSeek
- 名称：任意
- 密钥：你的 DeepSeek API Key
- 分组：default

完成后测试一下：
```bash
curl http://localhost:3000/v1/chat/completions \
  -H "Authorization: Bearer 你的Key" \
  -H "Content-Type: application/json" \
  -d '{"model": "deepseek-v4-flash", "messages": [{"role": "user", "content": "你好"}]}'
```

## 注意

1. **base_url 不要带 /v1**，否则会拼接成 `/v1/v1/chat/completions`
2. **添加完渠道后刷新 ability 表**，否则渠道可能不可用
3. **记得改默认密码**，`root/123456` 谁都知道
