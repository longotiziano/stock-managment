from app.kafka_python.producer import handle_db_errors
from app.repositories.raw_material_repository import RawMaterialRepository
import pandas as pd
from abc import ABC, abstractmethod
    
class Verifier(ABC):
    @handle_db_errors
    def _get_existing_values(self, r_id: int) -> list:
        ''' 
        Obteniendo los valores existentes de tablas particulares
        '''
        return [
            getattr(r, self.name)
            for r in self.session.query(self.model).filter(self.model.r_id == int(r_id)).all()
        ]
        
    def __init__(self, session):
        self.session = session
        
    @property
    @abstractmethod
    def model(self):
        pass

    @property
    @abstractmethod
    def name(self):
        pass

class VerifyExistence(Verifier):
    def verify_existence_from_df(self, r_id: int, df: pd.DataFrame) -> tuple[bool, None | list]:
        '''
        Verificando elementos solo para DataFrames
        '''
        existing_values = self._get_existing_values(r_id)
        errors = []
        for row in df.itertuples():
            value = getattr(row, self.name)    
            if value not in existing_values:
                errors.append(value)
        
        if errors:
            return False, errors
        
        return True, None
    
    def verify_existence(self, r_id: int, value: str) -> tuple[bool, None | str]:
        '''
        Verificando valores singulares por su existencia en al base de datos
        '''
        existing_values = self._get_existing_values(r_id)

        if value not in existing_values:
            return False, value
        return True, None
    
class StockAmountVerifier(Verifier):
    def verify_negative_amounts_from_df(self, df: pd.DataFrame) -> tuple[bool, None | list]:
        '''
        Previniendo cantidades negativas en el DataFrame
        '''
        errors = []
        for row in df.itertuples():
            if row.amount < 0:
                # Using getattr when I don't know the attribute until ejecution
                errors.append(getattr(row, self.name))
        if errors:
            return False, errors
        return True, None
            
    def verify_amount(self, r_id: int, name: str, amount: float) -> tuple[bool, None | str]:
        '''
        Verificando cantidades singulares
        '''
        repository = RawMaterialRepository(self.session)
        rm_amount = repository._get_rm_amount(r_id, name)
        if rm_amount < amount:
            return False, name
        return True, None
        
    def verify_amount_from_df(self, r_id: int, df: pd.DataFrame) -> tuple[bool, None | list]:
        '''
        Verificando que la cantidad del DataFrame no supere a la existente en la base de datos
        '''
        errors = []

        for row in df.itertuples():
            amount_ok, rm_amount = self.verify_amount(r_id, getattr(row, self.name), row.amount)
            if not amount_ok:
                errors.append(rm_amount)

        if errors:
            return False, errors
        return True, None
