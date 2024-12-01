#!/bin/bash
# Script to approve chaincode
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=10.255.255.254:7102
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/repairshop.org0.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
export ORDERER_ADDRESS=10.255.255.254:7109
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/demo.com/orderers/orderer.demo.com/tls/ca.crt

peer lifecycle chaincode queryinstalled -O json | jq -r '.installed_chaincodes | .[] | select(.package_id|startswith("vehicles_0.0.3:"))' > ccstatus.json

PKID=$(jq '.package_id' ccstatus.json | xargs)
REF=$(jq '.references.channel0' ccstatus.json)

SID=$(peer lifecycle chaincode querycommitted -C channel0 -O json \
  | jq -r '.chaincode_definitions|.[]|select(.name=="vehicles")|.sequence' || true)
if [[ -z $SID ]]; then
  SEQUENCE=1
elif [[ -z $REF ]]; then
  SEQUENCE=$SID
else
  SEQUENCE=$((1+$SID))
fi


export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/repairshop.org0.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
export CORE_PEER_ADDRESS=10.255.255.254:7102

# approved=$(peer lifecycle chaincode checkcommitreadiness --channelID channel0 \
#   --name vehicles --version 0.0.3 --init-required --sequence $SEQUENCE --tls \
#   --cafile $ORDERER_TLS_CA --output json | jq -r '.approvals.org0-com')

# if [[ "$approved" == "false" ]]; then
  peer lifecycle chaincode approveformyorg --channelID channel0 --name vehicles \
    --version 0.0.3 --package-id $PKID \
  --init-required \
    --sequence $SEQUENCE -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA
# fi
