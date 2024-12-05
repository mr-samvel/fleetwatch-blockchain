package main

import (
	"github.com/hyperledger/fabric-contract-api-go/contractapi"
)

type FleetManagerContract struct {
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
