import Web3 from 'web3';
import configuration from './build/contracts/Vehicles.json';

const CONTRACT_ADDRESS =
  configuration.networks['1733253733620'].address;
const CONTRACT_ABI = configuration.abi;

const web3 = new Web3(
  Web3.givenProvider || 'http://127.0.0.1:8545'
);
const contract = new web3.eth.Contract(
  CONTRACT_ABI,
  CONTRACT_ADDRESS
);

const main = async () => {
    const accounts = await web3.eth.getAccounts()
    const account = accounts[0]
    await console.log(contract.methods.recordTelemetry(1, 1, 1, 1, 1, 1, 1, 1, 1, 1).send({from: account, gas: '1000000',gasPrice:1000000000}))
    await console.log(contract.methods.getLatestCarTelemetry(1).call({from: account}))
};

main();