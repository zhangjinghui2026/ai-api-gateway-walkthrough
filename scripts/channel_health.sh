#!/bin/bash
# channel_health.sh - 渠道健康检查
# 检查 One API 中所有的渠道状态，自动恢复被熔断的渠道
# 推荐每 10 分钟执行一次

DB="/root/one-api/one-api.db"

DOWN_CHANNELS=$(sqlite3 "$DB" "SELECT count(*) FROM channels WHERE status=0;")

if [ "$DOWN_CHANNELS" -gt "0" ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ⚠️ 有 $DOWN_CHANNELS 个渠道异常"
    sqlite3 "$DB" "SELECT id, name, type FROM channels WHERE status=0;" | while IFS='|' read id name type; do
        echo "尝试恢复 channel $id ($name, type=$type)..."
        sqlite3 "$DB" "UPDATE channels SET status=1 WHERE id=$id;"
        if [ $? -eq 0 ]; then
            echo "✅ channel $id 已恢复"
        fi
    done
    # 需要重启 One API 使状态生效
    systemctl restart one-api
    echo "🔄 One API 已重启"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ 所有渠道正常"
fi
