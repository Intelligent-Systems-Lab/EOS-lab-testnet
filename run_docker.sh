version=$3
num=$2




if [ $1 == "run" ]
then
    echo "Start node $num for $version"
    docker run -d -it -p 888$num:8080/tcp -p 889$num:8888/tcp --name eos$num tony92151/eos_lab:$version
elif [ $1 == "rm" ]
then
    echo "Remove node $num"
    docker container rm -f eos$num
fi