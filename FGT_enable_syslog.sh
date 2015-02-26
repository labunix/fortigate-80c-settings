#!/bin/bash

echo "input syslog server IP, default IP is [172.31.31.254]"
read SYSLOGIP
if [ $SYSLOGIP == ""];then
  SYSLOGIP="172.31.31.254"
fi

echo "input source IP address, default IP is [172.31.31.251"
read SOURCEIP
if [ "$SOURCEIP" == "" ];then
  SOURCEIP="172.31.31.251"
fi

echo "
show full-configuration log syslogd setting
show log syslogd setting
get log syslogd setting

config log syslogd setting
    set status enable
    set server $SYSLOGIP
    set facility syslog
    set source-ip $SOURCEIP
end

show full-configuration log syslogd setting
show log syslogd setting
get log syslogd setting
"
