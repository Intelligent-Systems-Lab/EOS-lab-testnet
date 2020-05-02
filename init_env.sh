if [ $1 = "default" ]
then
    echo "export eos_endpoint=172.17.0.2:8888" >> ~/.bashrc
else
    echo "export eos_endpoint=$2:8888" >> ~/.bashrc
fi
source ~/.bashrc
