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
    Send a log entry to the Kafka broker.

    Creates topics dynamically based on the log level.
    For 'ERROR' and 'CRITICAL' levels, waits for broker acknowledgment.
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
    Build the event dictionary for Kafka logging.
    '''
    return True, {
        "level": level,
        "message": message,
        "timestamp": datetime.utcnow().isoformat(),  # ISO format for ordering and analysis
        "module": module or "unknown", 
        "r_id": r_id
    }

def log_and_return(r_id: int, msg: str, level: str, module: str, return_msg: str = None) -> tuple[bool, None | Exception]:
    '''
    Helper to build a log entry and send it to Kafka
    '''
    _, log_entry = _make_event_dict(r_id, msg, level, module)
    ok, kafka_error = _send_kafka_log(log_entry)
    if not ok:
        return False, kafka_error
    return True, None

def handle_db_errors(func):
    '''
    Decorator for database functions to:
    - Catch SQLAlchemy-specific exceptions.
    - Log them to Kafka.
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
