from time import sleep
from threading import Thread
from time import time
import random
import requests

class Vehicle:
    def __init__(self, v_id: int, m_id: int) -> None:
        self.id: int = v_id
        self.driver_id: int = m_id
        self.current_mileage: int = random.randint(1, 100000)
        
    def gather_telemetry(self):
        self.current_mileage += random.randint(30, 300)

        telemetry = {}
        telemetry["vehicle_id"] = self.id
        telemetry["driver_id"] = self.driver_id
        telemetry["timestamp"] = int(time())
        telemetry["avg_engine_load"] = random.randint(1, 100)
        telemetry["avg_engine_rpm"] = random.randint(700, 6500)
        telemetry["coolant_temp"] = random.randint(80, 110)
        telemetry["sys_voltage"] = random.randint(10, 17)
        telemetry["fuel_rate"] = random.randint(1, 100)
        telemetry["ambient_temp"] = random.randint(-10, 40)
        telemetry["mileage"] = self.current_mileage
        return telemetry
            
    def gather_diagnostics(self):
        diagnosticos = [
            "Misfires",
            "Catalytic Converter Failure",
            "Oxygen Sensor Issues",
            "Mass Airflow Sensor Fault",
            "Knock Sensor Problems",
            "Evaporative Emissions Control System Leak",
            "EGR Valve Malfunction",
            "Transmission Slipping or Overheating",
            "Shift Solenoid Faults",
            "Injector Circuit Malfunction",
            "Throttle Position Sensor Fault",
            "Engine Overheating",
            "ABS Circuit Malfunction"
        ]
        is_bad_driver = self.driver_id % 2 == 0 and self.driver_id <= 4 # simula motorista que desgasta carro
        defect_probability = random.randint(0, 10)
        is_car_defective = defect_probability >= 6 if is_bad_driver else defect_probability > 1
        
        if is_car_defective:
            diagnostico = {}
            diagnostico["timestamp"] = int(time())
            diagnostico["diagnostics"] = random.sample(diagnosticos, random.randint(1, 3))
            return diagnostico
        return None
    
vehicle = Vehicle(904, 5)
telemetry = vehicle.gather_telemetry()
diagnostics = vehicle.gather_diagnostics()
telemetry_response = requests.post(
                f'http://localhost:3000/telemetry/{vehicle.id}',
                json={'telemetry': telemetry}
            )

diagnostic_response = requests.post(
                    f'http://localhost:3000/diagnostics/{vehicle.id}',
                    json={'diagnostics': diagnostics}
                )
print(diagnostics)