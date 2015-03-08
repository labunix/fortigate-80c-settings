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

echo "Input Loop count (default 5)"
read COUNT

if [ "$COUNT" == "" ];then
  COUNT=5
fi

MAX=`wc -l < dom-bl-base.txt`

if [ "$COUNT" -ge "$MAX" ];then
  COUNT=$MAX
fi

for num in `seq 1 $COUNT`;do \
  PICKUP="$(($(($RANDOM % $MAX))+1))"
  SPAMURL="`awk '(NR=='${PICKUP}'){print}' dom-bl-base.txt`"

  (sleep 1; echo "ehlo localhost"; \
   sleep 1; echo "mail from:`whoami`@`cat /etc/mailname`"; \
   sleep 1; echo "rcpt to:`whoami`@`cat /etc/mailname`"; \
   sleep 1; echo "data"; \
   sleep 1; echo "Subject: Test"; \
   sleep 1; echo ""; \
   sleep 1; echo "$SPAMURL"; \
   sleep 1; echo "." ; \
   sleep 1; echo "quit"; \
  ) | telnet $MAILIP $MAILPORT
done
