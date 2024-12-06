package main

import (
	"encoding/json"
	"fmt"
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type RepairShopContract struct {
	contractapi.Contract
}

type MaintenanceReport struct {
	Timestamp   int      `json:"timestamp"`
}

func (c *RepairShopContract) GetLatestVehicleDiagnostic(ctx contractapi.TransactionContextInterface, vehicleID string) (*DiagnosticData, error) {
	telemetryKey, err := ctx.GetStub().CreateCompositeKey("vehicle-diagnostic", []string{vehicleID})
	if err != nil {
		return nil, fmt.Errorf("failed to create composite key: %v", err)
	}

	latestDiagnostic, err := ctx.GetStub().GetState(telemetryKey)
    if err != nil {
            return nil, fmt.Errorf("Failed to get asset: %s with error: %s", vehicleID, err)
    }
    if latestDiagnostic == nil {
            return nil, fmt.Errorf("Asset not found: %s", vehicleID)
    }

	var resDiagnostic DiagnosticData
	err = json.Unmarshal(latestDiagnostic, &resDiagnostic)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal telemetry: %v", err)
	}
	return &resDiagnostic, nil
}

func (c *RepairShopContract) RecordMaintenance(ctx contractapi.TransactionContextInterface, vehicleId string, maintenanceData string) error {
	var maintenance MaintenanceReport
	err := json.Unmarshal([]byte(maintenanceData), &maintenance)
	if err != nil {
		return fmt.Errorf("failed to unmarshal telemetry data: %v", err)
	}

	maintenanceKey, err := ctx.GetStub().CreateCompositeKey("maintenance-report", []string{vehicleId})
	if err != nil {
		return fmt.Errorf("failed to create composite key: %v", err)
	}

	maintenanceBytes, err := json.Marshal(maintenance)
	if err != nil {
		return fmt.Errorf("failed to marshal telemetry data: %v", err)
	}

	return ctx.GetStub().PutState(maintenanceKey, maintenanceBytes)
}