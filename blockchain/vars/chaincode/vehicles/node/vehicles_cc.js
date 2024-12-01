// Chaincode goes here
'use strict';

const { Contract } = require('fabric-contract-api');

class VehiclesContract extends Contract {
    async recordTelemetry(ctx, vehicleId, telemetryData) {
        const telemetry = JSON.parse(telemetryData);
        
        // Create composite key for telemetry records
        const telemetryKey = ctx.stub.createCompositeKey('telemetry', [vehicleId, Date.now().toString()]);
        
        await ctx.stub.putState(telemetryKey, Buffer.from(JSON.stringify(telemetry)));
        
        // Update latest vehicle state
        const vehicleKey_telemetry = ctx.stub.createCompositeKey('vehicle', [vehicleId, 'latest_telemetry']);
        await ctx.stub.putState(vehicleKey_telemetry, Buffer.from(JSON.stringify(telemetry)));
        
        return JSON.stringify(telemetry);
    }

    async recordDiagnostic(ctx, vehicleId, diagnosticData) {
        // Identical to function above but works with diagnostic data instead of telemetry
        const diagnostic = JSON.parse(diagnosticData);

        // Create composite key for telemetry records
        const diagnosticKey = ctx.stub.createCompositeKey('diagnostic', [vehicleId, Date.now().toString()]);

        await ctx.stub.putState(diagnosticKey, Buffer.from(JSON.stringify(diagnostic)));

        // Update latest vehicle diagnostic
        const vehicleKey_diagnostic = ctx.stub.createCompositeKey('vehicle', [vehicleId, 'latest_diagnostic']);
        await ctx.stub.putState(vehicleKey_diagnostic, Buffer.from(JSON.stringify(diagnostic)));
        
        return JSON.stringify(diagnostic)
    }
}

module.exports = VehiclesContract;