#!/bin/bash

args_number=$#
command=$1
arg_1=$2
arg_2=$3
arg_3=$4
arg_4=$5
arg_5=$6

create_channel_usage="create-channel <channelname> <channel tx>"
join_channel_usage="join-channel <channelname>"
install_chaincode_usage="install-chaincode <chaincode id> <chaincode version> <path to chaincode>"
instantiate_chaincode_usage="instantiate-chaincode <channel name> <chaincode id> <chaincode version> <arguments> <endorsement>"
usage_message="Usage: $0 $create_channel_usage | $join_channel_usage | $install_chaincode_usage"

function createChannel() {
    channel_name="$1"
    channel_tx="$2"
    peer channel create -o orderer.example.com:7050 -c $channel_name -f $channel_tx --tls true --cafile $ORDERER_CA  
}

function joinChannel() {
    channel_name="$1"
    peer channel join -b $channel_name.block --tls true --cafile $ORDERER_CA
}

function installChaincode() {
    chaincode_id=$1
    chaincode_version=$2
    path_to_chaincode=$3
    peer chaincode install -n "$chaincode_id" -v "$chaincode_version" -p "$path_to_chaincode"
}

function instantiateChaincode() {
    channel_name="$1"
    chainchode_id="$2"
    chaincode_version="$3"
    arguments="$4"
    endorsment="$5"
    peer chaincode instantiate -o orderer.example.com:7050 -C $channel_name -n $chainchode_id -v $chaincode_version -c $arguments -P $endorsment  --tls true --cafile $ORDERER_CA 
}

case $command in
    create-channel)
        if [ $args_number -ne 3 ]; then
            echo "Usage: $0 $create_channel_usage"
            exit 1
        fi
        createChannel $arg_1 $arg_2
        ;;
    join-channel)
        if [ $args_number -ne 2 ]; then
            echo "Usage: $0 $join_channel_usage"
            exit 1
        fi
        joinChannel $arg_1
        ;;
    install-chaincode)
        if [ $args_number -ne 4 ]; then
            echo "Usage: $0 $install_chaincode_usage"
            exit 1
        fi
        installChaincode $arg_1 $arg_2 $arg_3
        ;;
    instantiate-chaincode)
        if [ $args_number -ne 6 ]; then
            echo "Usage: $0 $instantiate_chaincode_usage"
            exit 1
        fi
        instantiateChaincode $arg_1 $arg_2 $arg_3 $arg_4 $arg_5
        ;;
    *)
        echo $usage_message
        exit 1
esac