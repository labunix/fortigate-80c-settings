#!/bin/bash
#
# [概要]
#
# 初期状態から、NAT/ルートモード、スタンドアローン構成のまま、
# [internal]に管理PCを接続するためだけの初期設定を行うための
# 最小限のコマンドを出力する。
#
# [Web管理]
#
# SSL証明書のブロックに備え、[http]も有効にしている。
# ssh鍵が512bitでの接続不可に備え、[telnet]も有効にしている。
#
# [シリアルコンソールからのコピペ設定]
#
# コメント[#]はFortigateでもコメントとして何も処理しないので、
# そのままコピペで設定出来る。
#
# 工場出荷状態に戻す場合
# exec factoryreset
#

# グローバル設定
# 60    (GMT+9:00)Irkutsk,Osaka,Sapporo,Tokyo,Seoul
#

TIMEZONE="60"
LAGUAGE="japanese"
HOSTNAME="FGT-UTM"

# 管理NIC設定
INTERFACE_NAME="internal"
INTERFACE_IP="172.31.31.252/24"
INTERFACE_AP="ping telnet ssh http https"

# 管理NICルーティング設定
ROUTING_NET="172.31.31.0/255.255.255.0"
ROUTING_GW="172.31.31.254"

# 管理者設定
ADMIN_PASS="Password"
ADMIN_TRUST1="172.31.31.0 255.255.255.0"

echo -e '

# グローバル設定
config system global
  set timezone $TIMEZONE
  set language $LANGUAGE
  end

show system global

# 管理NIC設定

config system interface
  edit $INTERFACE_NAME
  set ip $INTERFACE_IP
  set allowaccess $INTERFACE_AP
  set status up
  end

show system interface $INTERFACE_NAME

# 管理NICルーティング設定

config router static
  edit 1
  set device $INTERFACE_NAME
  set dst $ROUTING_NET
  set gateway $ROUTING_GW
  end

show router static

# 管理者設定

config system admin
  edit admin
  set password $ADMIN_PASS
  set trusthost1 $ADMIN_TRUST1
  end

show system admin
'
exit 0

