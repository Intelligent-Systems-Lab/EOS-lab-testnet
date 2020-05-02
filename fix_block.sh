apt -y install jq
cd
git clone --branch add-boot-contract https://github.com/EOSIO/eosio.contracts.git 
cd eosio.contracts
./build.sh -y && cd

curl -X POST http://172.17.0.2:8888/v1/chain/get_activated_protocol_features -d '{}' | jq

curl -X POST http://172.17.0.2:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}' | jq

cleos -u http://172.17.0.2:8888 set contract eosio eosio.contracts/build/contracts/eosio.boot -p eosio@active

cleos -u http://172.17.0.2:8888 push transaction '{"delay_sec":0,"max_cpu_usage_ms":0,"actions":[{"account":"eosio","name":"activate","data":{"feature_digest":"299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"},"authorization":[{"actor":"eosio","permission":"active"}]}]}'

curl -X POST http://172.17.0.2:8888/v1/chain/get_activated_protocol_features -d '{}' | jq

cleos -u http://172.17.0.2:8888 set contract eosio eosio.contracts/build/contracts/eosio.bios -p eosio@active