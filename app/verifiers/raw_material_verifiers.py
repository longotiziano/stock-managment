from app.kafka_python.producer import log_and_return
from app.models.auto_models import RawMaterial
from app.verifiers.base_verifier import VerifyExistence, StockAmountVerifier
import pandas as pd
from typing import Literal

class RawMaterialVerifier(VerifyExistence, StockAmountVerifier):
    @property
    def model(self):
        return RawMaterial
    
    @property
    def name(self):
        return "rm_name"

class RawMaterialDfVerifier(RawMaterialVerifier):
    '''
    Verifies aspects the raw materials in the DataFrame
    - Their existence
    - Negative amounts
    - Checks if the storage is enough for every amount
    And returns (True, "") if it's everything OK, otherwise it will return (False, errors_dict)
    - errors_dict is a dict that indicates the error type and the list of problematic values
    '''
    def rm_df_verifier(
        self,   
        r_id: int, 
        df: pd.DataFrame, 
        direction: Literal["stock_in", "stock_out"] = "stock_in"
        ) -> tuple[bool, None | dict]:
        errors_dict = {}

        exists_ok, exists_err = self.verify_existence_from_df(r_id, df)
        if not exists_ok:
            log_and_return(r_id, f'CoincidenceErrors : {exists_err}', 'DEBUG', __name__)
            errors_dict['coincidence_errors'] = exists_err  

        negative_ok, negative_err = self.verify_negative_amounts_from_df(df)
        if not negative_ok:
            log_and_return(r_id, f'NegativeValues : {negative_err}', 'DEBUG', __name__)
            errors_dict['negative_values'] = negative_err

        if direction == "stock_out":
            amount_ok, amount_err = self.verify_amount_from_df(r_id, df)
            if not amount_ok:
                log_and_return(r_id, f'StorageExceeded : {amount_err}', 'DEBUG', __name__)
                errors_dict['storage_exceeded'] = amount_err

        if errors_dict:
            log_and_return(r_id, f'RawMaterialVerification : Failure', 'ERROR', __name__)
            return False, errors_dict
        
        log_and_return(r_id, 'RawMaterialVerification : Finished', 'INFO', __name__)
        return True, None
    
