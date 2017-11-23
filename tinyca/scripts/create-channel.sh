#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Creating channel --"
echo
#
# This command need only to be call when you have a brand new fabric infrastructure
# 
peer channel create -o orderer.example.com:7050 -c $CHANNELNAME -f ./channel-artifacts/channel.tx --tls true --cafile $ORDERER_CA