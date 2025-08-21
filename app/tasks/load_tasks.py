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
    Función general para insertar todos los datos en la base de datos
    '''

    csv_ok, directory_csvs = list_csv_files(directory_parameter)
    if not csv_ok:
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
                # Aplico esta lógica debido a que update_stock_amounts no devuelve nada útil
                try:
                    if not ok[0]:
                        failed_files.append(file)
                        continue
                except TypeError:
                    continue

            list_of_dicts = df.to_dict(orient='records')
            try:
                session.bulk_insert_mappings(table, list_of_dicts)

            except SQLAlchemyError:
                failed_files.append(file)

        if failed_files:
            return False, ValueError(f'Please, verify the following files: {failed_files}')

        session.commit()    
    return True, None

def load_stock_movements_task(directory_parameter):
    from app.models.auto_models import StockMovements

    ok, error = load_data_task(directory_parameter, StockMovements)
    if not ok:
        raise error

def load_sales_task(directory_parameter):
    from app.models.auto_models import Sales

    ok, error = load_data_task(directory_parameter, Sales)
    if not ok:
        raise error

def update_rm_daily_task(directory_parameter):
    ok, error = load_data_task(directory_parameter, None, 'stock_out')
    if not ok:
        raise error

def update_rm_weekly_task(directory_parameter):
    ok, error = load_data_task(directory_parameter, None, 'stock_in')
    if not ok:
        raise error

    
        
            
            
    