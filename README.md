# Introduction

A collection of scripts to help you create a fabric network comprising:

* One peer attached to couchDB
* One orderer
* One cli

TLS is not set.

# How to use this network

1. Fork this repository

1. Run `go get <name of your repository>`

1. Ensure that the `peer0.org1.example.com` in the `[docker-compose.yaml](./docker-compose.yaml)` network setting matches the name of your root directory.

    For example, if the root directory is call `fabric-tiny` set this variable accordingly:

    - `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=fabrictiny_default`

    Note: network mode variable does not accept non-alphabets and it must include the postfix `default`.

1. In the `cli` container ensure that you map the volume of where your chaincode is found. For example if you have a chaincode in `$GOPATH/src/github.com/hlf-go/example-chaincodes`, ensure that it is set accordingly in the volume section of `cli` container as follows:

    ```
    cli:
        container_name: cli
        image: hyperledger/fabric-tools
        ......
        volumes:
        .....
        - $GOPATH/src/github.com/hlf-go/example-chaincodes:/opt/gopath/src/github.com/hyperledger/fabric/examples/chaincode/go
    ```

<hr>
To use this in the context of fabric chaincode development, please follow the recommended approach for Go projects (see [Go code organisation](https://golang.org/doc/code.html#Organization))  
<hr>