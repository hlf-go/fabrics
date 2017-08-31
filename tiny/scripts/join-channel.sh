#!/bin/bash

CHANNELNAME="mychannel"
CHAINCODEID="mycc"

echo
echo "-- Join channel --"
echo
#
# This command need only to be call when you have a brand new fabric infrastructure
# 
peer channel join -b $CHANNELNAME.block 