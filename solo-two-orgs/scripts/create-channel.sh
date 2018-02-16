#!/bin/bash

. ./scripts/common.sh

peer channel create -o orderer.test.com:7050 -c $CHANNELNAME -f ./channel-artifacts/channel.tx --tls --cafile $ORDERER_CA
peer channel join -o orderer.test.com:7050 -b ./$CHANNELNAME.block --tls --cafile $ORDERER_CA