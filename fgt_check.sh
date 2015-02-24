#!/bin/bash

LOGNAME=$1

if [ "$LOGNAME" == "" ]; then
  echo "# Usage $0 [LOHNAME]" >&2
  exit 1
fi 

if [ -r "$LOGNAME" ];then
  echo "# Start $LOGNAME digest" >&2
else
  echo "# Can not read $LOGNAME" >&2
  exit 2
fi

# ホスト名
grep hostname $LOGNAME
# ファームウエアバージョン
grep ^Version $LOGNAME
# 時刻
grep ^current $LOGNAME
# ライセンス期限
grep expiration $LOGNAME
# DBバージョン
grep DB:  $LOGNAME
# 次回のアップデート
grep "Next sched update" $LOGNAME
# システム起動時間
grep Uptime $LOGNAME

# 全CPU使用率
grep "^CPU states" $LOGNAME
# メモリ使用率
grep "^Memory states" $LOGNAME
# ディスク状態
grep mounted $LOGNAME

# IPアドレスとNIC
grep "^IP" $LOGNAME
# トラフィック
grep "^[A-Z].*packets" $LOGNAME

# error|fail チェック
grep "error\|fail" $LOGNAME

# disable チェック
grep "disable" $LOGNAME

