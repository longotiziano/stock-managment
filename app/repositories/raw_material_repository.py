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
        Building the dict that works for updating the database
        '''
        return dict(zip(df['rm_name'], df['amount']))

    @handle_db_errors
    def _get_rm_amount(self, r_id: int, name: str) -> float:
        '''
        Getting the stored amount of an specific raw material
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
        Updating the stock amounts based on the DataFrame
        ''' 
        # Build the lookup dict from the dataframe
        rm_dict = self._rm_df_to_dict(df)

        # Query the stocks belonging to the restaurant and matching the raw material names
        stocks = (
            self.session.query(Stock)
            .join(RawMaterial, Stock.rm_id == RawMaterial.rm_id)
            .filter(
                RawMaterial.r_id == int(r_id),
                RawMaterial.rm_name.in_(rm_dict.keys())
            )
            .options(joinedload(Stock.raw_material))  # Load relationships in one go
            .all()
        )

        # Update the stock amounts
        for stock in stocks:
            rm_name = stock.raw_material.rm_name
            amount = rm_dict.get(rm_name, 0)
            if direction == "stock_out":
                amount = -amount
            stock.stock_amount = float(stock.stock_amount) + amount
                    
    def create_csv_stock(self) -> tuple[bool, str | Exception]:
        '''
        Creates a random stock addition CSV file for every restaurant in the database and returns the directory.
        '''
        # Local import to avoid circular import
        from app.verifiers.raw_material_verifiers import RawMaterialVerifier 
        import time

        restaurants_id = self.get_restaurants()

        raw_material = RawMaterialVerifier(self.session)

        for r_id in restaurants_id:
            raw_material_list = raw_material._get_existing_values(r_id)
            # Here I use "for" in case that we want to change the addition of an especific stock
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
