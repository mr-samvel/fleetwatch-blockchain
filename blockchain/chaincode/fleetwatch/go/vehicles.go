package main

import (
	"encoding/json"
	"fmt"

	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type VehiclesContract struct {
	contractapi.Contract
}

type TelemetryData struct {
	VehicleID     int `json:"vehicle_id"`
	Timestamp     int `json:"timestamp"`
	DriverID      int `json:"driver_id"`
	AvgEngineLoad int `json:"avg_engine_load"`
	AvgEngineRPM  int `json:"avg_engine_rpm"`
	CoolantTemp   int `json:"coolant_temp"`
	SysVoltage    int `json:"sys_voltage"`
	FuelRate      int `json:"fuel_rate"`
	AmbientTemp   int `json:"ambient_temp"`
	Mileage       int `json:"mileage"`
}

type DiagnosticData struct {
	Diagnostics []string `json:"diagnostics"`
	Timestamp   int      `json:"timestamp"`
}

type VehicleStatus struct {
	VehicleID   string          `json:"vehicle_id"`
	Telemetry   *TelemetryData  `json:"telemetry"`
	Diagnostics *DiagnosticData `json:"diagnostics"`
}

func (c *VehiclesContract) RecordTelemetry(ctx contractapi.TransactionContextInterface, vehicleId string, telemetryData string) error {
	var telemetry TelemetryData
	err := json.Unmarshal([]byte(telemetryData), &telemetry)
	if err != nil {
		return fmt.Errorf("failed to unmarshal telemetry data: %v", err)
	}

	telemetryKey, err := ctx.GetStub().CreateCompositeKey("vehicle-maintenance", []string{vehicleId})
	if err != nil {
		return fmt.Errorf("failed to create composite key: %v", err)
	}

	telemetryBytes, err := json.Marshal(telemetry)
	if err != nil {
		return fmt.Errorf("failed to marshal telemetry data: %v", err)
	}

	return ctx.GetStub().PutState(telemetryKey, telemetryBytes)
}

func (c *VehiclesContract) RecordDiagnostics(ctx contractapi.TransactionContextInterface, vehicleID string, diagnosticData string) error {
	var diagnostic DiagnosticData
	err := json.Unmarshal([]byte(diagnosticData), &diagnostic)
	if err != nil {
		return fmt.Errorf("failed to unmarshal diagnostic data: %v", err)
	}

	diagnosticKey, err := ctx.GetStub().CreateCompositeKey("vehicle-diagnostic", []string{vehicleID})
	if err != nil {
		return fmt.Errorf("failed to create composite key: %v", err)
	}

	diagnosticBytes, err := json.Marshal(diagnostic)
	if err != nil {
		return fmt.Errorf("failed to marshal diagnostic data: %v", err)
	}

	return ctx.GetStub().PutState(diagnosticKey, diagnosticBytes)
}
