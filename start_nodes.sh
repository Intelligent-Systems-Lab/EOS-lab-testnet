nodeos --producer-name inita \
--plugin eosio::chain_api_plugin \
--plugin eosio::net_api_plugin \
--http-server-address 0.0.0.0.0:8889 \
--p2p-listen-endpoint 0.0.0.0:9877 \
--p2p-peer-address 172.17.0.2:9876 \
--private-key ["EOS56sE3Xx7vtaQazDPj3ExEVjGm7G5iXT3CH6ezkKsovp6XyFjW4","5Kgp1QswMvDuXbgZNiRiCzhTA7hecaRbKgytgZyFFfYAPR1n8jH"]