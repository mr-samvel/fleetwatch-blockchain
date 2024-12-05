#!/bin/bash
# Script to discover endorsers and channel config
cd /vars

export PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/tls/ca.crt
export ADMINPRIVATEKEY=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp/keystore/priv_sk
export ADMINCERT=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp/signcerts/Admin@org0.com-cert.pem

discover endorsers --peerTLSCA $PEER_TLS_ROOTCERT_FILE \
  --userKey $ADMINPRIVATEKEY \
  --userCert $ADMINCERT \
  --MSP org0-com --channel channel0 \
  --server 10.255.255.254:7101 \
  --chaincode vehicles | jq '.[0]' | \
  jq 'del(.. | .Identity?)' | jq 'del(.. | .LedgerHeight?)' \
  > /vars/discover/channel0_vehicles_endorsers.json

discover config --peerTLSCA $PEER_TLS_ROOTCERT_FILE \
  --userKey $ADMINPRIVATEKEY \
  --userCert $ADMINCERT \
  --MSP org0-com --channel channel0 \
  --server 10.255.255.254:7101 > /vars/discover/channel0_config.json
