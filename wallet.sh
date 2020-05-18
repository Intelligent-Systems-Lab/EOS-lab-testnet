init_wallet(){
    cleos -u http://$eos_endpoint wallet create --file wallet_pass.txt
    cleos -u http://$eos_endpoint wallet import --private-key $eosio_prikey
    cleos -u http://$eos_endpoint wallet create_key
}

get_wallet_info(){
    cat wallet_pass.txt
}

get_key_info(){
    #echo "Wallet password here!!!"
    #get_wallet_info
    cleos -u http://$eos_endpoint wallet private_keys --password $(cat wallet_pass.txt)
}

unlock_wallet(){
    #echo "Wallet password here!!!"
    #get_wallet_info
    cleos -u http://$eos_endpoint wallet unlock --password $(cat wallet_pass.txt)
}

if [ $1 == "init" ]
then
    echo "Init wallet!"
    init_wallet
elif [ $1 == "wallet_info" ]
then
    echo "Get wallet info!"
    get_wallet_info
elif [ $1 == "key_info" ]
then
    echo "Get key info!"
    get_key_info
elif [ $1 == "key_add" ]
then
    echo "Create key!"
    cleos -u http://$eos_endpoint wallet create_key
elif [ $1 == "unlock" ]
then
    echo "Unlock wallet!"
    unlock_wallet
fi