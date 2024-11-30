import random
import json

class Veiculo:
    def __init__(self, v_id: str) -> None:
        self.v_id: str = v_id
        self.metrica_idx: int = 1
        self.diag_idx: int = 1
        self.motorista_id: str = ""
        
    def coleta_metricas(self):
        metricas = {}
        metricas["avg_engine_load"] = random.randrange(1, 100)
        metricas["avg_engine_rpm"] = random.randrange(700, 6500)
        metricas["coolant_temp"] = random.randrange(80, 110)
        metricas["sys_voltage"] = random.randrange(10, 17)
        metricas["fuel_rate"] = random.randrange(1, 100)
        metricas["ambient_temp"] = random.randrange(-10, 40)
        metricas["mileage"] = random.randrange(1, 100000)
        with open(f"./metrics/{self.v_id}_metric_{self.metrica_idx}.json", "w") as file:
            json.dump(metricas, file)
        self.metrica_idx += 1
            
    def coleta_diagnostico(self):
        diagnosticos = [
            "OK",
            "Abnormal consumption",
            "Faulty battery",
            "Overheating ambient",
            "Overheating coolant",
            "Low voltage",
            "High voltage",
            "Overloaded engine"]
        escolha = {"diagnostic": random.choice(diagnosticos)}
        with open(f"./diags/{self.v_id}_diag_{self.diag_idx}.json", "w") as file:
            json.dump(escolha, file)
        self.diag_idx += 1
        
for i in range(5):
    novo_veiculo = Veiculo(i)
    for _ in range(10):
        novo_veiculo.coleta_diagnostico()
        novo_veiculo.coleta_metricas()
        