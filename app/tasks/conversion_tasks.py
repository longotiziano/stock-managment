from app.kafka_python.producer import log_and_return
from app.utils.helpers import list_csv_files
from sql.database import SessionLocal
import pandas as pd
from typing import Callable, Any
from pathlib import Path
import os

def processing_csv_task(
    directory_parameter: str,
    function: Callable[..., Any],
    assigned_directory: str,
    file_name: str,
    **kwargs  
) -> tuple[bool, str | Exception]:
    '''
    Maneja las tareas de conversión, como ventas, movimientos de stock y materias primas
    '''
    log_and_return(-9999, 'Started : "processing_csv_task"', 'INFO', __name__)

    csv_ok, directory_csvs = list_csv_files(directory_parameter)
    if not csv_ok:
        log_and_return(-9999, f'FileError : {directory_csvs}', 'ERROR', __name__)
        return False, RuntimeError(f'Error while listing CSVs: {directory_csvs}')

    previous_directory, csv_files = directory_csvs

    with SessionLocal() as session:
        for file in csv_files:
            file_path = os.path.join(previous_directory, file)
            df = pd.read_csv(file_path)
            r_id = df['r_id'].iloc[0]
            try:
                database_ok, returned_df = function(r_id, df, session, **kwargs)
            except Exception as e:
                log_and_return(r_id, f'ExecutionError : {e}', 'ERROR', __name__)
                return False, RuntimeError(f'Error while executing {function.__name__} in {file}') 

            if not database_ok:
                # "returned_df" será una excepción de SQLAlchemy en caso de dar False
                # Este tipo de errores ya se loggean con el decorador
                return False, returned_df

            output_path = os.path.join(assigned_directory, f'{r_id}_id_{file_name}.csv')
            try:
                returned_df.to_csv(output_path, index=False)
            except Exception as e:
                log_and_return(r_id, f'FileError : {e}', 'ERROR', __name__)
                return False, RuntimeError(f"Couldn't save CSV file in {output_path}")

    return True, assigned_directory

BASE_DIR = Path(__file__).parent.parent.parent

def products_conversion_task(directory_parameter):
    from app.controllers.conversion import products_to_raw_material_df
    ok, directory = processing_csv_task(
        directory_parameter,
        function=products_to_raw_material_df,
        assigned_directory=str(BASE_DIR / "data" / "products-conversion"),
        file_name='products_conversion'
    )
    if not ok:
        raise directory
    return str(directory)

def products_to_sales_task(directory_parameter):
    from app.controllers.conversion import products_df_to_sales
    ok, directory = processing_csv_task(
        directory_parameter,
        function=products_df_to_sales,
        assigned_directory=str(BASE_DIR / "data" / "sales"),
        file_name='sales'
    )
    if not ok:
        raise directory
    return str(directory)

def rm_to_stock_movements_task(directory_parameter, direction_parameter):
    from app.controllers.conversion import raw_material_to_stock_movements
    ok, directory = processing_csv_task(
        directory_parameter,
        function=raw_material_to_stock_movements,
        assigned_directory=str(BASE_DIR / "data" / "stock-movements"),
        file_name='stock_movements',
        direction=direction_parameter
    )
    if not ok:
        raise directory
    return str(directory)
