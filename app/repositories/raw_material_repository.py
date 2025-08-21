from app.kafka_python.producer import handle_db_errors, log_and_return
from app.models.auto_models import RawMaterial, Stock
from app.repositories.base_repository import Repository
from sqlalchemy.orm import joinedload
import pandas as pd
from typing import Literal
from pathlib import Path
    
class RawMaterialRepository(Repository):
    model = RawMaterial
    name = 'rm_name'
    id = 'rm_id'
    
    def _rm_df_to_dict(self, df: pd.DataFrame) -> dict:
        '''
        Construye el diccionario que funciona para actualizar la base de datos
        '''
        return dict(zip(df['rm_name'], df['amount']))

    @handle_db_errors
    def _get_rm_amount(self, r_id: int, name: str) -> float:
        '''
        Obtiene la cantidad almacenada de una materia prima específica
        '''
        rm_amount = self.session.query(Stock.stock_amount)\
            .join(RawMaterial, RawMaterial.rm_id == Stock.rm_id)\
            .filter(
                RawMaterial.r_id == r_id,
                RawMaterial.rm_name == name
            ).scalar()
        return rm_amount

    @handle_db_errors
    def update_stock_amounts(
        self, 
        r_id: int,  
        df: pd.DataFrame,   
        direction: Literal["stock_in", "stock_out"] = "stock_in"
        ) -> None:
        '''
        Actualizando las cantidades de stock basadas en un DataFrame
        ''' 
        # Construyendo el diccionario
        rm_dict = self._rm_df_to_dict(df)

        # Consultando el stock perteneciente al restaurante y coincidiendoló al nombre de las respectivas materias primas
        stocks = (
            self.session.query(Stock)
            .join(RawMaterial, Stock.rm_id == RawMaterial.rm_id)
            .filter(
                RawMaterial.r_id == int(r_id),
                RawMaterial.rm_name.in_(rm_dict.keys())
            )
            .options(joinedload(Stock.raw_material))  
            .all()
        )

        # Actualizar las cantidades
        for stock in stocks:
            rm_name = stock.raw_material.rm_name
            amount = rm_dict.get(rm_name, 0)
            if direction == "stock_out":
                amount = -amount
            stock.stock_amount = float(stock.stock_amount) + amount
                    
    def create_csv_stock(self) -> tuple[bool, str | Exception]:
        '''
        Crea un archivo CSV de agregación de stock para cada restaurante en la base de datos y
        devuelve su directorio
        '''
        # Importación local para evitar importación circular
        from app.verifiers.raw_material_verifiers import RawMaterialVerifier 
        import time

        restaurants_id = self.get_restaurants()

        raw_material = RawMaterialVerifier(self.session)

        for r_id in restaurants_id:
            raw_material_list = raw_material._get_existing_values(r_id)
            # Aquí uso "for" en el caso que queramos aplicar cambios en la agregación de algún específico stock
            rm_and_amount = []
            for rm in raw_material_list:
                amount = 10000
                if r_id == 1:
                    if rm == 'eggs':
                        amount = 100
                rm_and_amount.append({'r_id': r_id, 'rm_name': rm, 'amount': amount})
            
            BASE_DIR = Path(__file__).parent.parent.parent
            directory = BASE_DIR / "data" / "addition"
            ok, error = self._save_csv(r_id, rm_and_amount, directory, 'stock_addition')
            if not ok:
                log_and_return(r_id, f'FileError : "stock_addition.csv"', 'ERROR', __name__)
                return False, error
            log_and_return(r_id, f'FileCreated : "stock_addition.csv"', 'INFO', __name__)
        
        return True, str(directory)
