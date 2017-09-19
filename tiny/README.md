# Introduction

This project contains a collection of scripts to help you create a fabric network comprising:

* One peer attached to couchDB
* One orderer
* One cli

TLS is not set.

The purpose of this fabric is to help you quickly view the interactions between your chaincode with Fabric.

# Notes

1. The docker-compose script assumes that we are using bridge network mode. In the [docker-compose-template.yaml](./docker-compose-template.yaml). Please ensure that `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE` for `peer0.org1.example.com` matches your root directory name accordingly.

    In this particular case, the root directory is call `tiny` set this variable accordingly:

    - `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=tiny_default`

    You must append the postfix `default` to the root folder name.

1. This particular project include [scripts](./scripts) to:

    * Create channel
    * Join channel
    * Install chaincode
    * Instantiate chaincode
    * Invoke chaincode

    Each script execute a single operation. These are intended to help you appreciate what is involved the basic chaincode operations and quick way of verifying that the network has been setup accordingly. Feel free to replace it with your version.

1. In the `cli` container map the volume containing the chaincode you wish to inspect. For example, if you have your chaincode in `$GOPATH/src/github.com/hlf-go/example-chaincodes`, ensure that it is set accordingly in the volume section of `cli` container as follows:

    ```
    cli:
        container_name: cli
        image: hyperledger/fabric-tools
        ......
        volumes:
        .....
        - $GOPATH/src/github.com/hlf-go/example-chaincodes:/opt/gopath/src/github.com/hyperledger/fabric/examples/chaincode/go
    ```