// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Vehicles {
    struct Telemetry {
        uint vehicle_id;
        uint driver_id;
        uint timestamp;
        uint avg_engine_load;
        uint avg_engine_rpm;
        int coolant_temp;
        uint sys_voltage;
        uint fuel_rate;
        int ambient_temp;
        uint mileage;
        bool initialized;
    }

    struct Diagnostic {
        uint vehicle_id;
        uint driver_id;
        string diagnostic;
        uint timestamp;
        bool initialized;
    }

    uint[] all_vehicle_ids;

    Telemetry[] allTelemetry;
    mapping(uint => Telemetry) private latestTelemetry;

    Diagnostic[] allDiagnostic;
    mapping(uint => Diagnostic) private latestDiagnostic;

    function vehicle_in_array(uint vehicle_id) private view returns (bool) {
        for (uint i = 0; i < all_vehicle_ids.length; i++) {
            uint lookup_id = all_vehicle_ids[i];
            if (lookup_id == vehicle_id) {
                return true;
            }
        }
        return false;
    }

    function recordTelemetry(
                            uint vehicle_id,
                            uint driver_id,
                            uint timestamp,
                            uint avg_engine_load,
                            uint avg_engine_rpm,
                            int coolant_temp,
                            uint sys_voltage,
                            uint fuel_rate,
                            int ambient_temp,
                            uint mileage) public {
            Telemetry memory new_telemetry = Telemetry(
                vehicle_id,
                driver_id, 
                timestamp, 
                avg_engine_load, 
                avg_engine_rpm, 
                coolant_temp, 
                sys_voltage, 
                fuel_rate, 
                ambient_temp, 
                mileage,
                true);
            allTelemetry.push(new_telemetry);
            latestTelemetry[vehicle_id] = new_telemetry;
            if (vehicle_in_array(vehicle_id) == false) {
                all_vehicle_ids.push(vehicle_id);
            }

    }

    function recordDiagnostic (
                                uint vehicle_id,
                                uint driver_id,
                                string memory diagnostic, 
                                uint timestamp) public {
        Diagnostic memory new_diagnostic = Diagnostic(vehicle_id, driver_id, diagnostic, timestamp, true);
        allDiagnostic.push(new_diagnostic);
        latestDiagnostic[vehicle_id] = new_diagnostic;
    }

    function getLatestCarTelemetry(uint vehicle_id) external  view returns (Telemetry memory) {
        return latestTelemetry[vehicle_id];
    }

    function getLatestCarDiagnostic(uint vehicle_id) external view returns (Diagnostic memory) {
        return latestDiagnostic[vehicle_id];
    }

    function getLatestFleetTelemetry() external view returns (Telemetry[] memory) {
        Telemetry[] memory all_telemetries;
        for (uint i = 0; i < all_vehicle_ids.length; i++) {
            uint id = all_vehicle_ids[i];
            Telemetry memory t = latestTelemetry[id];
            all_telemetries[i] = t;
        }
        return all_telemetries;
    }

    function getAllDiagnostics() external view returns (Diagnostic[] memory) {
        return allDiagnostic;
    }
}