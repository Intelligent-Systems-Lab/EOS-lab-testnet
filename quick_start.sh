#!/bin/bash

echo "     ----------       --------        ---            "
echo "    |          |    /          |     |   |           "
echo "     ---    ---     |   ------       |   |           "
echo "        |  |        |  |             |   |           "
echo "        |  |        |   ------       |   |           "
echo "        |  |         \         \     |   |           "
echo "        |  |           -----   |     |   |           "
echo "        |  |                |  |     |   \           "
echo "     ---    ---      -------   |     |    --------   "
echo "    |          |    |          /     \            |  "
echo "     ----------      ---------        ------------   "
echo



echo "Do you want to cerate 'Genesis eos node' or 'Ordinary eos node'?"
select yn in "Genesis eos node" "Producer eos node" "Ordinary eos node"; do
    case $yn in
        "Genesis eos node" ) nodetype='genesis'; break;;
        "Producer eos node" ) nodetype='producer'; break;;
        "Ordinary eos node" ) nodetype='ordinary'; break;;
    esac
done

echo

ask_keypair(){
    if [ "$1" == "bp" ]
    then
        echo "Do you want to use default key-pair for block producer account ?"
    else
        echo "Do you want to use default key-pair for system account ?"
    fi
    #echo "Do you want to use default key-pair for system account ?"
    echo "Default private key : 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
    select yn in "default" "custom" "none"; do
        case $yn in
            "default" ) eosio_prikey=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 && eosio_pubkey=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV; break;;
            "custom" ) read -p "Enter new private key: "  eosio_prikey && read -p "Enter new public key: "  eosio_pubkey; break;;
        esac
    done
}


ask_fix_block(){
    echo
}

ask_create_key(){
    echo
}

ask_producer_name(){
    echo "Enter producer name:"
    echo "Default pd name : producer"
    select yn in "default" "custom"; do
        case $yn in
            "default" ) pd_name=producer; break;;
            "custom" ) read -p "Enter new pd name : " pd_name; break;;
        esac
    done
}

ask_genesis_pubkey(){
    echo "Do you want to use default \"genesis public key\" for block producer start document ?"
    echo "Default public key : EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV"
    select yn in "default" "custom" "none"; do
        case $yn in
            "default" ) gene_pubkey=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV; break;;
            "custom" ) read -p "Enter new genesis pub key: "  gene_pubkey; break;;
        esac
    done
}

set_host_ip(){
    ip=$(hostname -I)
    ip=${ip% }
}

set_auto_production_flase(){
    sed -i "s/enable-stale-production = true/#enable-stale-production = true/" node/config.ini
}

set_bash(){
    if [ "$1" == "key" ]
    then
        #echo
        echo "export eosio_prikey=$eosio_prikey" >> ~/.bashrc
        echo "export eosio_pubkey=$eosio_pubkey" >> ~/.bashrc
        echo "export eos_endpoint=$ip:8888" >> ~/.bashrc
        eos_endpoint=$ip:8888
    else
        echo "export eos_endpoint=$ip:8888" >> ~/.bashrc
        eos_endpoint=$ip:8888
    fi
    
}

set_config(){
    if [ "$1" == "bp" ]
    then
        sed -i "s/producer-name = eosio/producer-name = $pd_name/" node/config.ini
        sed -i "s/\"initial_key\": \"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV\",/\"initial_key\": \"$gene_pubkey\",/" node/genesis.json
    else
        sed -i "s/\"initial_key\": \"EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV\",/\"initial_key\": \"$eosio_pubkey\",/" node/genesis.json
    fi
    sed -i "s/p2p-peer-address = $ip/#p2p-peer-address = $ip/" node/config.ini
    sed -i "s/signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3/signature-provider = $eosio_pubkey=KEY:$eosio_prikey/" node/config.ini
    
}

set_init_wallet(){
    cleos -u http://$eos_endpoint wallet create --file wallet_pass.txt
    cleos -u http://$eos_endpoint wallet import --private-key $eosio_prikey
}

set_download_contract_and_build(){
    # eosio.cdt version 1.6.3
    cd
    git clone https://github.com/EOSIO/eosio.contracts.git eosio.contracts-1.8.x
    cd ./eosio.contracts-1.8.x/
    git checkout release/1.8.x
    ./build.sh -y
    cd ./build/contracts/
    EOSIO_OLD_CONTRACTS_DIRECTORY=$(pwd)
    echo "export EOSIO_OLD_CONTRACTS_DIRECTORY=$(pwd)" >> ~/.bashrc
    
    # eosio.cdt version 1.7.0
    cd
    git clone https://github.com/EOSIO/eosio.contracts.git
    cd ./eosio.contracts/
    git checkout release/1.9.x
    ./build.sh -y
    cd ./build/contracts/
    EOSIO_CONTRACTS_DIRECTORY=$(pwd)
    echo "export EOSIO_CONTRACTS_DIRECTORY=$(pwd)" >> ~/.bashrc

}

set_create_system_accounts(){
    sleep 2
    cleos -u http://$eos_endpoint create account eosio eosio.token $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.msig $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.bpay $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.names $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.ram $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.ramfee $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.saving $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.stake $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.vpay $eosio_pubkey -p eosio@active
    sleep 0.2
    cleos -u http://$eos_endpoint create account eosio eosio.rex $eosio_pubkey -p eosio@active
}

set_install_system_contracts(){
    sleep 1
    cleos -u http://$eos_endpoint set contract eosio.token $EOSIO_CONTRACTS_DIRECTORY/eosio.token -p eosio.token@active
    sleep 1
    cleos -u http://$eos_endpoint set contract eosio.msig $EOSIO_CONTRACTS_DIRECTORY/eosio.msig -p eosio.msig@active
}

set_create_token(){
    sleep 1
    cleos -u http://$eos_endpoint push action eosio.token create '["eosio", "1000000000.0000 QAQ"]' -p eosio.token

    sleep 1
    # https://github.com/EOSIO/eos/issues/7061
    #cleos -u http://$eos_endpoint push action eosio init '[0,"4,QAQ"]' -p eosio@active
    cleos -u http://$eos_endpoint push action eosio.token issue '["eosio",  "500000000.0000 QAQ", "init"]' -p eosio@active
}

set_system_contract(){
    apt -y install jq
    # It could time out, run 5 time to ensure
    sleep 0.5
    curl -X POST http://$eos_endpoint/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq
    for i in {1..5};
    do
        sleep 1
        cleos -u http://$eos_endpoint set contract eosio $EOSIO_OLD_CONTRACTS_DIRECTORY/eosio.system -p eosio@active
    done

    sleep 2
    # activate remaining features
    # GET_SENDER
    cleos -u http://$eos_endpoint push action eosio activate '["f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"]' -p eosio
    # FORWARD_SETCODE
    cleos -u http://$eos_endpoint push action eosio activate '["2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"]' -p eosio
    # ONLY_BILL_FIRST_AUTHORIZER
    cleos -u http://$eos_endpoint push action eosio activate '["8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"]' -p eosio
    # RESTRICT_ACTION_TO_SELF
    cleos -u http://$eos_endpoint push action eosio activate '["ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"]' -p eosio@active
    # DISALLOW_EMPTY_PRODUCER_SCHEDULE
    cleos -u http://$eos_endpoint push action eosio activate '["68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"]' -p eosio@active
    # FIX_LINKAUTH_RESTRICTION
    cleos -u http://$eos_endpoint push action eosio activate '["e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"]' -p eosio@active
    # REPLACE_DEFERRED
    cleos -u http://$eos_endpoint push action eosio activate '["ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"]' -p eosio@active
    # NO_DUPLICATE_DEFERRED_ID
    cleos -u http://$eos_endpoint push action eosio activate '["4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"]' -p eosio@active
    # ONLY_LINK_TO_EXISTING_PERMISSION
    cleos -u http://$eos_endpoint push action eosio activate '["1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"]' -p eosio@active
    # RAM_RESTRICTIONS
    cleos -u http://$eos_endpoint push action eosio activate '["4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"]' -p eosio@active
    # WEBAUTHN_KEY
    cleos -u http://$eos_endpoint push action eosio activate '["4fca8bd82bbd181e714e283f83e1b45d95ca5af40fb89ad3977b653c448f78c2"]' -p eosio@active
    # WTMSIG_BLOCK_SIGNATURES
    cleos -u http://$eos_endpoint push action eosio activate '["299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"]' -p eosio@active
    sleep 0.5
    cleos -u http://$eos_endpoint push action eosio setpriv '["eosio.msig",1]' -p eosio@active

    for i in {1..5};
    do
        sleep 1
        cleos -u http://$eos_endpoint set contract eosio $EOSIO_CONTRACTS_DIRECTORY/eosio.system -p eosio@active
    done

    # https://github.com/EOSIO/eos/issues/7061
    cleos -u http://$eos_endpoint push action eosio init '[0,"4,QAQ"]' -p eosio@active

    sleep 1
    #cleos -u http://$eos_endpoint set contract eosio $EOSIO_CONTRACTS_DIRECTORY/eosio.bios -p eosio@active

    echo " --------"
    echo "|Done... |"
    echo " --------"
}

# https://github.com/EOSIO/eos/blob/master/tutorials/bios-boot-tutorial/bios-boot-tutorial.py#L298

run_node(){
    bash EOS-lab-testnet/start_node.sh start >> nodeos.log 2>&1 &

    echo " ==================="
    echo "|Node is running... |"
    echo " ==================="
    echo "Log : $PWD/nodeos.log"

    echo -e "System account key :\n$eosio_prikey\n$eosio_pubkey" >> node.info
    echo "Node info save at : $PWD/node.info"
}
#######################################################
#######################################################
if [ $nodetype == "genesis" ]
then
    echo "Prepare..."
    sleep 0.5
    bash EOS-lab-testnet/start_node.sh init_gene >> /dev/null 2>&1

    ask_keypair
    set_host_ip
    set_bash key
    set_config
    echo "Initial wallet..."
    set_init_wallet
    echo
    read -p "Press [Enter] to run node..."
    run_node
    echo
    read -p "Press [Enter] to setup system boot..."
    set_create_system_accounts
    set_install_system_contracts
    set_create_token
    set_system_contract

    
elif [ $nodetype == "producer" ]
then
    echo "Prepare..."
    sleep 0.5
    #bash EOS-lab-testnet/wallet.sh init
    bash EOS-lab-testnet/start_node.sh init_ord >> /dev/null 2>&1
    echo
    ask_keypair bp
    echo
    ask_genesis_pubkey
    echo
    ask_producer_name
    echo
    set_host_ip
    set_bash key
    set_auto_production_flase
    set_config bp

    echo "Initial wallet..."
    set_init_wallet
    echo
    read -p "Press [Enter] to run node..."
    run_node

fi
#######################################################
#######################################################

# echo "Do you want to use default 'p2p-peer-address'  ?"
# echo -e "default address \n172.17.0.3:9876\n172.17.0.4:9876\n172.17.0.5:9876"
# select yn in "default" "custom"; do
#     case $yn in
#         "default" ) p2p_address='genesis'; break;;
#         "custom" ) nodetype='ordinary'; break;;
#     esac
# done







