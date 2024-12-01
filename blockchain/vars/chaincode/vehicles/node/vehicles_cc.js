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
        const vehicleKey = ctx.stub.createCompositeKey('vehicle', [vehicleId]);
        await ctx.stub.putState(vehicleKey, Buffer.from(JSON.stringify(telemetry)));
        
        return JSON.stringify(telemetry);
    }
}

module.exports = VehiclesContract;