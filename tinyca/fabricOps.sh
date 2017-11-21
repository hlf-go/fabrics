#!/bin/bash

args_number="$#"
command="$1"

usage_message="Usage: $0 start | reset | cli"

crypto_assets="crypto-config"

function verifyArg() {

    if [ $args_number -lt 1 ] || [ $args_number -gt 2 ]; then
        echo $usage_message
        exit 1;
    fi
}

function removeFabricAssets(){
    rm -rf $crypto_assets
    rm docker-compose.yamlt
    rm docker-compose.yaml
}

function generateFabricAssets(){
    removeFabricAssets
    $GOPATH/bin/cryptogen generate --config=./crypto-config.yaml
}

function replacePrivateKey() {

    echo # Replace key

	ARCH=`uname -s | grep Darwin`
	if [ "$ARCH" == "Darwin" ]; then
		OPTS="-it"
	else
		OPTS="-i"
	fi

	cp docker-compose.yaml.template docker-compose.yaml

    CURRENT_DIR=$PWD
    cd $crypto_assets/peerOrganizations/org1.example.com/ca/
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed $OPTS "s/CA_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yaml
}

function startServer(){
    replacePrivateKey
    docker-compose -f docker-compose.yaml up -d
}

function cli(){
    docker exec -it ca-client /bin/bash
}
function cleanDocker(){
    docker rm -f $(docker ps -aq)
    docker rmi -f $(docker images -q)
}

function cleanDir(){
    removeFabricAssets
    rm -rf fabric-ca-client/
    rm -rf fabric-ca-server/
}

function resetServer(){
    cleanDocker
    cleanDir
}


verifyArg
case $command in
    "start")
        generateFabricAssets
        startServer
        ;;
    "reset")
        resetServer
        ;;
    "cli")
        cli
        ;;
    *)
        echo $usage_message
        exit 1;
esac