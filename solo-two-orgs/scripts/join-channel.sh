#!/bin/bash

. ./scripts/common.sh

peer channel fetch newest -o orderer.test.com:7050 -c $CHANNELNAME --tls --cafile $ORDERER_CA $CHANNELNAME.block
peer channel join -o orderer.test.com:7050 -b ./$CHANNELNAME.block --tls --cafile $ORDERER_CA