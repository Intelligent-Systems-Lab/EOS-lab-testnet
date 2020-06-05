ip=$(hostname -I)
ip=${ip% }
# https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence/#25-register-the-new-account-as-a-producer
cleos -u http://$eos_endpoint system regproducer $1 $2 https://$ip:9876 $2

# This 'setprods' action is defined in eosio.bios, but some action are the same in eosio.system
# IF we set two contracts, some system contract may not work (some actions will cover by others)

#$ cleos -u http://$eos_endpoint push action eosio setprods '{"schedule": [{"producer_name": '$1',"authority": ["block_signing_authority_v0",{"threshold": 1,"keys": [{"key": '$2',"weight": 1}]}]}]}' -p eosio

# 'setprods' mean set accout to producer directly, which is not reasonable.

# We can only set 'eosio.bios' contract, and use 'regproducer' to registed the account as candidate of producer.
# Then stack xx million coin. It will start produce block.

# In https://developers.eos.io/welcome/latest/tutorials/bios-boot-sequence/#29-vote-for-each-of-the-block-producers-started
# We need 15% of token to start produce (1000000000*0.15=150,000,000)
