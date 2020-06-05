cleos -u http://$eos_endpoint push action eosio.token create '["eosio", "1000000000.0000 QAQ"]' -p eosio.token

# https://github.com/EOSIO/eos/issues/7061
# https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence/#22-initialize-system-account
# token with precision 4; precision can range from [0 .. 18]:
cleos -u http://$eos_endpoint push action eosio init '[0,"4,QAQ"]' -p eosio@active
cleos -u http://$eos_endpoint push action eosio.token issue '["eosio",  "500000000.0000 QAQ", "init"]' -p eosio@active

