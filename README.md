# EOS-lab-testnet

## Use docker 

```shell=
# node1 v4  
docker run -d -it -p 8881:8080/tcp -p 8891:8888/tcp --name eos1 tony92151/eos_lab:v4

# node2 v4
docker run -d -it -p 8882:8080/tcp -p 8892:8888/tcp --name eos2 tony92151/eos_lab:v4

# remove node1
docker container rm -f eos1
```
or use script
```shell=
# start node1 for v4
bash run_docker.sh run 1 v4

# remove node1
bash run_docker.sh rm 1
```

then go to browser

http://localhost:8881 for eos1

http://localhost:8882 for eos2

etc.

## Get start

### Clone repo
```sheel=
git clone https://github.com/Intelligent-Systems-Lab/EOS-lab-testnet.git
```
Init env
```sheel=
bash EOS-lab-testnet/init_env.sh default
source ~/.bashrc
```
### Start genesis node
```sheel=
bash EOS-lab-testnet/start_genesis.sh init
bash EOS-lab-testnet/start_genesis.sh start
```
### Init wallet
```sheel=
bash EOS-lab-testnet/init_wallet.sh init
```
and you will get a public-key
<img src="https://github.com/tony92151/EOS-lab-testnet/blob/master/images/image1.png" width="400"/>

then alse see private-key by
```sheel=
bash EOS-lab-testnet/init_wallet.sh key_info
```
<img src="https://github.com/tony92151/EOS-lab-testnet/blob/master/images/image2.png" width="400"/>

### Activate `WTMSIG_BLOCK_SIGNATURES` conscious

more [detial](https://www.bcskill.com/index.php/archives/884.html)
```sheel=
bash EOS-lab-testnet/fix_block.sh
```
`Init wallet before Activate the conscious`

### Create account
```sheel=
cleos -u http://$eos_endpoint create account eosio john {public key} -p eosio@active
```

### Start node

change `name` and `key pair` to yours.

```shell=
export node_name=john
export noden_key=EOS56s...
export noden_pkey=5Kgp1...
```
```shell=
nodeos --producer-name $node_name \
--plugin eosio::chain_api_plugin \
--plugin eosio::net_api_plugin \
--http-server-address 0.0.0.0.0:8889 \
--p2p-listen-endpoint 0.0.0.0:9877 \
--p2p-peer-address 172.17.0.2:9876 \
--private-key [\"$noden_key\",\"$noden_key\"]
```

### Register as block producer

```sheel=
cleos -u http://$eos_endpoint push action eosio setprods "testnetprods.json" -p eosio@active
```
In contract `setprods`, it need the format like below.

`testnetprods.json`
```json=
{
    "schedule": [
        {
            "producer_name": "eosio",
            "authority": [
                "block_signing_authority_v0",
                {
                    "threshold": 1,
                    "keys": [
                        {
                            "key": "EOS8xxxx",
                            "weight": 1
                        }
                    ]
                }
            ]
        }
    ]
}
```

## FLOW

`genesis node` : `Clone repo`>`Start genesis node`

`node1` : `Clone repo`>`Init wallet`>`Create account`>`Start node`>`Register as block producer`

`node2` : `Clone repo`>`Init wallet`>`Create account`>`Start node`>`Register as block producer`

etc.





