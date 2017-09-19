# Introduction

This project contains a collection of scripts to help you create a fabric network comprising:

* One peer attached to couchDB
* One orderer
* One cli
* One CA

TLS is set by default.

This represents the smallest configuration that you will need to spin up a TLS based network. A scaled up network will in the main be a replication of this basic setup.

This network is intended for educational purpose only.

# Notes

1. To spin up a network you will need to create a docker-compose file from this [template](./docker-compose-template.yaml). The script [fabricOps.sh](./fabricOps.sh) provides such capability. See function:

    ```
    function replacePrivateKey () {

        echo # Replace key

        ARCH=`uname -s | grep Darwin`
        if [ "$ARCH" == "Darwin" ]; then
            OPTS="-it"
        else
            OPTS="-i"
        fi

        cp docker-compose-template.yaml docker-compose.yaml

        CURRENT_DIR=$PWD
        cd crypto-config/peerOrganizations/org1.example.com/ca/
        PRIV_KEY=$(ls *_sk)
        cd $CURRENT_DIR
        sed $OPTS "s/CA1_PRIVATE_KEY/${PRIV_KEY}/g" docker-compose.yaml
    }
    ```

    The function replaces the keyword `CA1_PRIVATE_KEY` found in the template with the key found the name of the private key found `./crypto-config` folder.

1. The docker-compose script assumes that we are using bridge network mode `peer0.org1.example.com` in the [docker-compose-template.yaml](./docker-compose-template.yaml). Please ensure that `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE` matches your root directory name accordingly.

    In this particular case, the root directory is call `tinyca` set this variable accordingly:

    - `CORE_VM_DOCKER_HOSTCONFIG_NETWORKMODE=tinyca_default`

    You must append the postfix `default` to the root folder name.

1. This particular project include [scripts](./scripts) to:

    * Create channel
    * Join channel
    * Install chaincode
    * Instantiate chaincode
    * Invoke chaincode

    Each script provides a single operations. These are intended to help you appreciate what is involved the basic chaincode operations and quick way of verifying that the network has been setup accordingly. Feel free to replace it with your version.

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
 