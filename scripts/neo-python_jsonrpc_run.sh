#!/usr/bin/expect -f
set wallet [lindex $argv 0]
set timeout -1
spawn np-api-server --config /neo-python/neo/data/protocol.privnet-1.json --wallet $wallet --port-rpc 30337
interact
