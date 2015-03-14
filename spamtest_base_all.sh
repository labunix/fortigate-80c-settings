#!/bin/bash

echo "Input Mail Server IP(default 192.168.1.251)"
read MAILIP

if [ "$MAILIP" == "" ]; then
  MAILIP="192.168.1.251";\
fi

echo "Input Mail Server Port (default 25)"
read MAILPORT

if [ "$MAILPORT" == "" ]; then
  MAILPORT="25";\
fi

wget --help > /dev/null 2>&1
if [ "$?" -ne 0 ]; then
  echo "Not Found Command : wget" >&2
  exit 2
else
  test -f dom-bl-base.txt || \
    wget http://www.joewein.net/dl/bl/dom-bl-base.txt
fi

msmtp --help > /dev/null 2>&1
if [ "$?" -ne 0 ];then
  echo "Not Found Command : msmtp" >&2
  exit 3
fi

MAX=`wc -l < dom-bl-base.txt`

for num in `seq 1 $MAX`;do \
  SPAMURL="`awk '(NR=='${num}'){print}' dom-bl-base.txt`"

echo "To: `whoami`@`cat /etc/mailname`
Subject: Test $num / $MAX [URL:$SPAMURL]

[URL:$SPAMURL]" | \
  msmtp \
    --host=${MAILIP} \
    --port=${MAILPORT} \
    -f `whoami`@`cat /etc/mailname` \
    --auto-from=on \
    --domain `cat /etc/mailname` \
    --timeout=60 \
    -t 
done
