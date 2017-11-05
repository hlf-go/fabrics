#!/bin/bash

# This script is not applicable to infatructure with no tls

# This example scripts demonstrates the use of fabric-client cli to 
# enroll a bootstrapped credentials:
#     username: admin
#     password" adminpw
echo "Enrolling admin:adminpw"
fabric-ca-client enroll -u http://admin:adminpw@fabric-ca-server:7054
echo "Client enrolled!"
echo

id_attrs='hf.Revoker=true,admin=true:ecert'
# Registering a peer following a successful enrollment.
#  id.type: peer
#  id.name: admin2
#  id.affliliation: org1.department1
#  id.attrs: '$id_attrs'
echo "Registering"
fabric-ca-client register --id.type peer --id.name admin2 --id.affiliation org1.department1 --id.attrs $id_attrs
echo "Peer registered"

# Search fabric-ca-server database for: 
#  admin
#  admin2
echo "Search database for users"
sqlite3 ../fabric-ca-server/fabric-ca-server.db "select * from users"
echo "End of search"

# Show list of certs
echo "Search database for cerfiticates"
sqlite3 ../fabric-ca-server/fabric-ca-server.db "select * from certificates"
echo "End of search"