from sql.database import SessionLocal
import time

def csv_task(repo_class, method_name: str) -> tuple[bool, str | Exception]:
    '''
    Tarea genérica para crear un CSV utlizando un repositorio
    '''
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
        # "directory" será una excepción si es False
        raise directory
    return directory

def random_consumption_task():
    from app.repositories.products_repository import ProductsRepository
    ok, directory = csv_task(ProductsRepository, 'random_consumption')
    if not ok:
        raise directory
    return directory