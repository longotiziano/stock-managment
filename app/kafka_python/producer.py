from app.utils.helpers import my_serializer, encode_utf8
from sqlalchemy.exc import SQLAlchemyError, OperationalError, InvalidRequestError
from kafka import KafkaProducer
from datetime import datetime
from typing import Literal
from functools import wraps

producer = KafkaProducer(
    bootstrap_servers='kafka:9092', 
    value_serializer=my_serializer,
    key_serializer=encode_utf8
)

def _send_kafka_log(log_entry: dict) -> tuple[bool, Exception | None]:
    '''
    Envía el log a Kafka

    Crea topics de manera dinámica basandosé en el nivel del log.
    Creates topics dynamically based on the log level.
    '''
    try:
        future = producer.send(
            topic=f"pipeline-{log_entry['level'].lower()}",
            key=log_entry['r_id'],
            value=log_entry,
        )
        producer.flush()

    except Exception as e:
        return False, e
    
    return True, None

def _make_event_dict(
    r_id: int,
    message: str,
    level: Literal['ERROR', 'WARNING', 'CRITICAL', 'INFO', 'DEBUG'],
    module: str = None
) -> tuple[bool, dict]:
    '''
    Crea el diccionario para el loggeo en Kafka
    '''
    return True, {
        "level": level,
        "message": message,
        "timestamp": datetime.utcnow().isoformat(),  # Formato ISO para orden y análisis
        "module": module or "unknown", 
        "r_id": r_id
    }

def log_and_return(r_id: int, msg: str, level: str, module: str, return_msg: str = None) -> tuple[bool, None | Exception]:
    '''
    Helper para construir la entrada del log y enviarla a Kafka
    '''
    _, log_entry = _make_event_dict(r_id, msg, level, module)
    ok, kafka_error = _send_kafka_log(log_entry)
    if not ok:
        return False, kafka_error
    return True, None

def handle_db_errors(func):
    '''
    Decorador para funciones con interacción directa con la base de datos, previniendo errores inesperados con la misma
    '''
    @wraps(func)
    def wrapper(*args, **kwargs):
        r_id = args[1] if len(args) > 1 else None
        try:
            return func(*args, **kwargs)
        except OperationalError as e:
            log_and_return(r_id, f'OperationalError : {e}', 'ERROR', __name__, "Database unavailable.")
            return False, e
        except InvalidRequestError as e:
            log_and_return(r_id, f'InvalidRequestError : {e}', 'ERROR', __name__, "Error during session management")
            return False, e
        except SQLAlchemyError as e:
            log_and_return(r_id, f'SQLAlchemyError : {e}', 'ERROR', __name__, "Unexpected error with SQLAlchemy")
            return False, e
        
    return wrapper
