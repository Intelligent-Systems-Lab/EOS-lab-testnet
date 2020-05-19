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

if [ $nodetype == "genesis" ]
then
    echo "Do you want to use default key-pair for system account ?"
    echo "Default private key : 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
    select yn in "default" "custom"; do
        case $yn in
            "default" ) eosio_prikey=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3; break;;
            "custom" ) read -p "Enter new private key: "  eosio_prikey && read -p "Enter new public key: "  eosio_pubkey; break;;
        esac
    done
fi

echo
# echo "Do you want to use default 'p2p-peer-address'  ?"
# echo -e "default address \n172.17.0.3:9876\n172.17.0.4:9876\n172.17.0.5:9876"
# select yn in "default" "custom"; do
#     case $yn in
#         "default" ) p2p_address='genesis'; break;;
#         "custom" ) nodetype='ordinary'; break;;
#     esac
# done

echo "Prepare..."
sleep 1
bash EOS-lab-testnet/start_node.sh init >> /dev/null 2>&1

ip=$(hostname -I)
ip=${ip% }:9876
sed -i "s/p2p-peer-address = $ip//" node/config.ini

bash EOS-lab-testnet/start_node.sh start >> nodeos.log 2>&1 &

echo " ==================="
echo "|Node is running... |"
echo " ==================="
echo "Log : $PWD/nodeos.log"

echo "System account key :\n$eosio_prikey\n$eosio_pubkey" >> node.info
echo "Node info save at : $PWD/node.info"

sleep 1

## Ordinary

# if [ $nodetype == "ordinary" ]
# then
#     echo "Do you want to use default key-pair for system account ?"
#     echo "Default private key : 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
#     select yn in "default" "custom"; do
#         case $yn in
#             "default" ) eosio_prikey=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3; break;;
#             "custom" ) read -p "Enter new private key: "  eosio_prikey && read -p "Enter new public key: "  eosio_pubkey; break;;
#         esac
#     done
# fi 







