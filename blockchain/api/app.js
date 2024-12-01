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
    await gateway.connect(ccp, { wallet, identity: 'Admin', discovery: { enabled: true, asLocalhost: true } });

    return await gateway.getNetwork('channel0');
}

async function getContract(contractName) {
    return (await connectToNetwork()).getContract(contractName);
}

app.post('/telemetry/:vehicleId', async (req, res) => {
    const vehicleId = req.params.vehicleId;
    const { telemetry } = req.body;

    try {
        const contract = await getContract('VehiclesContract');
        await contract.submitTransaction('recordTelemetry', vehicleId, JSON.stringify(telemetry));
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
        await contract.submitTransaction('recordDiagnostics', vehicleId, JSON.stringify(diagnostics));
        res.status(200).send('Diagnostics recorded successfully.');
    } catch (error) {
        console.error(`Failed to submit transaction: ${error}`);
        res.status(500).send(`Error: ${error.message}`);
    }
});

app.listen(3000, () => {
    connectToNetwork().then((nw) => {
        console.log(nw);
    });
});