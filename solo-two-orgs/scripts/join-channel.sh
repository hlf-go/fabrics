#!/bin/bash

. ./scripts/common.sh

peer channel fetch newest -o $ORDERER -c $CHANNELNAME --tls --cafile $ORDERER_CA $CHANNELNAME.block
peer channel join -o $ORDERER -b ./$CHANNELNAME.block --tls --cafile $ORDERER_CA