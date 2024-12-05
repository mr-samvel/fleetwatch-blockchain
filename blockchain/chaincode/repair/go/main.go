package main

import (
	"log"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	repairContract := new(RepairShopsContract)

	cc, err := contractapi.NewChaincode(repairContract)
	if err != nil {
		log.Panicf("Error creating vehicles chaincode: %v", err)
	}
	if err := cc.Start(); err != nil {
		log.Panicf("Error starting the vehicles chaincode: %v", err)
	}
}
