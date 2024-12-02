#!/bin/bash
# Script to instantiate chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=10.255.255.254:7102
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/repairshop.org0.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
export ORDERER_ADDRESS=10.255.255.254:7109
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/demo.com/orderers/orderer.demo.com/tls/ca.crt
SID=$(peer lifecycle chaincode querycommitted -C channel0 -O json \
  | jq -r '.chaincode_definitions|.[]|select(.name=="vehicles")|.sequence' || true)

if [[ -z $SID ]]; then
  SEQUENCE=1
else
  SEQUENCE=$((1+$SID))
fi

peer lifecycle chaincode commit -o $ORDERER_ADDRESS --channelID channel0 \
  --name vehicles --version 1.0 --sequence $SEQUENCE \
  --peerAddresses 10.255.255.254:7101 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/org0.com/peers/fleetmanager.org0.com/tls/ca.crt \
  --init-required \
  --cafile $ORDERER_TLS_CA --tls
