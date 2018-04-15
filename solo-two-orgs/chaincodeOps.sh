#!/bin/bash

ARGS_NUMBER="$#"
COMMAND="$1"

usage_message="Useage: $0 install | instantiate | update "

if [ $ARGS_NUMBER -ne 1 ]; then
    echo $usage_message
    exit
fi

function installChaincode(){
    docker exec cli.peer0.org1.fabric.network /bin/bash -c '${PWD}/scripts/install-chaincode.sh -c mycc -v 1.0 -p minimalcc'
    docker exec cli.peer0.org2.fabric.network /bin/bash -c '${PWD}/scripts/install-chaincode.sh -c mycc -v 1.0 -p minimalcc'
}

function instantiateChaincode(){
    docker exec cli.peer0.org1.fabric.network /bin/bash -c '${PWD}/scripts/instantiate-chaincode.sh -c mycc -v 1.0'
}

function updateChaincode(){
    docker exec cli.peer0.org1.fabric.network /bin/bash -c '${PWD}/scripts/update-chaincode.sh -c mycc -v 1.0'
}

case $COMMAND in
    "install")
        installChaincode
        ;;
    "instantiate")
        instantiateChaincode
        ;;
    "update")
        updateChaincode
        ;;
    *)
        echo $usage_message
        exit 1
esac