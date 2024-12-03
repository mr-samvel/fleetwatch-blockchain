// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract Repair {
    struct MaintenanceRecord {
        uint vehicle_id;
        string problem;
        string repair_status;
        uint price;
        bool initialized;
    }

    MaintenanceRecord[] allMaintenances;
    mapping(uint => MaintenanceRecord) private latestMaintenance;

    function recordMaintenance(uint vehicle_id, string calldata problem, string calldata repair_status, uint price) public {
        MaintenanceRecord memory new_maintenance = MaintenanceRecord(vehicle_id, problem, repair_status, price, true);
        allMaintenances.push(new_maintenance);
        latestMaintenance[vehicle_id] = new_maintenance;
    }

    function getLatestMaintenance(uint vehicle_id) public view returns (MaintenanceRecord memory) {
        if (latestMaintenance[vehicle_id].initialized == false) {
            revert("Veiculo nao registrado");
        } else {
            return latestMaintenance[vehicle_id];
        }
    }
}