import sys 
sys.path.append("/opt/airflow")
from app.tasks.extraction_tasks import stock_addition_task
from app.tasks.verifiers_tasks import verify_rm_task
from app.tasks.conversion_tasks import rm_to_stock_movements_task
from app.tasks.load_tasks import load_stock_movements_task, update_rm_weekly_task
from airflow.decorators import dag, task
from datetime import datetime

default_args = {
    'owner': 'Tiziano',
    'start_date': datetime(2025, 8, 14),
}
@dag(
    dag_id='weekly_stock_insertion',
    default_args=default_args,
    schedule_interval='@weekly'
)
def weekly_stock_insertion_dag():

    @task
    def generate_addition_csv_task():
        return stock_addition_task()

    @task
    def verify_raw_material_task(addition_file):
        return verify_rm_task(addition_file, 'stock_in')

    @task
    def rm_to_stock_movements_task_func(addition_file):
        return rm_to_stock_movements_task(addition_file, 'stock_in')

    @task
    def update_raw_material_weekly_task_func(addition_file):
        return update_rm_weekly_task(addition_file)

    @task
    def load_stock_movements_task_func(conversion):
        return load_stock_movements_task(conversion)

    addition_file = generate_addition_csv_task()

    verification = verify_raw_material_task(addition_file)
    conversion = rm_to_stock_movements_task_func(addition_file)

    update_weekly = update_raw_material_weekly_task_func(addition_file)
    load_movements = load_stock_movements_task_func(conversion)

    addition_file >> verification >> conversion >> [update_weekly, load_movements]

dag = weekly_stock_insertion_dag()
