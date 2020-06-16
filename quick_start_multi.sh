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

    gene_pvt=$user0000_pvt
    gene_pub=$user0000_pub
    gene_name=eosio
}

run_create_nodes_env(){
    # Setup genesis node
    cd
    mkdir -p nodes/node0000
    cd nodes/node0000
    wget wget https://raw.githubusercontent.com/Intelligent-Systems-Lab/EOS-lab-testnet/master/bp_node/config.ini
    wget https://genesis.testnet.eos.io/genesis.json
    sed -i "s/\"initial_key\": \"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV\",/\"initial_key\": \"$gene_pub\",/" genesis.json
    sed -i "s/max-transaction-time = 60/max-transaction-time = 300/" config.ini
    
    cd
    wget https://raw.githubusercontent.com/Intelligent-Systems-Lab/EOS-lab-testnet/master/node/config.ini

    # Setup others nodes config file
    for i in {0001..0024}; do 
        folder_name="nodes/node$i"
        mkdir -p $folder_name; 
        cp config.ini $folder_name
        cp nodes/node0000/genesis.json $folder_name
        #set_config
    done

    cd
    # Setup 24 nodes for producers (total 25 nodes, include genesis node) 
    for i in {0000..0024}; do 
        sed -i "s/p2p-listen-endpoint = 0.0.0.0:9876/p2p-listen-endpoint = localhost:90${i:2}/" nodes/node$i/config.ini
        sed -i "s/p2p-server-address = localhost:9876/p2p-server-address = localhost:90${i:2}/" nodes/node$i/config.ini
        
        sed -i "s/# p2p-max-nodes-per-host = 1/p2p-max-nodes-per-host = 10/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.2:9876/#p2p-peer-address = 172.17.0.2:9876/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.3:9876/#p2p-peer-address = 172.17.0.3:9876/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.4:9876/#p2p-peer-address = 172.17.0.4:9876/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.5:9876/#p2p-peer-address = 172.17.0.5:9876/" nodes/node$i/config.ini
        sed -i "s/p2p-peer-address = 172.17.0.6:9876/#p2p-peer-address = 172.17.0.6:9876/" nodes/node$i/config.ini

        for j in {0000..0024}; do
            echo "p2p-peer-address = localhost:90${j:2}" >> nodes/node$i/config.ini
        done
        
        user_name=$(echo user${i}_name)
        user_pvt=$(echo user${i}_pvt)
        user_pub=$(echo user${i}_pub)

        sed -i "s/p2p-peer-address = localhost:90${i:2}/#p2p-peer-address = localhost:90${i:2}/" nodes/node$i/config.ini
        sed -i "s/http-server-address = 0.0.0.0:8888/http-server-address = localhost:88${i:2}/" nodes/node$i/config.ini
        sed -i "s/signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3/signature-provider = ${!user_pub}=KEY:${!user_pvt}/" nodes/node$i/config.ini
        

        if [ "$i" != "0000" ]
        then
            sed -i "s/enable-stale-production = true/#enable-stale-production = true/" nodes/node$i/config.ini
            sed -i "s/producer-name = eosio/producer-name = ${!user_name}/" nodes/node$i/config.ini
        fi

        #set_config
        #done
    done
}

run_gene_node(){
    nodeos \
    --data-dir=/root/nodes/node0000 \
    --genesis-json /root/nodes/node0000/genesis.json \
    --config-dir=/root/nodes/node0000 >> nodeos.log 2>&1 &
    echo "Node 0000 is running."
}

run_nodes(){
    for i in {0001..0024}; do
        nodeos \
        --data-dir=/root/nodes/node$i \
        --genesis-json /root/nodes/node$i/genesis.json \
        --config-dir=/root/nodes/node$i >> nodeos.log 2>&1 &
        echo "Node $i is running."
    done
}

set_init_wallet(){
    echo $gene_pvt
    cleos -u http://localhost:8800 wallet create --file wallet_pass.txt
    cleos -u http://localhost:8800 wallet import --private-key $gene_pvt
    
    for i in {0001..0024}; do
        user_pvt=$(echo user${i}_pvt)
        cleos -u http://localhost:8800 wallet import --private-key ${!user_pvt}
        #echo ${!user_pvt}
    done
}

set_create_system_accounts(){
    sleep 2
    cleos -u http://localhost:8800 create account eosio eosio.token $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.msig $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.bpay $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.names $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.ram $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.ramfee $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.saving $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.stake $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.vpay $gene_pub -p eosio@active
    sleep 0.2
    cleos -u http://localhost:8800 create account eosio eosio.rex $gene_pub -p eosio@active
}

set_install_system_contracts(){
    sleep 1
    cleos -u http://localhost:8800 set contract eosio.token $EOSIO_CONTRACTS_DIRECTORY/eosio.token -p eosio.token@active
    sleep 1
    cleos -u http://localhost:8800 set contract eosio.msig $EOSIO_CONTRACTS_DIRECTORY/eosio.msig -p eosio.msig@active
}

set_create_token(){
    sleep 1
    cleos -u http://localhost:8800 push action eosio.token create '["eosio", "1000000000.0000 QAQ"]' -p eosio.token

    sleep 1
    # https://github.com/EOSIO/eos/issues/7061
    #cleos -u http://$eos_endpoint push action eosio init '[0,"4,QAQ"]' -p eosio@active
    cleos -u http://localhost:8800 push action eosio.token issue '["eosio",  "500000000.0000 QAQ", "init"]' -p eosio@active
}

set_system_contract(){
    apt -y install jq
    # It could time out, run 5 time to ensure
    sleep 0.5
    curl -X POST http://localhost:8800/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq
    for i in {1..5};
    do
        sleep 1
        cleos -u http://localhost:8800 set contract eosio $EOSIO_OLD_CONTRACTS_DIRECTORY/eosio.system -p eosio@active
    done

    sleep 2
    # activate remaining features
    # GET_SENDER
    cleos -u http://localhost:8800 push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
    # FORWARD_SETCODE
    cleos -u http://localhost:8800 push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
    # ONLY_BILL_FIRST_AUTHORIZER
    cleos -u http://localhost:8800 push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
    # RESTRICT_ACTION_TO_SELF
    cleos -u http://localhost:8800 push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio@active
    # DISALLOW_EMPTY_PRODUCER_SCHEDULE
    cleos -u http://localhost:8800 push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio@active
    # FIX_LINKAUTH_RESTRICTION
    cleos -u http://localhost:8800 push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio@active
    # REPLACE_DEFERRED
    cleos -u http://localhost:8800 push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio@active
    # NO_DUPLICATE_DEFERRED_ID
    cleos -u http://localhost:8800 push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio@active
    # ONLY_LINK_TO_EXISTING_PERMISSION
    cleos -u http://localhost:8800 push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio@active
    # RAM_RESTRICTIONS
    cleos -u http://localhost:8800 push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio@active
    # WEBAUTHN_KEY
    cleos -u http://localhost:8800 push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio@active
    # WTMSIG_BLOCK_SIGNATURES
    cleos -u http://localhost:8800 push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio@active
    sleep 0.5
    cleos -u http://localhost:8800 push action eosio setpriv '["eosio.msig",1]' -p eosio@active

    for i in {1..5};
    do
        sleep 1
        cleos -u http://localhost:8800 set contract eosio $EOSIO_CONTRACTS_DIRECTORY/eosio.system -p eosio@active
    done

    # https://github.com/EOSIO/eos/issues/7061
    # https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence/#22-initialize-system-account
    cleos -u http://localhost:8800 push action eosio init '[0,"4,QAQ"]' -p eosio@active

    sleep 1
    #cleos -u http://$eos_endpoint set contract eosio $EOSIO_CONTRACTS_DIRECTORY/eosio.bios -p eosio@active


}



# https://stackoverflow.com/questions/18460123/how-to-add-leading-zeros-for-for-loop-in-shell

echo
echo "Generate/Download key pairs..."
echo "It will take about 5 second."

run_keygen_download

echo
echo "Create nodes environment..."
echo "It will take about 20 second."

run_create_nodes_env

set_init_wallet

echo
read -p "Press [Enter] to run gene nodes..."

run_gene_node


echo
read -p "Press [Enter] to setup system boot..."

set_create_system_accounts
set_install_system_contracts
set_create_token
set_system_contract

run_nodes

echo
read -p "Press [Enter] to setup producers..."



echo " --------"
echo "|Done... |"
echo " --------"

# nodeos \
# --data-dir=/root/nodes/node0000 \
# --genesis-json /root/nodes/node0000/genesis.json \
# --config-dir=/root/nodes/node0000
# echo "Node $i is running."