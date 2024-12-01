from time import sleep
from threading import Thread
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
        telemetry["avg_engine_load"] = random.randint(1, 100)
        telemetry["avg_engine_rpm"] = random.randint(700, 6500)
        telemetry["coolant_temp"] = random.randint(80, 110)
        telemetry["sys_voltage"] = random.randint(10, 17)
        telemetry["fuel_rate"] = random.randint(1, 100)
        telemetry["ambient_temp"] = random.randint(-10, 40)
        telemetry["mileage"] = self.current_mileage
        return {"telemetry": telemetry}
            
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
        is_car_defective = defect_probability >= 6 if is_bad_driver else defect_probability > 9
        return {"diagnostic": random.sample(diagnosticos, random.randint(1, 3))} if is_car_defective else None

def gather_vehicle_data():
    vehicle = Vehicle(random.randint(0, 1000), random.randint(0, 1000))
    while True:
        telemetry = vehicle.gather_telemetry()
        diagnostics = vehicle.gather_diagnostics()
        # TODO submit telemetry and diagnostics (if != None) to blockchain
        print(f'Nova coleta para veículo {vehicle.id}.\n>>>Telemetria: {telemetry}\n>>>Diagnostico: {diagnostics}')
        sleep(random.randint(1, 10))

for _ in range(5):
    Thread(target=gather_vehicle_data).start()
        