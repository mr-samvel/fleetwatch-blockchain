'use strict';

const { Contract } = require('fabric-contract-api');
const shim = require('fabric-shim');

class VehiclesContract extends Contract {
    constructor() {
        super('VehiclesContract');
    }

    async recordTelemetry(ctx, vehicleId, telemetryData) {
        // telemetryData: {
        //     vehicle_id: int
        //     timestamp: int
        //     driver_id: int
        //     avg_engine_load: int
        //     avg_engine_rpm: int
        //     coolant_temp: int
        //     sys_voltage: int
        //     fuel_rate: int
        //     ambient_temp: int
        //     mileage: int
        // }
        const telemetry = JSON.parse(telemetryData)
        const telemetryKey = ctx.stub.createCompositeKey('vehicle-telemetry', [vehicleId]);
        await ctx.stub.putState(telemetryKey, Buffer.from(JSON.stringify(telemetry)));
    }

    async recordDiagnostics(ctx, vehicleId, diagnosticData) {
        // diagnosticData: {
        //     diagnostics: string[]
        //     timestamp: int
        // }
        const diagnostic = JSON.parse(diagnosticData);
        const diagnosticKey = ctx.stub.createCompositeKey('vehicle-diagnostic', [vehicleId]);
        await ctx.stub.putState(diagnosticKey, Buffer.from(JSON.stringify(diagnostic)));
    }
}

module.exports = VehiclesContract;