# neo-privatenet-openwallet-docker

This docker image is based on the CityOfZion [neo-privatenet-docker](https://github.com/CityOfZion/neo-privatenet-docker/), but with an unlocked wallet (address `AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y`) with plenty of NEO and GAS -- which can be accessed through the JSON-RPC on port 30337.

This is very convenient when performing integration tests, since it's not possible to import *and* unlock wallets through the JSON-RPC interface. Thus, this image is pretty handy when using some JSON-RPC methods (e.g., `getnewaddress`, `sendtoaddress`, or `sendmany`) that requires an unlocked wallet.

This docker image is maintained by [AxLabs](https://axlabs.com).

## Usage

Just pull and run it:

```
$ docker pull axlabs/neo-privatenet-openwallet-docker
$ docker run --rm -d --name neo-privatenet -p 20333-20336:20333-20336/tcp -p 30333-30337:30333-30337/tcp axlabs/neo-privatenet-openwallet-docker
```

To check if the privatenet is already running, run the following command to list all addresses on the unlocked wallet:

```
$ curl --data-binary '{"jsonrpc": "2.0", "id":"curltest", "method": "listaddress", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:30337
```

The output should be:

```
{"jsonrpc": "2.0", "id": "curltest", "result": [{"address": "AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y", "haskey": true, "label": null, "watchonly": false}]}
```

Then, it will be possible, for example, to get a new address and add to the unlocked wallet:

```
$ curl --data-binary '{"jsonrpc": "2.0", "id":"curltest", "method": "getnewaddress", "params": [] }' -H 'content-type: text/plain;' http://127.0.0.1:30337
```

The output should be something like this:

```
{"jsonrpc": "2.0", "id": "curltest", "result": "ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em"}
```

If you check the output, the new address is `ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em`.

To check the NEO balance of both `AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y` and `ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em`, run the following command:

```
$ curl --data-binary '{"jsonrpc": "2.0", "id":"curltest", "method": "getbalance", "params": ["c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b"] }' -H 'content-type: text/plain;' http://127.0.0.1:30337
```

The output should be:

```
{"jsonrpc": "2.0", "id": "curltest", "result": {"Balance": "100000000.0", "Confirmed": "100000000.0"}}
```

Then, it's possible to send some NEO (e.g., 10 NEO) from `AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y` to the newly created address `ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em`:

```
$ curl --data-binary '{"jsonrpc": "2.0", "id":"curltest", "method": "sendtoaddress", "params": ["c56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b", "ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em", "10.0"] }' -H 'content-type: text/plain;' http://127.0.0.1:30337
```

The output should be something like this:

```
{"jsonrpc": "2.0", "id": "curltest", "result": {"txid": "0x08009babadc182a456692e1af25482f1dfb8e4a7e86e91ec9f86e25679fe1df1", "size": 283, "type": "ContractTransaction", "version": 0, "attributes": [{"usage": 32, "data": "23ba2703c53263e8d6e522dc32203339dcd8eee9"}], "vout": [{"n": 0, "asset": "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b", "value": "10", "address": "ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em"}, {"n": 1, "asset": "0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b", "value": "99999990", "address": "AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y"}], "vin": [{"txid": "0x4ba4d1f1acf7c6648ced8824aa2cd3e8f836f59e7071340e0c440d099a508cff", "vout": 0}], "sys_fee": "0", "net_fee": "0", "scripts": [{"invocation": "401cdbf7e3fa9f487ac0262cce0cc6a3e73f945351542b743efbb1d0c39258a87576a574557460be2f682e51188135bad9b422ab1958d607e3c47651fc26f75006", "verification": "21031a6c6fbbdf02ca351745fa86b9ba5a9452d785ac4f7fc2b7548ca2a46c4fcf4aac"}]}}
```

Then, it's possible to check the account state just to verify the new balance for each of the addresses:

```
$ curl --data-binary '{"jsonrpc": "2.0", "id":"curltest", "method": "getaccountstate", "params": ["ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em"] }' -H 'content-type: text/plain;' http://127.0.0.1:30337

{"jsonrpc": "2.0", "id": "curltest", "result": {"version": 0, "address": "ARanVBAy27qR9NPmxJfwEw16fzqXEDV9em", "script_hash": "65c91e61ad6cd9563ceba2d0a201ee29d25f986b", "frozen": false, "votes": [], "balances": {"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b": "10.0"}}}
```

and

```
$ curl --data-binary '{"jsonrpc": "2.0", "id":"curltest", "method": "getaccountstate", "params": ["AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y"] }' -H 'content-type: text/plain;' http://127.0.0.1:30337

{"jsonrpc": "2.0", "id": "curltest", "result": {"version": 0, "address": "AK2nJJpJr6o664CWJKi1QRXjqeic2zRp8y", "script_hash": "e9eed8dc39332032dc22e5d6e86332c50327ba23", "frozen": false, "votes": [], "balances": {"0xc56f33fc6ecfcd0c225c4ab356fee59390af8560be0e930faebe74a6daff7c9b": "99999990.0", "0x602c79718b16e442de58778e148d0b1084e3b2dffd5de6b7b16cee7969282de7": "16024.0"}}}
```

## Build the image yourself

Clone the repository and build:

```
$ git clone https://github.com/AxLabs/neo-privatenet-openwallet-docker.git
$ cd neo-privatenet-openwallet-docker
$ docker build -t axlabs/neo-privatenet-openwallet-docker:latest ./
```

