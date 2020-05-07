cleos -u http://$eos_endpoint push action eosio.token create '["eosio", "1000000000.0000 QAQ"]' -p eosio.token

# https://github.com/EOSIO/eos/issues/7061
cleos -u http://$eos_endpoint push action eosio init '[0,"4,QAQ"]' -p eosio@active
cleos -u http://$eos_endpoint push action eosio.token issue '["eosio",  "500000000.0000 QAQ", "init"]' -p eosio@active

