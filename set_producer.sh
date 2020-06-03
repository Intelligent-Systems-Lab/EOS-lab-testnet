
cleos -u http://$eos_endpoint push action $1 setprods '{"schedule": [{"producer_name": '$1',"authority": ["block_signing_authority_v0",{"threshold": 1,"keys": [{"key": '$2',"weight": 1}]}]}]}' -p $1