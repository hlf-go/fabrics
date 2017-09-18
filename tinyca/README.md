# Introduction

A collection of scripts to help you create a fabric network comprising:

* One peer attached to couchDB
* One orderer
* One cli
* One CA

TLS is set by default.

# Notes

1. The docker-compose script assumes that we are using bridge network mode `peer0.org1.example.com` in the [docker-compose.yaml](./docker-compose.yaml). Please ensure that `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE` matches your root directory name accordingly.

    For example, if the root directory is call `fabric-tiny` set this variable accordingly:

    - `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=fabrictiny_default`

    Note: network mode variable does not accept non-alphabets and it must include the postfix `default`.

1. In the `cli` container ensure that you map the volume of where your chaincode is found. For example, if you have your chaincode in `$GOPATH/src/github.com/hlf-go/example-chaincodes`, ensure that it is set accordingly in the volume section of `cli` container as follows:

    ```
    cli:
        container_name: cli
        image: hyperledger/fabric-tools
        ......
        volumes:
        .....
        - $GOPATH/src/github.com/hlf-go/example-chaincodes:/opt/gopath/src/github.com/hyperledger/fabric/examples/chaincode/go
    ```
 