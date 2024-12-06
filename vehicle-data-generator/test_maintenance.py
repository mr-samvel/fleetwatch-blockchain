import requests
from time import time


maintenance = {}
maintenance["timestamp"] = int(time())
maintenance_response = requests.post(
                    f'http://localhost:3000/maintenance/{"1"}',
                    json={'maintenance': maintenance}
                )
maintenance_response.raise_for_status()