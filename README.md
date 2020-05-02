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

## Get start

Clone repo
```sheel=
git clone https://github.com/Intelligent-Systems-Lab/EOS-lab-testnet.git
```
Init env
```sheel=
bash EOS-lab-testnet/init_env.sh default
```
Start genesis node
```sheel=
bash EOS-lab-testnet/start_genesis.sh init
bash EOS-lab-testnet/start_genesis.sh start
```
Init wallet
```sheel=
bash EOS-lab-testnet/init_wallet.sh init
```

Activate `WTMSIG_BLOCK_SIGNATURES` conscious
more [detial](https://www.bcskill.com/index.php/archives/884.html)
```sheel=
bash EOS-lab-testnet/fix_block.sh
```
