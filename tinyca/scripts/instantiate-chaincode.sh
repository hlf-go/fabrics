#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Instantiating chaincode --"
echo
#
# Once you have successfully install a new chaincode you need to instantiate it. Remember to change the 
# value of the -v field to match the one shown above.
# Note: These are arguments currently has no effect until you have implemented something to consume it.
peer chaincode instantiate -o orderer.example.com:7050 --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem -C $CHANNELNAME -n $CHAINCODEID -v 1.0 -c '{"Args":["methodName","a","100","b","200"]}' -P "OR ('Org1MSP.member')" 

