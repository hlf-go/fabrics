#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Invoking chaincode --"
echo
#
# Use this command to run the Invoke method in the chaincode
# Note: These are arguments currently has no effect until you have implemented something to consume it.
peer chaincode invoke -o orderer.example.com:7050 --logging-level DEBUG --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem -C $CHANNELNAME -n $CHAINCODEID -c '{"Args":["methodName","a","b","10"]}'

