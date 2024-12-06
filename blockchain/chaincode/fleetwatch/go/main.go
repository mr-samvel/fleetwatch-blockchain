package main

import (
	"log"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

func main() {
	cc, err := contractapi.NewChaincode(
		new(VehiclesContract),
		new(FleetManagerContract),
		new(RepairShopContract),
		new(InsuranceProviderContract))
	if err != nil {
		log.Panicf("Error creating vehicles chaincode: %v", err)
	}
	if err := cc.Start(); err != nil {
		log.Panicf("Error starting the vehicles chaincode: %v", err)
	}
}
