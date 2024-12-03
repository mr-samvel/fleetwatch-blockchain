var Vehicles = artifacts.require("./Vehicles.sol")

module.exports = function(_deployer) {
  _deployer.deploy(Vehicles);
};
