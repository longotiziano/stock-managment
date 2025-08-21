from app.kafka_python.producer import log_and_return
from sql.database import SessionLocal
import time

def csv_task(repo_class, method_name: str) -> tuple[bool, str | Exception]:
    '''
    Generic task to create a CSV file using a repository.
    '''
    log_and_return(-9999, 'Started : "csv_task"', 'INFO', __name__)
    
    with SessionLocal() as session:
        repo = repo_class(session)
    csv_method = getattr(repo, method_name)
    ok, directory = csv_method()

    if not ok:
        return False, directory

    return True, directory

def stock_addition_task():
    from app.repositories.raw_material_repository import RawMaterialRepository
    ok, directory = csv_task(RawMaterialRepository, 'create_csv_stock')
    if not ok:
        # If it's not ok, the "directory" variable will be an exception.
        raise directory
    log_and_return(-9999, f'FinishedTask : "stock_addition_task"', 'INFO', __name__)
    return directory

def random_consumption_task():
    from app.repositories.products_repository import ProductsRepository
    ok, directory = csv_task(ProductsRepository, 'random_consumption')
    if not ok:
        raise directory
    log_and_return(-9999, f'FinishedTask : "random_consumption_task"', 'INFO', __name__)
    return directory