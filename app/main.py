from app.tasks.extraction_tasks import stock_addition_task, random_consumption_task
from app.tasks.verifiers_tasks import verify_rm_task, verify_products
from app.tasks.conversion_tasks import rm_to_stock_movements_task, products_to_sales_task, products_conversion_task
from app.tasks.load_tasks import load_stock_movements_task, update_rm_weekly_task, update_rm_daily_task, load_sales_task

def weekly_stock_insertion():
    addition=stock_addition_task()
    verify_rm_task(addition, 'stock_in')
    stock_movements=rm_to_stock_movements_task(addition, 'stock_in')
    update_rm_weekly_task(addition)
    load_stock_movements_task(stock_movements)

def daily_stock_consumption():
    consumption=random_consumption_task()
    verify_products(consumption)
    sales = products_to_sales_task(consumption)
    raw_material = products_conversion_task(consumption)
    stock_movements=rm_to_stock_movements_task(raw_material, 'stock_out')
    update_rm_daily_task(raw_material)
    load_sales_task(sales)
    load_stock_movements_task(stock_movements)

daily_stock_consumption()