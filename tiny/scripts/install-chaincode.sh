#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Installing chaincode --"
echo
#
# Use this command only when you want to install a new chaincode
# If you made changes to you chaincode, you will need to change the
# version of the chaincode by changing the value of the -v field. Say from
# -v 1.0 to -v 2.0.
peer chaincode install -n $CHAINCODEID -v 1.0 -p github.com/hyperledger/fabric/examples/chaincode/go/minimalcc

