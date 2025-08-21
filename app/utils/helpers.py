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
    Converts Python objects into JSON, then encodes them into bytes for Kafka.
    '''
    return json.dumps(value, cls=NpEncoder).encode('utf-8')

def my_deserializer(msg_bytes: bytes | None) -> Any | None:
    '''
    Deserialize a Kafka message from bytes to a Python object (dict, list, etc.).
    Returns None if the input is None.
    '''
    if msg_bytes is None:
        return None
    return json.loads(msg_bytes.decode('utf-8'))

def encode_utf8(value: str) -> bytes:
    '''
    Encodes a string into UTF-8 bytes.
    '''
    return str(value).encode('utf-8')

def decode_utf8(value: bytes | None) -> str | None:
    '''
    Decodes bytes into a UTF-8 string.
    Returns None if the input is None.
    '''
    if value is None:
        return None
    return value.decode('utf-8')

def list_csv_files(directory: str) -> tuple[bool, tuple[str, list] | Exception]:
    '''
    Returns a list of CSV files from the directory provided.
    '''
    try:
        csv_files = [f for f in os.listdir(directory) if f.endswith(".csv")]
    except Exception as e:
        return False, e

    return True, (directory, csv_files) 
