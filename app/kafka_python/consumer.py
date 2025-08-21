from app.kafka_python.producer import handle_db_errors
from app.models.auto_models import KafkaLogs
from app.utils.helpers import my_deserializer, decode_utf8
from sql.database import SessionLocal
from kafka import KafkaConsumer
from datetime import datetime
import time

consumer = KafkaConsumer(
    'pipeline-info', 'pipeline-error', 'pipeline-debug', 'pipeline-critical', 'pipeline-warning',
    bootstrap_servers='kafka:9092',
    enable_auto_commit=False,  
    group_id='my-consumer-group',
    key_deserializer=decode_utf8,
    value_deserializer=my_deserializer
)

@handle_db_errors
def log_insertion(batch_interval=300):
    buffer = []
    last_flush = datetime.utcnow()

    while True:
        msg_pack = consumer.poll(timeout_ms=1000)  
        for tp, messages in msg_pack.items():
            for msg in messages:
                buffer.append(msg.value)

        now = datetime.utcnow()
        if (now - last_flush).total_seconds() >= batch_interval and buffer:
            with SessionLocal() as session:
                session.bulk_insert_mappings(KafkaLogs, buffer)
                session.commit()
            buffer = []
            last_flush = now
            consumer.commit() # Helps to keep track of the messages' offset
        time.sleep(1)

ok, errors = log_insertion(5)
if not ok:
    raise ValueError(f'Error during log consumption: {errors}')