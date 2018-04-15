#!/bin/bash

. ./scripts/common.sh

peer channel create -o $ORDERER -c $CHANNELNAME -f ./channel-artifacts/channel.tx --tls --cafile $ORDERER_CA
peer channel join -o $ORDERER -b ./$CHANNELNAME.block --tls --cafile $ORDERER_CA