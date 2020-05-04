cleos -u http://$eos_endpoint push action eosio.token create '["eosio", "1000000000.0000 QAQ"]' -p eosio.token
cleos -u http://$eos_endpoint push action eosio.token issue '["eosio",  "1000000.0000 QAQ", "init"]' -p eosio@active


