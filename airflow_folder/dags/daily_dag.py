import sys
sys.path.append("/opt/airflow")
from app.tasks.extraction_tasks import random_consumption_task
from app.tasks.verifiers_tasks import verify_products
from app.tasks.conversion_tasks import rm_to_stock_movements_task, products_to_sales_task, products_conversion_task
from app.tasks.load_tasks import load_stock_movements_task, update_rm_daily_task, load_sales_task
from airflow.decorators import dag, task
from airflow.models.baseoperator import chain
from datetime import datetime

default_args = {
    'owner': 'Tiziano',
    'start_date': datetime(2025, 8, 14),
}
@dag(
    dag_id='daily_stock_consumption',
    default_args=default_args,
    schedule_interval='@daily',  # '@weekly'
)
def daily_stock_consumption_dag():

    @task
    def generate_consumption_csv_task():
        return random_consumption_task()

    @task
    def verify_products_task(consumption):
        return verify_products(consumption)
    
    @task
    def products_to_sales_task_func(consumption):
        return products_to_sales_task(consumption)
    @task
    def products_conversion_task_func(consumption):
        return products_conversion_task(consumption)
    @task
    def rm_to_stock_movements_task_func(addition_file):
        return rm_to_stock_movements_task(addition_file, 'stock_out')
    
    @task
    def load_sales_task_func(sales_conv):
        return load_sales_task(sales_conv)
    @task
    def update_rm_daily_task_func(products_conv):
        return update_rm_daily_task(products_conv)
    @task
    def load_stock_movements_task_func(stock_movements_conv):
        return load_stock_movements_task(stock_movements_conv)

    consumption = generate_consumption_csv_task()

    verification = verify_products_task(consumption)

    sales_conv = products_to_sales_task_func(consumption)
    products_conv = products_conversion_task_func(consumption)
    stock_movements_conv = rm_to_stock_movements_task_func(products_conv)

    load_sales = load_sales_task_func(sales_conv)
    load_daily = update_rm_daily_task_func(products_conv)
    load_movements = load_stock_movements_task_func(stock_movements_conv)

    chain(
    consumption,
    verification,
    [sales_conv, products_conv, stock_movements_conv],
    [load_sales, load_daily, load_movements]
    )

dag = daily_stock_consumption_dag()