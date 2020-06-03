# EOS-lab-testnet

## Quick start guide

[guide](quick_start.md)

## Script Overview

### quick srart
```sheel=
$ bash EOS-lab-testnet/quick_start.sh
```
This script can help you setup nodes quickly.
Some of following scripts are called in this script.

### Init env

```sheel=
$ bash EOS-lab-testnet/init_env.sh default/{coustom endpoint}
$ source ~/.bashrc
```
This script set three environment variables,`eosio_prikey` `eosio_pubkey` `eos_endpoint`, in `~/.bashrc`

Default endpoint(172.17.0.2) with default port :8888.

Default eosio_prikey=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

Default eosio_pubkey=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV 

> This key-pair only used for development.

### set up system contract
```sheel=
bash EOS-lab-testnet/init_bios.sh
```

In this script, we set up 
1. set `eosio.bios` contract
2. set `eosio` account as producer
3. create `eosio.msig` `eosio.bpay` `eosio.names` `eosio.ram` `eosio.ramfee` `eosio.saving` `eosio.stake` `eosio.vpay` accounts
4. create `eosio.rex` account and make an initial transaction
5. set `eosio.token` `eosio.msig` `eosio.system`contract and `push` an initial `action` of `setpriv`


### Start genesis node
```sheel=
bash EOS-lab-testnet/start_node.sh init
bash EOS-lab-testnet/start_node.sh start
```
### Init wallet
```sheel=
bash EOS-lab-testnet/wallet.sh init
```
and you will get a public-key

<img src="https://raw.githubusercontent.com/Intelligent-Systems-Lab/EOS-lab-testnet/master/images/image1.png" width="600"/>

then also see private-key by
```sheel=
bash EOS-lab-testnet/wallet.sh key_info
```
<img src="https://raw.githubusercontent.com/Intelligent-Systems-Lab/EOS-lab-testnet/master/images/image2.png" width="600"/>

### Activate `WTMSIG_BLOCK_SIGNATURES` conscious

more [detial](https://www.bcskill.com/index.php/archives/884.html)
```sheel=
bash EOS-lab-testnet/fix_block.sh
```
`Init wallet before Activate the conscious`

### set bios contract
```sheel=
bash EOS-lab-testnet/fix_bios.sh
```

### Create account
create account 
```sheel=
cleos -u http://$eos_endpoint create account eosio john {public key} -p eosio@active
```
create account and stack some money from `eosio`account
```sheel=
bash EOS-lab-testnet/create_account.sh john {public key}
```

### Start node

change `name` and `key pair` to yours.

```shell=
export node_name=john
export noden_key=EOS56s...
export noden_pkey=5Kgp1...
```
```shell=
# Node1(for 172.17.0.3)
nodeos \
--agent-name "EOS Agent - Node 1" 
--producer-name $node_name \
--plugin eosio::chain_api_plugin \
--plugin eosio::net_api_plugin \
--p2p-server-address 172.17.0.3:9876 \
--p2p-peer-address 172.17.0.2:9876 \
--p2p-peer-address 172.17.0.4:9876 \
--private-key [\"$noden_key\",\"$noden_pkey\"]

# Node2(for 172.17.0.4)
nodeos \
--agent-name "EOS Agent - Node 2" 
--producer-name $node_name \
--plugin eosio::chain_api_plugin \
--plugin eosio::net_api_plugin \
--p2p-server-address 172.17.0.4:9876 \
--p2p-peer-address 172.17.0.2:9876 \
--p2p-peer-address 172.17.0.3:9876 \
--private-key [\"$noden_key\",\"$noden_pkey\"]
```

### Register as block producer

```sheel=
cleos -u http://$eos_endpoint push action eosio setprods "testnetprods.json" -p eosio@active
```







