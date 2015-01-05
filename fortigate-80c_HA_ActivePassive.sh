#!/bin/bash
#
# [概要]
#
# 初期状態から、NAT/ルートモードのまま、
# FGCP（FortiGateClusteringProtocol）を使った冗長化構成、
# アクティブ、パッシブのHA構成の初期設定を行う
# 最小限のコマンドを出力する。
#
# [WANの設定について]
#
# WAN側は構成しないので、Web管理から行ってください。
#
# [HA構成時の同期について]
#
# 直接接続するハートビート同期用のポートは、
# [internal]の[port6]のみとする。
# ※推奨は2ポート以上
# なお、interfaceモードに変更するため、
# [internal]をswitchとしては使用出来ない。
#
# [マスター選出について]
#
# アップタイムは5分以上の差が必要なため、
# [diagnose sys ha reset-uptime]により、5分以上の差を作ることで、
# 手動でのフェイルオーバを行う。
#
# 1.リンクアップしているモニタポートの多い機器
# 2.HAアップタイムの長い機器
# 3.HAのプライオリティの高い（数値が大きい）機器
# 4.シリアルNo.の大きい機器
#
# [フェイルバックについて]
# フェイルバックは行いません。フェイルバックを行うには、
# [set override enable]で有効にする必要があります。
#
# [セッション同期について]
# 
# 必要な場合は、[set session-pickup enable]コマンドで
# セッションピックアップを有効にします。
#
# 下記のみ冗長化構成時のセッションを継続します。
#
# TCPセッション情報情報
# IPsec VPNセッション情報
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
# [注意点]
#
# サブネットの指定方法がコマンドによって異なるので、
# 例を参考に自身の環境に合わせて変更してください。
#
# 工場出荷状態に戻す場合
# exec factoryreset
#

# グローバル設定
# 60    (GMT+9:00)Irkutsk,Osaka,Sapporo,Tokyo,Seoul
#

TIMEZONE="60"
LANGUAGE="japanese"
HOSTNAME1="FGT-UTM1"
HOSTNAME2="FGT-UTM2"

# 管理NIC設定
INTERFACE_NAME="port1"
INTERFACE_IP="172.31.31.252/24"
INTERFACE_AP="ping telnet ssh http https"

# 管理NICルーティング設定
ROUTING_NET="172.31.31.0/255.255.255.0"
ROUTING_GW="172.31.31.254"

# 管理者設定
ADMIN_PASS="Password"
ADMIN_TRUST1="172.31.31.0 255.255.255.0"

# HA設定

HA_GROUP_NAME="FGT-UTM"
HA_PASS="HApass"


echo "

# グローバル設定
config system global
  set timezone $TIMEZONE
  set language $LANGUAGE
  set hostname $HOSTNAME1
  end

show system global

# switch ポートモードから、interfaceモードに切り替え

config system dhcp server
  delete 1
  end

show system dhcp server

config firewall policy
  delete 1
  end

show firewall policy

# 管理NIC設定

config system interface
  edit $INTERFACE_NAME
  set ip $INTERFACE_IP
  set allowaccess $INTERFACE_AP
  set status up
  next
  edit wan1
  set mode static
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

# HA一号機設定

config system ha
  set mode a-p
  set group-name $HA_GROUP_NAME
  set password $HA_PASS
  set hbdev "internal" 6
  set session-pickup enable
  set authentication enable
  set priority 128
end

show system ha

execute shutdown

# HA二号機設定
# 一号機設定を流した後に上書きが必要な箇所のために実行

# グローバル設定
config system global
  set hostname $HOSTNAME2
  end

show system global

config system ha
  set mode a-p
  set group-name $HA_GROUP_NAME
  set password $HA_PASS
  set hbdev "internal" 6
  set session-pickup enable
  set authentication enable
  set priority 120
end

show system ha

execute shutdown

"
exit 0

