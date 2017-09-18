#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Creating channel --"
echo
#
# This command need only to be call when you have a brand new fabric infrastructure
# 
peer channel create --logging-level DEBUG -o orderer.example.com:7050 -c $CHANNELNAME -f ./channel-artifacts/channel.tx --tls true --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/tlsca/tlsca.example.com-cert.pem  
