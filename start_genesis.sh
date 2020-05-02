# init_gene(){
#     cd
#     mkdir -p ~/.local/share/eosio/nodeos/config
#     cd ~/.local/share/eosio/nodeos/config
#     wget https://gist.githubusercontent.com/tony92151/bf303abffd06f11d296e02b99da4bf91/raw/c1cc2158648f630c1212e186cf8d998febc10770/config.ini
#     wget https://genesis.testnet.eos.io/genesis.json
#     cd
# }
init_gene(){
    cd
    mkdir -p node
    cd node
    wget https://raw.githubusercontent.com/Intelligent-Systems-Lab/EOS-lab-testnet/master/config.ini
    wget https://genesis.testnet.eos.io/genesis.json
    cd
}

# start_gene(){
#     nodeos -e -p eosio \
#     --plugin eosio::producer_plugin \
#     --plugin eosio::producer_api_plugin \
#     --plugin eosio::chain_api_plugin \
#     --plugin eosio::net_api_plugin \
#     --plugin eosio::http_plugin \
#     --plugin eosio::history_plugin \
#     --plugin eosio::history_api_plugin \
#     --filter-on="*" \
#     --access-control-allow-origin='*' \
#     --contracts-console \
#     --http-validate-host=false \
#     --verbose-http-errors \
#     --http-server-address=0.0.0.0:8888 \
#     --genesis-json /root/.local/share/eosio/nodeos/config/genesis.json \
#     --config-dir=/root/.local/share/eosio/nodeos
# }

start_gene(){
    nodeos \
    --data-dir=/root/node \
    --genesis-json /root/node/genesis.json \
    --config-dir=/root/node
}

if [ $1 == "clean" ]
then
    echo "Clean node!"
    rm -r /root/node/*
    init_gene
elif [ $1 == "init" ]
then
    echo "Init node!"
    init_gene
elif [ $1 == "start" ]
then
    echo "Start node!"
    start_gene
fi