// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./Vehicles.sol";

contract Insurance is Vehicles {
    Vehicles vehiclesContract;

    constructor(address vehiclesAddress) {
        vehiclesContract = Vehicles(vehiclesAddress);
    }

    function getLatestCarStatus(uint vehicle_id) public view returns (Telemetry memory) {
        Telemetry memory latest = vehiclesContract.getLatestCarTelemetry(vehicle_id);
        if (latest.initialized == false) {
            revert("Veiculo nao registrado");
        } else {
            return latest;
        }
    }
}