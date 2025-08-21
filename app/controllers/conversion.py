from app.models.auto_models import RawMaterial, Products, Recipes
from app.repositories.products_repository import ProductsRepository
from app.repositories.raw_material_repository import RawMaterialRepository
from app.kafka_python.producer import handle_db_errors, log_and_return
import pandas as pd
from typing import Literal
from collections import defaultdict
from sqlalchemy.orm import Session

@handle_db_errors 
def products_to_raw_material_df(r_id: int, df: pd.DataFrame, session: Session) -> tuple[bool, pd.DataFrame]:
    '''
    When received the products Dataframe, it returns a raw material Dataframe
    '''    
    raw_material_amounts = defaultdict(float)

    for row in df.itertuples():
        # Give me the name and it's amount where the name it's equal to the one from the Dataframe
        amount_by_products = (
            session.query(RawMaterial.rm_name, Recipes.rm_amount)
            .join(RawMaterial, RawMaterial.rm_id == Recipes.rm_id)
            .join(Products, Products.product_id == Recipes.product_id)
            .filter(
                Recipes.r_id == int(r_id),
                Products.product_name == row.product_name
            )
            .all()
        )
        for rm_name, rm_amount in amount_by_products:
            raw_material_amounts[rm_name] += float(rm_amount) * row.amount

    log_and_return(r_id, 'FinishedConversion : "products_to_raw_material_df"', 'INFO', __name__)
    return True, pd.DataFrame([
        {'r_id': r_id, 'rm_name': k, 'amount': v}
        for k, v in raw_material_amounts.items()
    ])
    
def products_df_to_sales(r_id: int, df: pd.DataFrame, session: Session) -> tuple[bool, pd.DataFrame | list]:
    '''
    Given a products DataFrame, returns a list of sales dictionaries
    with product IDs matched by name.
    '''
    # Obtaining all the IDs with a query 
    repo = ProductsRepository(session)
    ok, product_map = repo.obtain_name_id_dict(r_id)
    # Handling DB errors, with product_map as the possible error
    if not ok:
        return False, product_map
    
    list_of_dicts = []
    for row in df.itertuples():
        # Getting the IDs of the matched products
        product_id = product_map.get(row.product_name)
        sales_dict = {
            'r_id': r_id,
            'product_id': product_id,
            'sale_quantity': row.amount
        }

        list_of_dicts.append(sales_dict)

    log_and_return(r_id, 'FinishedConversion : "products_df_to_sales"', 'INFO', __name__)
    return True, pd.DataFrame(list_of_dicts)


def raw_material_to_stock_movements(
    r_id: int,  
    df: pd.DataFrame, 
    session: Session,
    direction: Literal["stock_in", "stock_out"] = "stock_in"
    ) -> tuple[bool, pd.DataFrame | list]:
    '''
    Given a raw material DataFrame, returns a list of stock movements dictionaries
    with product IDs matched by name.
    '''
    # Obtaining all the IDs with a query 
    repo = RawMaterialRepository(session)
    ok, raw_material_map = repo.obtain_name_id_dict(r_id)
    # Handling DB errors, with product_map as the possible error
    if not ok:
        return False, raw_material_map
    
    list_of_dicts = []
    for row in df.itertuples():
        # Getting the IDs of the matched products
        rm_id = raw_material_map.get(row.rm_name)
        stock_movement_dict = {
            'r_id' : r_id,
            'rm_id' : rm_id,
            'movement_amount' : row.amount,
            'movement_type' : direction
        }
        
        list_of_dicts.append(stock_movement_dict)

    log_and_return(r_id, 'FinishedConversion : "raw_material_to_stock_movements"', 'INFO', __name__)    
    return True, pd.DataFrame(list_of_dicts)
        
        
        
