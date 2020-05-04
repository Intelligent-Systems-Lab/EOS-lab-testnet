cleos -u http://$eos_endpoint set contract eosio eosio.contracts/build/contracts/eosio.bios -p eosio@active

cleos -u http://$eos_endpoint push action eosio setprods '{"schedule": [{"producer_name": "eosio","authority": ["block_signing_authority_v0",{"threshold": 1,"keys": [{"key": '$eosio_pubkey',"weight": 1}]}]}]}' -p eosio

cleos -u http://$eos_endpoint create account eosio eosio.token $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.msig $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.bpay $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.names $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.ram $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.ramfee $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.saving $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.stake $eosio_pubkey -p eosio@active
cleos -u http://$eos_endpoint create account eosio eosio.vpay $eosio_pubkey -p eosio@active

cleos -u http://$eos_endpoint set contract eosio.token eosio.contracts/build/contracts/eosio.token -p eosio.token@active
cleos -u http://$eos_endpoint set contract eosio.msig eosio.contracts/build/contracts/eosio.msig -p eosio.msig@active
