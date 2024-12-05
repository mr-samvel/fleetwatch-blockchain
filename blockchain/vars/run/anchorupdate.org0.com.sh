#!/bin/bash
# Script to instantiate chaincode
cp $FABRIC_CFG_PATH/core.yaml /vars/core.yaml
cd /vars
export FABRIC_CFG_PATH=/vars

export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_ID=cli
export CORE_PEER_ADDRESS=10.255.255.254:7101
export CORE_PEER_TLS_ROOTCERT_FILE=/vars/keyfiles/peerOrganizations/org0.com/peers/fleetmanager.org0.com/tls/ca.crt
export CORE_PEER_LOCALMSPID=org0-com
export CORE_PEER_MSPCONFIGPATH=/vars/keyfiles/peerOrganizations/org0.com/users/Admin@org0.com/msp
export ORDERER_ADDRESS=10.255.255.254:7109
export ORDERER_TLS_CA=/vars/keyfiles/ordererOrganizations/demo.com/orderers/orderer.demo.com/tls/ca.crt

# 1. Fetch the channel configuration
peer channel fetch config config_block.pb -o $ORDERER_ADDRESS \
  --cafile $ORDERER_TLS_CA --tls -c channel0

# 2. Translate the configuration into json format
configtxlator proto_decode --input config_block.pb --type common.Block \
  | jq .data.data[0].payload.data.config > channel0_current_config.json
echo "--<<-->>--"

# 3. Update the current config in json with the organization anchor peer we want to add
jq '.channel_group.groups.Application.groups."org0-com".values += {"AnchorPeers":{"mod_policy": "Admins","value":{"anchor_peers": [{"host": "10.255.255.254","port": 7101}]},"version": "0"}}' channel0_current_config.json > channel0_modified_anchor_config.json

# 4. Translate the current config in json format to protobuf format
configtxlator proto_encode --input channel0_current_config.json \
  --type common.Config --output config.pb

# 5. Translate the desired config in json format to protobuf format
configtxlator proto_encode --input channel0_modified_anchor_config.json \
  --type common.Config --output modified_config.pb

# 6. Calculate the delta of the current config and desired config
configtxlator compute_update --channel_id channel0 \
  --original config.pb --updated modified_config.pb \
  --output channel0_anchor_update.pb

# 7. Decode the delta of the config to json format
configtxlator proto_decode --input channel0_anchor_update.pb \
  --type common.ConfigUpdate | jq . > channel0_anchor_update.json

# 8. Now wrap of the delta config to fabric envelop block
echo '{"payload":{"header":{"channel_header":{"channel_id":"channel0", "type":2}},"data":{"config_update":'$(cat channel0_anchor_update.json)'}}}' | jq . > channel0_anchor_update_envelope.json

# 9. Encode the json format into protobuf format
configtxlator proto_encode --input channel0_anchor_update_envelope.json \
  --type common.Envelope --output channel0_anchor_update_envelope.pb

# 10. Need to sign anchor update envelop by org admin
peer channel update -o $ORDERER_ADDRESS --tls --cafile $ORDERER_TLS_CA \
  -f channel0_anchor_update_envelope.pb -c channel0
