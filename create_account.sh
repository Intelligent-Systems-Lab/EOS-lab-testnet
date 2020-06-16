
cleos -u http://$eos_endpoint  system newaccount --stake-net "50.0000 QAQ" --stake-cpu "50.0000 QAQ" --buy-ram-kbytes 4096 eosio $1 $2 -p eosio

cleos -u http://$eos_endpoint transfer eosio $1 "$3.0000 QAQ" "Give you $3 QAQ"

echo "Create account : $1 and stake 50 QAQ for net, 50 QAQ for cpu and 20480 bytes ram."
echo "Transfer : $3 QAQ for $1"