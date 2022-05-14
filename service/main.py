from typing import *
from time import sleep

def entry(request: Dict) -> Dict:
    print("entering...")
    sleep(2)
    return {
        "your_request": request,
        "secret": "43"
    }

