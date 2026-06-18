#!/bin/bash
# balance_alert.sh - 余额预警脚本
# 检查各供应商账户余额，低于阈值时告警
# 推荐每天执行一次

DB="/root/one-api/one-api.db"

echo "=== 余额检查 $(date '+%Y-%m-%d %H:%M:%S') ==="

# 检查用户余额（阈值 100000 quota ≈ ¥2）
THRESHOLD=100000
LOW_BALANCE=$(sqlite3 "$DB" "SELECT count(*) FROM users WHERE quota < $THRESHOLD AND quota > 0 AND role != 100;")

if [ "$LOW_BALANCE" -gt "0" ]; then
    echo "⚠️ 有 $LOW_BALANCE 个用户余额不足"
    sqlite3 "$DB" "SELECT id, username, quota FROM users WHERE quota < $THRESHOLD AND quota > 0 AND role != 100 ORDER BY quota ASC LIMIT 10;" | while IFS='|' read id user quota; do
        echo "  用户 $user (ID=$id): 剩余 $quota quota"
    done
fi

# 检查总消耗
TOTAL_USED=$(sqlite3 "$DB" "SELECT SUM(used_quota) FROM users;")
echo "📊 平台总消耗: $TOTAL_USED quota"

# 检查今日新增调用
TODAY_CALLS=$(sqlite3 "$DB" "SELECT count(*) FROM logs WHERE datetime(created_at, 'unixepoch') >= date('now');")
echo "📞 今日调用次数: $TODAY_CALLS"
