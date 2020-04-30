# EOS-lab-testnet

## Use docker 

```shell=
# node1 v4  
docker run -d -it -p 8881:8080/tcp -p 8891:8888/tcp --name eos1 tony92151/eos_lab:v4

# node2 v4
docker run -d -it -p 8882:8080/tcp -p 8892:8888/tcp --name eos2 tony92151/eos_lab:v4

# remove node1
docker container rm -f eos1
```
or use script
```shell=
# start node1 for v4
bash run_docker.sh run 1 v4

# remove node1
bash run_docker.sh rm 1
```