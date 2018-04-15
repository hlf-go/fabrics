#!/bin/bash

. ./scripts/common.sh

ARGS_NUMBER="$#"
COMMAND="$1"

usage_message="Useage: $0 start | restart | clean | status"

function verifyArg() {
    if [ $ARGS_NUMBER -ne 1 ]; then
        echo $usage_message
        exit 1;
    fi
}

function verifyGOPATH(){

    if [ -z "$GOPATH" ]; then
        echo "Please set GOPATH"
        exit 1
    fi

    if [ ! -d $GOPATH/bin ]; then
        mkdir $GOPATH/bin
    fi

}

function pullDockerImages(){

  for IMAGES in ca peer orderer ccenv tools; do
      echo "==> FABRIC IMAGE: $IMAGES"
      echo
      docker pull hyperledger/fabric-$IMAGES:$FABRIC_VERSION
      docker tag hyperledger/fabric-$IMAGES:$FABRIC_VERSION hyperledger/fabric-$IMAGES
  done
}

function buildNetworkConfig(){
    docker build -t paul-sitoh/fabric-config ./network-config
}

function generateCerts(){

    if [ ! -f $GOPATH/bin/cryptogen ]; then
        pushd $GOPATH/src/github.com/hyperledger/fabric
        make cryptogen
        cp ./build/bin/cryptogen $GOPATH/bin/cryptogen
        popd    
    fi
    
    echo
	echo "----------------------------------------------------------"
	echo "----- Generate certificates using cryptogen tool ---------"
	echo "----------------------------------------------------------"
	if [ -d ./crypto-config ]; then
		rm -rf ./crypto-config
	fi

    $GOPATH/bin/cryptogen generate --config=./crypto-config.yaml
    echo
}

function networkRestart(){
    docker-compose down
    docker-compose up -d
}

function generateChannelArtifacts(){

    if [ ! -d ./channel-artifacts ]; then
		mkdir channel-artifacts
	fi

	if [ ! -f $GOPATH/bin/configtxgen ]; then
        pushd $GOPATH/src/github.com/hyperledger/fabric
        make configtxgen
        cp ./build/bin/configtxgen $GOPATH/bin/configtxgen
        popd
    fi

    echo
	echo "-----------------------------------------------------------------"
	echo "--- Generating channel configuration transaction 'channel.tx' ---"
	echo "-----------------------------------------------------------------"

    $GOPATH/bin/configtxgen -profile MyOrgsOrdererGenesis -outputBlock ./channel-artifacts/genesis.block

    echo
	echo "-------------------------------------------------"
	echo "--- Generating anchor peer update for Org1MSP ---"
	echo "-------------------------------------------------"
    $GOPATH/bin/configtxgen -profile MyOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNELNAME

}

function startNetwork() {

    echo
    echo "----------------------------"
    echo "--- Starting the network ---"
    echo "----------------------------"
    docker-compose up -d
}

function cleanNetwork() {
    
    if [ -d ./channel-artifacts ]; then
        rm -rf ./channel-artifacts
    fi

    if [ -d ./crypto-config ]; then
        PLATFORM=`uname -s`
        if [ "$PLATFORM" != "Darwin" ]; then
            sudo chown -R $USER:$USER ./crypto-config
        fi
        rm -rf ./crypto-config
    fi

    if [ -d ./tools ]; then
        rm -rf ./tools
    fi

    # This operations removes all docker containers and images regardless
    #
    docker rm -f $(docker ps -aq)
    docker rmi -f $(docker images -q)
    
    # This removes containers used to support the running chaincode.
    #docker rm -f $(docker ps --filter "name=dev" --filter "name=peer0.org1.example.com" --filter "name=cli" --filter "name=orderer.example.com" -q)

    # This removes only images hosting a running chaincode, and in this
    # particular case has the prefix dev-* 
    #docker rmi $(docker images | grep dev | xargs -n 1 docker images --format "{{.ID}}" | xargs -n 1 docker rmi -f)
}

function downloadExampleChaincodes(){ 
    if [ ! -d $GOPATH/src/github.com/hlf-go/example-chaincodes ]; then
        go get -d github.com/hlf-go/example-chaincodes
    fi
}

function getFabricSourceCode(){
    if [ ! -d $GOPATH/src/github.com/hyperledger/fabric ]; then
        go get github.com/hyperledger/fabric
    fi
}

function createSecretPrivKeys(){

    pushd ./crypto-config/peerOrganizations/org1.fabric.network/ca
    PK=$(ls *_sk)
    mv $PK secret.key
    popd

    pushd ./crypto-config/peerOrganizations/org2.fabric.network/ca
    PK=$(ls *_sk)
    mv $PK secret.key
    popd

}

function networkStatus(){
    docker ps --format "table {{.Names}}\t{{.Status}}" --filter "name=fabric.network"
}

# Network operations
verifyArg
verifyGOPATH
getFabricSourceCode
downloadExampleChaincodes
case $COMMAND in
    "start")
        generateCerts
        generateChannelArtifacts
        createSecretPrivKeys
        buildNetworkConfig
        pullDockerImages
        startNetwork
        ;;
    "restart")
        networkRestart
        ;;
    "status")
        networkStatus
        ;;
    "clean")
        cleanNetwork
        ;;
    *)
        echo $usage_message
        exit 1
esac
