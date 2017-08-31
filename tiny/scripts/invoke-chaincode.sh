#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Invoking chaincode --"
echo
#
# Use this command to run the Invoke method in the chaincode
# Note: These are arguments currently has no effect until you have implemented something to consume it.
peer chaincode invoke -o orderer.example.com:7050 -C $CHANNELNAME -n $CHAINCODEID -c '{"Args":["methodName","a","b","10"]}'

