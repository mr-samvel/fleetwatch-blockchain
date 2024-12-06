package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type InsuranceProviderContract struct {
	contractapi.Contract
}

func (c *InsuranceProviderContract) GetLatestVehicleStatus(ctx contractapi.TransactionContextInterface, vehicleID string) (*VehicleTelemetryAsset, error) {
	telemetryKey, err := ctx.GetStub().CreateCompositeKey("vehicle-maintenance", []string{vehicleID})
	if err != nil {
		return nil, fmt.Errorf("failed to create composite key: %v", err)
	}

	latestTelemetry, err := ctx.GetStub().GetState(telemetryKey)
	if err != nil {
		return nil, fmt.Errorf("failed to get asset: %s with error: %s", vehicleID, err)
	}
	if latestTelemetry == nil {
		return nil, fmt.Errorf("asset not found: %s", vehicleID)
	}

	var resTelemetry VehicleTelemetryAsset
	err = json.Unmarshal(latestTelemetry, &resTelemetry)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal telemetry: %v", err)
	}
	return &resTelemetry, nil
}
