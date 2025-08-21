import pandas as pd
import numpy as np
import json
import os
from typing import Any

class NpEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, (np.integer,)):
            return int(obj)
        elif isinstance(obj, (np.floating,)):
            return float(obj)
        elif isinstance(obj, (np.ndarray,)):
            return obj.tolist()
        elif isinstance(obj, (pd.Timestamp,)):
            return obj.isoformat()
        return super().default(obj)

def my_serializer(value: Any) -> bytes:
    '''
    Convierte objetos de Python en JSON, para luego codificar en bytes 
    '''
    return json.dumps(value, cls=NpEncoder).encode('utf-8')

def my_deserializer(msg_bytes: bytes | None) -> Any | None:
    '''
    Deserializa un mensaje de Kafka desde bytes a un objeto de Python.
    Si el input es None, no devolverá nada
    '''
    if msg_bytes is None:
        return None
    return json.loads(msg_bytes.decode('utf-8'))

def encode_utf8(value: str) -> bytes:
    '''
    Codifica una string en bytes 
    '''
    return str(value).encode('utf-8')

def decode_utf8(value: bytes | None) -> str | None:
    '''
    Decodifica bytes en una string UTF-8
    Si el input es None, no devolverá nada
    '''
    if value is None:
        return None
    return value.decode('utf-8')

def list_csv_files(directory: str) -> tuple[bool, tuple[str, list] | Exception]:
    '''
    Devuelve una lista de CSVs en el directorio dado
    '''
    try:
        csv_files = [f for f in os.listdir(directory) if f.endswith(".csv")]
    except Exception as e:
        return False, e

    return True, (directory, csv_files) 
