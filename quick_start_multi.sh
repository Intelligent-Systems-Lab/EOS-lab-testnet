#!/bin/bash

echo "  ___ ___ _      _      _   ___  "
echo " |_ _/ __| |    | |    /_\ | _ ) "
echo "  | |\__ \ |__  | |__ / _ \| _ \ "
echo " |___|___/____| |____/_/ \_\___/ "
echo
echo

echo "This script will create multiple node for temporarily experiment and contract develop."

echo
echo "It will create 30 nodes and auto generate key-pairs."
read -p "Press [Enter] to continue... or [Control + c] to stop..."
#echo

run_keygen_download(){
    #git clone https://github.com/Intelligent-Systems-Lab/eos-keygen.git
    #cd eos-keygen
    echo "Download key-pairs from wget https://github.com/Intelligent-Systems-Lab/eos-keygen/raw/master/python/account_50.txt"
    cd 
    wget https://github.com/Intelligent-Systems-Lab/eos-keygen/raw/master/python/account_50.txt
    source ./account_50.txt
}

run_create_nodes_env(){
    # Setup genesis node
    cd
    mkdir -p nodes/node0000
    cd nodes/node0000
    wget https://raw.githubusercontent.com/Intelligent-Systems-Lab/EOS-lab-testnet/master/node/config.ini
    wget https://genesis.testnet.eos.io/genesis.json
    sed -i "s/\"initial_key\": \"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV\",/\"initial_key\": \"$user0000_pub\",/" genesis.json
    cd
    

    # Setup others nodes config file
    for i in {0001..0024}; do 
        folder_name="nodes/node$i"
        mkdir -p $folder_name; 
        cp nodes/node0000/config.ini $folder_name
        cp nodes/node0000/genesis.json $folder_name
        #set_config
    done

    cd
    # Setup 24 nodes for producers (total 25 nodes, include genesis node) 
    for i in {0000..0024}; do 
        sed -i "s/p2p-listen-endpoint = 0.0.0.0:9876/p2p-listen-endpoint = 0.0.0.0:90${i:2},/" nodes/node$i/config.ini
        sed -i "s/# p2p-max-nodes-per-host = 1/p2p-max-nodes-per-host = 10/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.2:9876/#p2p-peer-address = 172.17.0.2:9876,/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.3:9876/#p2p-peer-address = 172.17.0.3:9876,/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.4:9876/#p2p-peer-address = 172.17.0.4:9876,/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.5:9876/#p2p-peer-address = 172.17.0.5:9876,/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.6:9876/#p2p-peer-address = 172.17.0.6:9876,/" nodes/node$i/config.ini

        for j in {0001..0024}; do
            echo "p2p-peer-address = localhost:90${j:2}" >> nodes/node$i/config.ini
        
        user_name=$(echo user${i}_name)
        user_pvt=$(echo user${i}_pvt)
        user_pub=$(echo user${i}_pub)

        sed -i "s/p2p-peer-address = localhost:90${i:2}/#p2p-peer-address = localhost:90${i:2},/" nodes/node$i/config.ini
        sed -i "s/signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3/signature-provider = ${!user_pub}=KEY:${!user_pvt}/" nodes/node$i/config.ini
        sed -i "s/producer-name = eosio/producer-name = ${!user_name}/" nodes/node$i/config.ini
        
        #set_config
        done
    done
}

# https://stackoverflow.com/questions/18460123/how-to-add-leading-zeros-for-for-loop-in-shell

echo
echo "Generate/Download key pairs..."
echo "It will take about 5 second."

run_keygen_download > /dev/null 2>&1

echo
echo "Create nodes environment..."
echo "It will take about 20 second."

run_create_nodes_env

echo
echo "Create genesis block..."

