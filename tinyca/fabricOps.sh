#!/bin/bash

args_number="$#"
command="$1"

usage_message="Usage: $0 start | reset | cli"

crypto_assets="crypto-config"
channel_assets="channel-artifacts"

function verifyArg() {

    if [ $args_number -lt 1 ] || [ $args_number -gt 2 ]; then
        echo $usage_message
        exit 1;
    fi
}

function removeFabricAssets(){

    if [ -d $crypto_assets ]; then
        rm -rf $crypto_assets
    fi

    if [ -d $channel_assets ]; then
        rm -rf $channel_assets
    fi

    if [ -f docker-compose.yamlt ]; then
        rm docker-compose.yamlt
    fi

    if [ -f docker-compose.yaml ]; then
        rm docker-compose.yaml
    fi
}

function generateFabricAssets(){
    removeFabricAssets

    if [ ! -f $GOPATH/bin/cryptogen ]; then
        go get github.com/hyperledger/fabric/common/tools/cryptogen
    fi
    $GOPATH/bin/cryptogen generate --config=./crypto-config.yaml

    if [ ! -d ./channel-artifacts ]; then
		mkdir channel-artifacts
	fi
	if [ ! -f $GOPATH/bin/configtxgen ]; then
        go get github.com/hyperledger/fabric/common/configtx/tool/configtxgen
    fi  
    $GOPATH/bin/configtxgen -profile MyOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

    $GOPATH/bin/configtxgen -profile MyOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID "mychannel"
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
    cd $crypto_assets/peerOrganizations/org1.example.com/tlsca/
    PRIV_KEY=$(ls *_sk)
    cd $CURRENT_DIR
    sed $OPTS "s/CA_TLS_KEY/${PRIV_KEY}/g" docker-compose.yaml
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