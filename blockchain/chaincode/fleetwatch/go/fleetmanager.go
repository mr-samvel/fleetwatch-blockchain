package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type FleetManagerContract struct {
	contractapi.Contract
}

type DriverRating struct {
	DriverID string
	Rating string // 'excelente', 'mediano', 'ruim'
}

func (c *FleetManagerContract) GetDriversRatings(ctx contractapi.TransactionContextInterface) (map[string]) {
	// pega todos os diagnosticos associados ao motorista
	ctx.GetStub().GetQueryResult('{vehicle-telemetry: {driver_id: x}}')
	// se o numero de diagnosticos for > x
		// motorista.rating = ruim
	// se x >= diagnosticos >= y
		// motorista.rating = mediano
	// se nao
		// motorista.rating = excelente
	// return motorista
}

func (c *FleetManagerContract) GetAllVehiclesStatus(ctx contractapi.TransactionContextInterface) ([]VehicleStatus, error) {
	telemetryMap, err := c.GetAllVehiclesTelemetries(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get telemetries: %v", err)
	}

	diagnosticMap, err := c.GetAllVehiclesDiagnostics(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get diagnostics: %v", err)
	}

	var vehicleStatuses []VehicleStatus
	for vehicleID, telemetry := range telemetryMap {
		status := VehicleStatus{
			VehicleID:   vehicleID,
			Telemetry:   telemetry,
			Diagnostics: diagnosticMap[vehicleID],
		}
		vehicleStatuses = append(vehicleStatuses, status)
	}

	for vehicleID, diagnostic := range diagnosticMap {
		if _, exists := telemetryMap[vehicleID]; !exists {
			status := VehicleStatus{
				VehicleID:   vehicleID,
				Diagnostics: diagnostic,
			}
			vehicleStatuses = append(vehicleStatuses, status)
		}
	}

	return vehicleStatuses, nil
}

func (c *FleetManagerContract) GetAllVehiclesTelemetries(ctx contractapi.TransactionContextInterface) (map[string]*TelemetryData, error) {
	telemetryIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("vehicle-telemetry", []string{})
	if err != nil {
		return nil, fmt.Errorf("failed to get telemetry iterator: %v", err)
	}
	defer telemetryIterator.Close()

	telemetryMap := make(map[string]*TelemetryData)

	for telemetryIterator.HasNext() {
		kv, err := telemetryIterator.Next()
		if err != nil {
			return nil, fmt.Errorf("failed to iterate telemetry: %v", err)
		}

		_, compositeKeyParts, err := ctx.GetStub().SplitCompositeKey(kv.Key)
		if err != nil {
			return nil, fmt.Errorf("failed to split composite key: %v", err)
		}

		vehicleID := compositeKeyParts[0]
		var telemetry TelemetryData
		err = json.Unmarshal(kv.Value, &telemetry)
		if err != nil {
			return nil, fmt.Errorf("failed to unmarshal telemetry: %v", err)
		}
		telemetryMap[vehicleID] = &telemetry
	}
	return telemetryMap, nil
}

func (c *FleetManagerContract) GetAllVehiclesDiagnostics(ctx contractapi.TransactionContextInterface) (map[string]*DiagnosticData, error) {
	diagnosticIterator, err := ctx.GetStub().GetStateByPartialCompositeKey("vehicle-diagnostic", []string{})
	if err != nil {
		return nil, fmt.Errorf("failed to get diagnostic iterator: %v", err)
	}
	defer diagnosticIterator.Close()

	diagnosticMap := make(map[string]*DiagnosticData)

	for diagnosticIterator.HasNext() {
		kv, err := diagnosticIterator.Next()
		if err != nil {
			return nil, fmt.Errorf("failed to iterate diagnostics: %v", err)
		}

		_, compositeKeyParts, err := ctx.GetStub().SplitCompositeKey(kv.Key)
		if err != nil {
			return nil, fmt.Errorf("failed to split composite key: %v", err)
		}

		vehicleID := compositeKeyParts[0]
		var diagnostic DiagnosticData
		err = json.Unmarshal(kv.Value, &diagnostic)
		if err != nil {
			return nil, fmt.Errorf("failed to unmarshal diagnostic: %v", err)
		}
		diagnosticMap[vehicleID] = &diagnostic
	}

	return diagnosticMap, nil
}
