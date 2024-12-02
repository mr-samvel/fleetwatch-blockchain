#!/bin/bash
# Script to instantiate chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=10.255.255.254:7103
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/insuranceproviders.org0.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
export ORDERER_ADDRESS=10.255.255.254:7109
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/demo.com/orderers/orderer.demo.com/tls/ca.crt

peer chaincode invoke -o $ORDERER_ADDRESS --isInit \
  --cafile $ORDERER_TLS_CA --tls -C channel0 -n vehicles \
  --peerAddresses 10.255.255.254:7104 \
  --tlsRootCertFiles /vars/keyfiles/peerOrganizations/org0.com/peers/vehicles.org0.com/tls/ca.crt \
  -c '{"Args":[ "init","a","200","b","300" ]}' --waitForEvent
