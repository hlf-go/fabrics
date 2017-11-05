#!/bin/bash

args_number="$#"
command="$1"
option="$2"

usage_message="Usage: $0 start [--tls]  | reset | cli"

function verifyArg() {

    if [ $args_number -lt 1 ] || [ $args_number -gt 2 ]; then
        echo $usage_message
        exit 1;
    fi
}

function buildCliTool(){
    docker build -t paul-sitoh/fabric-ca-testkit ./ca-client-wrapper/
}

function startServerTLS(){
    echo "Currently not available ....."
}

function startServerNoTLS(){
    docker-compose -f docker-compose-no-tls.yaml up -d
}

function startServer(){
    tls_arg="$1"

    buildCliTool
    case $tls_arg in
        "")
          echo "Starting server without tls ...."
          startServerNoTLS
          ;;
        "--tls")
          echo "Starting server with tls ..."
          startServerTLS
          ;;
        *)
          echo $usage_message
          exit 1;
          ;;
    esac
}

function cli(){
    docker exec -it ca-client /bin/bash
}
function cleanDocker(){
    docker rm -f $(docker ps -aq)
    docker rmi -f $(docker images -q)
}

function cleanDir(){
    rm -rf fabric-ca-client/
    rm -rf fabric-ca-server/
}

function resetServer(){
    option=$1

    if [ "$option" != "" ]; then
        echo "Ignoring argument $option."
        echo "Defaulting to Usage: $0 reset"
    fi
    cleanDocker
    cleanDir
}


verifyArg
case $command in
    "start")
        startServer $option
        ;;
    "reset")
        resetServer $option
        ;;
    "cli")
        cli
        ;;
    *)
        echo $usage_message
        exit 1;
esac