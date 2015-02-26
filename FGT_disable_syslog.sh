#!/bin/bash

echo "
show full-configuration log syslogd setting
show log syslogd setting
get log syslogd setting

config log syslogd setting
    set status disable
end

show full-configuration log syslogd setting
show log syslogd setting
get log syslogd setting
"
