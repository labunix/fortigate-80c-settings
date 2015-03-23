#!/bin/bash 

MAILIP=192.168.1.251
MAILPORT=25

WEBIP=192.168.1.251
WEBPORT=80

PROXYIP=192.168.1.251
PROXYPORT=3128

PleaseInput () {
  # MAILIP,MAILPORT
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
  # WEBIP,WEBPORT
  echo "Input Web Server IP(default 192.168.1.251)"
  read WEBIP

  if [ "$WEBIP" == "" ]; then
    WEBIP="192.168.1.251";\
  fi

  echo "Input Web Server Port (default 80)"
  read WEBPORT

  if [ "$WEBPORT" == "" ]; then
    WEBPORT="80";\
  fi

  echo "Input Proxy Server IP(default 192.168.1.251)"
  read PROXYIP

  if [ "$PROXYIP" == "" ]; then
    PROXYIP="192.168.1.251";\
  fi

  echo "Input Proxy Server Port (default 3128)"
  read PROXYPORT

  if [ "$PROXYPORT" == "" ]; then
    PROXYPORT="3128";\
  fi

}

if [ "$1" == "-b" ] ;then
  echo "batch mode"
else
  echo "Please Input Parameter"
  PleaseInput
fi

msmtp --help > /dev/null 2>&1 && \
echo "To: `whoami`@`cat /etc/mailname`
Subject: Test  date '+%Y/%m/%d %H:%M:%S'

date '+%Y/%m/%d %H:%M:%S'" | \
  msmtp \
    --host=${MAILIP} \
    --port=${MAILPORT} \
    -f `whoami`@`cat /etc/mailname` \
    --auto-from=on \
    --domain `cat /etc/mailname` \
    --timeout=60 \
    -t && echo "### mail sent" >&2

w3m --help 2>&1 | grep help >/dev/null && \
  w3m -no-proxy -dump http://${WEBIP}:${WEBPORT}/ | \
    grep . && echo "### Web access OK." >&2

w3m --help 2>&1 | grep help >/dev/null && \
  w3m -o http_proxy=http://${PROXYIP}:${PROXYPORT}/ -dump http://labunix.hateblo.jp/ | \
    grep . && echo "### Proxy access OK." >&2

exit 0


