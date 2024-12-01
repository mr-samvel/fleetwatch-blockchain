// Chaincode goes here
'use strict';

const { Contract } = require('fabric-contract-api');

class InsuranceContract extends Contract {
    async getLatestCarStatus(ctx, vehicleId) {
        // Make key and get state of key
        const vehicleKey = ctx.stub.createCompositeKey('vehicle', [vehicleId, 'latest_telemetry']);
        const stateBytes = await ctx.stub.getState(vehicleKey);

        // Check if car actually registered
        if (!stateBytes || stateBytes.length == 0) {
            throw new Error(`${vehicleID} is not registered`);
        }

        // Convert to JSON and return
        const stateJson = JSON.parse(stateBytes.toString());
        return stateJson;
    }
}

module.exports = InsuranceContract;