from app.kafka_python.producer import log_and_return
from app.utils.helpers import list_csv_files
from sql.database import SessionLocal
import pandas as pd
from typing import Literal, Optional, Any
import os

def verify_task(
    verifier_class: Any,
    directory: str,
    method_name: str,
    direction: Optional[Literal['stock_in', 'stock_out']] = None
) -> tuple[bool, str | Exception]: 
    '''
    Verifica los archivos CSV generados por una tarea anterior utilizando una clase y método específico
    No hay necesidad de loggear demasiada información ya que las funciones utilizadas en esta tarea ya se encargan
    de ello
    '''  
    log_and_return(-9999, 'Started : "verify_task"', 'INFO', __name__)

    ok, directory_csvs = list_csv_files(directory)
    if not ok:
        # "dir_csvs" será una excecpción si da False
        log_and_return(-9999, f'FileError : {directory_csvs}', 'ERROR', __name__)
        return False, RuntimeError(f'Error while listing CSVs: {directory_csvs}')
    
    directory, csv_files = directory_csvs

    failed_files = []
    with SessionLocal() as session:
        verifier = verifier_class(session)
        for file in csv_files:
            df = pd.read_csv(os.path.join(directory, file))
            r_id = df['r_id'].iloc[0]
            verifier_method = getattr(verifier, method_name)
            # Teniendo en cuenta que ProductDfVerifier no tiene un parámetro "direction", aplico esta estrategia
            if direction:
                ok, error = verifier_method(r_id, df, direction)
            else:
                ok, error = verifier_method(r_id, df)

            if not ok:
                failed_files.append((file, error))

    if failed_files:
        return False, ValueError(f'Please, verify the following files: {failed_files}')
        
    return True, directory

def verify_rm_task(
    directory_provided, 
    direction: Literal['stock_in', 'stock_out']
) -> str:
    from app.verifiers.raw_material_verifiers import RawMaterialDfVerifier
    
    ok, directory = verify_task(RawMaterialDfVerifier, directory_provided, 'rm_df_verifier', direction)
    if not ok:
        raise directory
    log_and_return(-9999, f'FinishedTask : "verify_rm_task"', 'INFO', __name__)    
    
def verify_products(directory_provided) -> str:
    from app.verifiers.products_verifiers import ProductDfVerifier
    
    ok, directory = verify_task(ProductDfVerifier, directory_provided, 'products_df_verifier')
    if not ok:
        raise directory
    log_and_return(-9999, f'FinishedTask : "verify_products_task"', 'INFO', __name__)        









