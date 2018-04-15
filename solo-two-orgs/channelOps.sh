#!/bin/bash

# org1 is the lead organisation responsible for creating channel
docker exec cli.peer0.org1.fabric.network /bin/bash -c '${PWD}/scripts/create-channel.sh'

# org2 is invited to join the channel
docker exec cli.peer0.org2.fabric.network /bin/bash -c '${PWD}/scripts/join-channel.sh'

