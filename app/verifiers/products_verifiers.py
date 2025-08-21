from app.verifiers.base_verifier import VerifyExistence, StockAmountVerifier
from app.models.auto_models import Products
from app.kafka_python.producer import log_and_return
import pandas as pd

class ProductVerifier(VerifyExistence, StockAmountVerifier):
    @property
    def model(self):
        return Products

    @property
    def name(self):
        return "product_name"

class ProductDfVerifier(ProductVerifier):
    def products_df_verifier(self, r_id: int, df: pd.DataFrame) -> tuple[bool, str | dict]:
        '''
        Verifica los aspectos de los productos en un DataFrame
        - Su existencia
        - Cantidades negativas
        Si pasa la verificación con éxito devolverá (True, None), de lo contrario devolverá un diccionario que indica
        los tipos de errores y una lista con los valores problemáticos
        '''
        errors_dict = {}
        exists_ok, exists_err = self.verify_existence_from_df(r_id, df)
        if not exists_ok:
            log_and_return(r_id, f'CoincidenceErrors : {exists_err}', 'DEBUG', __name__)
            errors_dict['coincidence_errors'] = exists_err  

        negative_ok, negative_err = self.verify_negative_amounts_from_df(df)
        if not negative_ok:
            log_and_return(r_id, f'NegativeValues : {negative_err}', 'DEBUG', __name__)
            errors_dict['negative_values'] = negative_err

        if errors_dict:
            log_and_return(r_id, f'RawMaterialVerification : Failure', 'ERROR', __name__)
            return False, errors_dict
        
        log_and_return(r_id, 'RawMaterialVerification : Finished', 'INFO', __name__)
        return True, None