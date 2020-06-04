# in https://cloud.google.com/free/docs/gcp-free-tier?hl=en#always-free-usage-limits
# we use free "App Engine" f1-micro (1 vCPU, 0.6 GB RAM) 720 hours/month
# ubuntu 18.04

# install docker
# https://docs.docker.com/engine/install/ubuntu/

sudo apt-get remove docker docker-engine docker.io containerd runc

sudo apt-get update

sudo apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io