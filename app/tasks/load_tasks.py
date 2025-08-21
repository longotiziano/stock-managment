from app.kafka_python.producer import log_and_return
from app.utils.helpers import list_csv_files
from sql.database import SessionLocal
from sqlalchemy.exc import SQLAlchemyError
import pandas as pd
from typing import Literal, Optional
import os

def load_data_task(
    directory_parameter,
    table = None, 
    direction: Optional[Literal['stock_in', 'stock_out']] = None
) -> tuple[bool, None | Exception]:
    '''
    General function to insert all the data into the database.
    '''
    log_and_return(-9999, 'Started : "load_data_task"', 'INFO', __name__)

    csv_ok, directory_csvs = list_csv_files(directory_parameter)
    if not csv_ok:
        log_and_return(-9999, f'FileError : {directory_csvs}', 'ERROR', __name__)
        return False, RuntimeError(f'Error while listing CSVs: {directory_csvs}')
    
    previous_directory, csv_files = directory_csvs
    
    failed_files = []
    with SessionLocal() as session:

        if direction:
            from app.repositories.raw_material_repository import RawMaterialRepository
            rm_repo = RawMaterialRepository(session)

        for file in csv_files:     
            file_path = os.path.join(previous_directory, file)
            df = pd.read_csv(file_path)
            
            if direction:
                r_id = df['r_id'].iloc[0]
                ok = rm_repo.update_stock_amounts(r_id, df, direction)
                # update_stock_amounts() doesn't return anything meaningful; exceptions are handled by the decorator
                try:
                    if not ok[0]:
                        # These errors are already logged by the decorator
                        failed_files.append(file)
                        continue
                except TypeError:
                    # In case `ok` is not subscriptable (e.g., the function returned None)
                    continue

            list_of_dicts = df.to_dict(orient='records')
            try:
                session.bulk_insert_mappings(table, list_of_dicts)

            except SQLAlchemyError:
                log_and_return(-9999, f'BulkInsertError : {SQLAlchemyError}', 'ERROR', __name__)
                failed_files.append(file)

        if failed_files:
            # These are already logged, so there's no need to log again
            return False, ValueError(f'Please, verify the following files: {failed_files}')

        session.commit()    
    return True, None

def load_stock_movements_task(directory_parameter):
    from app.models.auto_models import StockMovements

    ok, error = load_data_task(directory_parameter, StockMovements)
    if not ok:
        raise error
    log_and_return(-9999, f'FinishedTask : "load_stock_movements_task"', 'INFO', __name__)

def load_sales_task(directory_parameter):
    from app.models.auto_models import Sales

    ok, error = load_data_task(directory_parameter, Sales)
    if not ok:
        raise error
    log_and_return(-9999, f'FinishedTask : "load_sales_task"', 'INFO', __name__)

def update_rm_daily_task(directory_parameter):
    ok, error = load_data_task(directory_parameter, None, 'stock_out')
    if not ok:
        raise error
    log_and_return(-9999, f'FinishedTask : "load_daily_rm_task"', 'INFO', __name__)

def update_rm_weekly_task(directory_parameter):
    ok, error = load_data_task(directory_parameter, None, 'stock_in')
    if not ok:
        raise error
    log_and_return(-9999, f'FinishedTask : "load_weekly_rm_task"', 'INFO', __name__)

    
        
            
            
    