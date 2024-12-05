#!/bin/bash
# Script to install chaincode onto a peer node
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=10.255.255.254:7104
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/vehicles.org0.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
cd /go/src/github.com/chaincode/vehicles


if [ ! -f "vehicles_go_0.0.1.tar.gz" ]; then
  cd go
  GO111MODULE=on
  go mod vendor
  cd -
  peer lifecycle chaincode package vehicles_go_0.0.1.tar.gz \
    -p /go/src/github.com/chaincode/vehicles/go/ \
    --lang golang --label vehicles_0.0.1
fi

peer lifecycle chaincode install vehicles_go_0.0.1.tar.gz
