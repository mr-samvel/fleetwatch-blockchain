const { Gateway, Wallets } = require('fabric-network');
const path = require('path');
const fs = require('fs');
const express = require('express');

const app = express();
app.use(express.json())

async function connectToNetwork() {
    const ccpPath = path.resolve(__dirname, '../vars/profiles/channel0_connection_for_nodesdk.json');
    const ccp = JSON.parse(fs.readFileSync(ccpPath, 'utf8'));

    const walletPath = path.join('../vars/profiles/vscode/wallets', 'org0.com');
    const wallet = await Wallets.newFileSystemWallet(walletPath);

    const identity = await wallet.get('Admin');
    if (!identity)
        throw new Error("Identity for admin not found!")
    
    const gateway = new Gateway();
    await gateway.connect(ccp, { wallet, identity: 'Admin', discovery: { enabled: true, asLocalhost: false } });

    return await gateway.getNetwork('channel0');
}

async function getContract(contractName) {
    return (await connectToNetwork()).getContract('fleetwatch', contractName);
}

app.post('/telemetry/:vehicleId', async (req, res) => {
    const vehicleId = req.params.vehicleId;
    const { telemetry } = req.body;

    try {
        const contract = await getContract('VehiclesContract');
        await contract.submitTransaction('RecordTelemetry', vehicleId, JSON.stringify(telemetry));
        res.status(200).send('Telemetry recorded successfully.');
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.post('/diagnostics/:vehicleId', async (req, res) => {
    const vehicleId = req.params.vehicleId;
    const { diagnostics } = req.body;

    try {
        const contract = await getContract('VehiclesContract');
        await contract.submitTransaction('RecordDiagnostics', vehicleId, JSON.stringify(diagnostics));
        res.status(200).send('Diagnostics recorded successfully.');
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.get('/status', async (req, res) => {
    try {
        const contract = await getContract('FleetManagerContract');
        const result = await contract.evaluateTransaction('GetAllVehiclesStatus');
        res.status(200).json(JSON.parse(result.toString('ascii')));
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.get('/latestTelemetry/:vehicleId', async(req, res) => {
    const vehicleId = req.params.vehicleId;

    try {
        const contract = await getContract('InsuranceProviderContract');
        const result = await contract.evaluateTransaction('GetLatestVehicleStatus', vehicleId);
        res.status(200).json(JSON.parse(result.toString('ascii')));
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.get('/latestDiagnostic/:vehicleId', async(req, res) => {
    const vehicleId = req.params.vehicleId;

    try {
        const contract = await getContract('RepairShopContract');
        const result = await contract.evaluateTransaction('GetLatestVehicleDiagnostic', vehicleId);
        res.status(200).json(JSON.parse(result.toString('ascii')));
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.post('/maintenance/:vehicleId', async(req, res) => {
    const vehicleId = req.params.vehicleId;
    const { maintenance } = req.body;

    try {
        const contract = await getContract('RepairShopContract');
        await contract.submitTransaction('RecordMaintenance', vehicleId, JSON.stringify(maintenance));
        res.status(200).send('Maintenance recorded successfully.');
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.get('/latestMaintenance/:vehicleId', async(req, res) => {
    const vehicleId = req.params.vehicleId;

    try {
        const contract = await getContract('RepairShopContract');
        const result = await contract.evaluateTransaction('GetLatestVehicleDiagnostic', vehicleId);
        res.status(200).json(JSON.parse(result.toString('ascii')));
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.listen(3000);