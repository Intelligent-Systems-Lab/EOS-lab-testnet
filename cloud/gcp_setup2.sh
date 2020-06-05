echo "     ----------       --------        ---            "
echo "    |          |    /          |     |   |           "
echo "     ---    ---     |   ------       |   |           "
echo "        |  |        |  |             |   |           "
echo "        |  |        |   ------       |   |           "
echo "        |  |         \         \     |   |           "
echo "        |  |           -----   |     |   |           "
echo "        |  |                |  |     |   \           "
echo "     ---    ---      -------   |     |    --------   "
echo "    |          |    |          /     \            |  "
echo "     ----------      ---------        ------------   "
echo


set_initpkg(){
    sudo apt-get update 
    sudo apt-get -y upgrade
    sudo apt-get install -y apt-utils openssh-server software-properties-common
    sudo apt-get install -y autotools-dev automake curl git wget zip build-essential gcc pkg-config net-tools nano
    sudo apt-get install -y python3 pyton3-pip3

    pip3 install numpy
}



set_cmake(){
    wget https://github.com/Kitware/CMake/releases/download/v3.12.0/cmake-3.12.0.tar.gz &&\
    tar zxvf cmake-3.12.0.tar.gz
    cd cmake-3.12.0
    ./bootstrap
    sudo make -j8
    sudo make install
    cd 
    rm -r cmake-3.12.0.tar.gz cmake-3.12.0
    cmake --version
}

set_eos(){
    wget https://github.com/EOSIO/eos/releases/download/v2.0.5/eosio_2.0.5-1-ubuntu-18.04_amd64.deb
    sudo apt -y install ./eosio_2.0.5-1-ubuntu-18.04_amd64.deb
    rm eosio_2.0.5-1-ubuntu-18.04_amd64.deb

    wget https://github.com/EOSIO/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
    sudo apt -y install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
    rm eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
}

read -p "Press [Enter] to run continue..."

set_initpkg
set_eos

