#!/bin/bash
# Script to query blocks
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=10.255.255.254:7103
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/insuranceproviders.org0.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
export ORDERER_ADDRESS=10.255.255.254:7109
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/demo.com/orderers/orderer.demo.com/tls/ca.crt
output=$(peer channel getinfo -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA -c channel0)
CBHASH=$(echo ${output:17}|jq '.currentBlockHash'|xargs)
peer channel fetch newest -o $ORDERER_ADDRESS --tls \
  --cafile $ORDERER_TLS_CA -c channel0

configtxlator proto_decode --input channel0_newest.block \
  --type common.Block | jq --arg CBHASH $CBHASH -f run/blockquery.jq \
  > channel0_newest_txs.json
