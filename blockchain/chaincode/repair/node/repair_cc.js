// Chaincode goes here
'use strict';

const { Contract } = require('fabric-contract-api');

class RepairShopContract extends Contract {
    // maintenanceData would be a JSON with the issue, status of fix, price, etc
    async recordMaintenance(ctx, vehicleId, maintenanceData) {
        
        // Create composite key for maintenance records
        const maintenanceKey = ctx.stub.createCompositeKey('maintenance', [vehicleId, Date.now().toString()]);
        
        await ctx.stub.putState(maintenanceKey, Buffer.from(JSON.stringify(maintenanceData)));
        
        // Update latest vehicle state
        const vehicleKey_maintenance = ctx.stub.createCompositeKey('vehicle', [vehicleId, 'latest_maintenance']);
        await ctx.stub.putState(vehicleKey_maintenance, Buffer.from(JSON.stringify(maintenanceData)));
        
        return JSON.stringify(maintenanceData);
    }

    async getLatestCarMaintenance(ctx, vehicleId) {
        // Make key and get state of key
        const vehicleKey = ctx.stub.createCompositeKey('vehicle', [vehicleId, 'latest_maintenance']);
        const maintenanceBytes = await ctx.stub.getState(vehicleKey);

        // Check if car actually registered
        if (!maintenanceBytes || maintenanceBytes.length == 0) {
            throw new Error(`${vehicleID} is not registered`);
        }

        // Convert to JSON and return
        const maintenanceJson = JSON.parse(maintenanceBytes.toString());
        return maintenanceJson;
    }
}

module.exports = RepairShopContract;