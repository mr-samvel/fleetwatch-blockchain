// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "./vehicles.sol";

contract Insurance is Vehicles {
    Vehicles vehiclesContract;

    constructor(address vehiclesAddress) {
        vehiclesContract = Vehicles(vehiclesAddress);
    }

    function getLatestFleetStatus() public view returns (Telemetry[] memory){
        return vehiclesContract.getLatestFleetTelemetry();
    }

    function getDiagnosticsByDriver(uint driver_id) public view returns (Diagnostic[] memory) {
        Diagnostic[] memory allDiagnostics = vehiclesContract.getAllDiagnostics();
        Diagnostic[] memory driverDiagnostics;
        uint current_size = 0;
        for (uint i = 0; i < allDiagnostics.length; i++) 
        {
            Diagnostic memory diagnostic = allDiagnostics[i];
            if (diagnostic.driver_id == driver_id) {
                driverDiagnostics[current_size] = diagnostic;
                current_size ++;
            }
        }
        return driverDiagnostics;
    }
}