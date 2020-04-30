nodeos --producer-name ted \
--plugin eosio::chain_api_plugin \
--plugin eosio::net_api_plugin \
--http-server-address 0.0.0.0.0:8889 \
--p2p-listen-endpoint 0.0.0.0:9877 \
--p2p-peer-address 172.17.0.2:9876 \
--private-key ["EOS5r8v2vkevL4ZcYd7dL2QPqaa3Z9u7jE3MYhbANk4BSaqMjvZnw","5JFEFYiVka6A4NbpN7KRv4y55r5YWMEZ4M979JKesTsvb7T5RH4"]