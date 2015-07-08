#!/bin/bash

LOGDATE=`date '+%Y%m%d_%H%M%S'`
REMOTESSH=admin@172.31.31.252
MAXCOLUMNLINE=4

# アドレス(subnet)
ssh ${REMOTESSH} 'show full-configuration firewall address | grep -f "all"' | \
    awk 'BEGIN{printf "\"Name\""};\
         /set/{printf ",\"%s\"",$2};\
         END  {printf "\n"}' > ${LOGDATE}_firewall_address.csv

ssh ${REMOTESSH} 'show full-configuration firewall address | grep -f "ipmask"' | \
    sed s/\'//g | sed s/\"//g | \
    sed -e 's/ <---//g' | grep -v "config\|end" | \
    awk '{if($1=="next"){printf "\n"} \
     else{if($1=="edit"){printf "\"%s\",",$2} \
     else{if($1=="set" && NF==2){printf "\"\","} \
     else{if($1=="set" && NF==3){printf "\"%s\",",$3} \
     else{if($1=="set" && NF>3){for(i=3;i<NF;i++)printf("\"%s ",$i)}printf($NF"\"")}}}}}' | \
     sed -e 's/,\$//g' | grep -v "#" >> ${LOGDATE}_firewall_address.csv

# サービス(category Custom)
ssh ${REMOTESSH} 'show full-configuration firewall service custom | grep -f "ALL_TCP"' | \
    awk 'BEGIN{printf "\"Name\""}; \
         /set/{printf ",\"%s\"",$2}; \
         END  {printf "\n"}' > ${LOGDATE}_firewall_service_custom.csv

ssh ${REMOTESSH} 'show full-configuration firewall service custom | grep -f "Custom"' | \
    sed s/\'//g | sed s/\"//g | \
    sed -e 's/ <---//g' | grep -v "config\|end" | \
    awk '{if($1=="next"){printf "\n"} \
     else{if($1=="edit"){printf "\"%s\",",$2} \
     else{if($1=="unset" && NF==2){printf "\"_NOT_\","} \
     else{if($1=="set" && NF==2){printf "\"\","} \
     else{if($1=="set" && NF==3){printf "\"%s\",",$3} \
     else{if($1=="set" && NF>3){for(i=3;i<NF;i++)printf("\"%s ",$i)}printf($NF"\"")}}}}}}' | \
     sed -e 's/,\$//g' | grep -v "#" >> ${LOGDATE}_firewall_service_custom.csv

# ポリシー
ssh ${REMOTESSH} 'show firewall policy '"${MAXCOLUMNLINE}"' ' | \
    awk 'BEGIN{printf "\"No\""}; \
         /set/{printf ",\"%s\"",$2}; \
         END  {printf "\n"}' > ${LOGDATE}_firewall_policy.csv

ssh ${REMOTESSH} 'show firewall policy' | \
    sed s/\'//g | sed s/\"//g | \
    sed -e 's/ <---//g' | grep -v "config\|end" | \
    awk '{if($1=="next"){printf "\n"} \
     else{if($1=="edit"){printf "\"%s\",",$2} \
     else{if($1=="unset" && NF==2){printf "\"_NOT_\","} \
     else{if($1=="set" && NF==2){printf "\"\","} \
     else{if($1=="set" && NF==3){printf "\"%s\",",$3} \
     else{if($1=="set" && NF>3){printf "\"";for(i=3;i<NF;i++)printf("%s ",$i)}printf($NF"\",")}}}}}}' | \
     sed -e 's/,\$//g' | grep -v "#" >> ${LOGDATE}_firewall_policy.csv

# フルポリシー

ssh ${REMOTESSH} 'show full-configuration firewall policy '"${MAXCOLUMNLINE}"' | grep .' | \
    grep -v "tcp-mss\|timeout-send-rst" | \
    awk 'BEGIN{printf "\"No\""}; \
         /set/{printf ",\"%s\"",$2}; \
         END  {printf "\n"}' > ${LOGDATE}_firewall_policy_full.csv

ssh ${REMOTESSH} 'show full-configuration firewall policy | grep .' | \
    grep -v "tcp-mss\|timeout-send-rst" | \
    sed s/\'//g | sed s/\"//g | \
    sed -e 's/ <---//g' | grep -v "config\|end" | \
    awk '{if($1=="next"){printf "\n"} \
     else{if($1=="edit"){printf "\"%s\",",$2} \
     else{if($1=="unset" && NF==2){printf "\"_NOT_\","} \
     else{if($1=="set" && NF==2){printf "\"\","} \
     else{if($1=="set" && NF==3){printf "\"%s\",",$3} \
     else{if($1=="set" && NF>3){printf "\"";for(i=3;i<NF;i++)printf("%s ",$i)}printf($NF"\",")}}}}}}' | \
     sed -e 's/,\$//g' | grep -v "#" >> ${LOGDATE}_firewall_policy_full.csv

