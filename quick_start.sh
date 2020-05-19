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
select yn in "Genesis eos node" "Ordinary eos node"; do
    case $yn in
        "Genesis eos node" ) nodetype='genesis'; break;;
        "Ordinary eos node" ) nodetype='ordinary'; break;;
    esac
done

echo

ask_keypair(){
    echo "Do you want to use default key-pair for system account ?"
    echo "Default private key : 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
    select yn in "default" "custom"; do
        case $yn in
            "default" ) eosio_prikey=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3; break;;
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

set_host_ip(){
    ip=$(hostname -I)
    ip=${ip% }:9876
}

set_bash(){
    if [$1=="-key"]
    then
        #echo "export eosio_prikey=$eosio_prikey" >> ~/.bashrc
        #echo "export eosio_pubkey=$eosio_pubkey" >> ~/.bashrc
    fi
    echo "export eos_endpoint=172.17.0.2:8888" >> ~/.bashrc
}

set_config(){
    sed -i "s/p2p-peer-address = $ip//" node/config.ini
    sed -i "s/signature-provider = EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV=KEY:5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3/signature-provider = $eosio_pubkey=KEY:$eosio_prikey/" node/config.ini
}

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
    set_bash -key
    set_host_ip
    set_config
    read 
    run_node
elif [ $nodetype == "ordinary" ]
then
    echo "Prepare..."
    sleep 0.5
    bash EOS-lab-testnet/wallet.sh init
    bash EOS-lab-testnet/start_node.sh init_ord >> /dev/null 2>&1

    set_bash
    set_host_ip
    set_config

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







