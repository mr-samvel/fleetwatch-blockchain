from time import sleep
from threading import Thread
import random
import requests

class Veiculo:
    def __init__(self, v_id: int, m_id: int) -> None:
        self.id: int = v_id
        self.motorista_id: int = m_id
        self.km_atual: int = random.randint(1, 100000)
        
    def coleta_metricas(self):
        self.km_atual += random.randint(30, 300)

        metricas = {}
        metricas["vehicle_id"] = self.id
        metricas["driver_id"] = self.motorista_id
        metricas["avg_engine_load"] = random.randint(1, 100)
        metricas["avg_engine_rpm"] = random.randint(700, 6500)
        metricas["coolant_temp"] = random.randint(80, 110)
        metricas["sys_voltage"] = random.randint(10, 17)
        metricas["fuel_rate"] = random.randint(1, 100)
        metricas["ambient_temp"] = random.randint(-10, 40)
        metricas["mileage"] = self.km_atual
        return {"telemetry": metricas}
            
    def coleta_diagnostico(self):
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
        motorista_ruim = self.motorista_id % 2 == 0 and self.motorista_id <= 4 # simula motorista que desgasta carro
        prob_problema = random.randint(0, 10)
        carro_com_problema = prob_problema >= 6 if motorista_ruim else prob_problema > 9
        return {"diagnostic": random.sample(diagnosticos, random.randint(1, 3))} if carro_com_problema else None

def coletar_dados_veiculo():
    veiculo = Veiculo(random.randint(0, 1000), random.randint(0, 1000))
    while True:
        telemetria = veiculo.coleta_metricas()
        diagnostico = veiculo.coleta_diagnostico()
        print(f'Nova coleta para veículo {veiculo.id}.\n>>>Telemetria: {telemetria}\n>>>Diagnostico: {diagnostico}')
        sleep(random.randint(1, 10))

for _ in range(5):
    Thread(target=coletar_dados_veiculo).start()
        