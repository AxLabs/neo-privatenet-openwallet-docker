#!/usr/bin/expect -f
set wallet [lindex $argv 0]
set password [lindex $argv 1]
set timeout -1
spawn np-api-server --wallet $wallet --port-rpc 30337 --privnet
interact