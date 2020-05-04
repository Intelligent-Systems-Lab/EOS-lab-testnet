if [ $1 = "default" ]
then
    echo "export eos_endpoint=172.17.0.2:8888" >> ~/.bashrc
    echo "export eosio_prikey=5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3" >> ~/.bashrc
    echo "export eosio_pubkey=EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV" >> ~/.bashrc
else
    echo "export eos_endpoint=$1:8888" >> ~/.bashrc
    echo "export eosio_prikey=$2" >> ~/.bashrc
    echo "export eosio_pubkey=$3" >> ~/.bashrc
fi
source ~/.bashrc
