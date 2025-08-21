from app.kafka_python.producer import handle_db_errors
from app.models.auto_models import Restaurants
import pandas as pd
import os

class Repository():
    model = None
    name = None
    id = None
    
    def __init__(self, session):
        self.session = session
    
    @handle_db_errors
    def obtain_name_id_dict(self, r_id: int) -> tuple[bool, dict]:
        '''
        Función dinámica que retorna un diccionario {'name':id} para mejor inserción en los diferentes
        repositorios con una única consulta
        '''
        results = self.session.query(
            getattr(self.model, self.name),
            getattr(self.model, self.id)
        ).filter(
            getattr(self.model, 'r_id') == int(r_id)
        ).all()
        
        return True, dict(results)
    
    def get_restaurants(self) -> list:
        '''
        Devuelve una lista de los IDs de los restaurantes registrados en la bse de datos
        '''
        return [r[0] for r in self.session.query(Restaurants.r_id).filter(Restaurants.r_id != -9999).all()]
    
    def _save_csv(self, r_id: int, data: list[dict], directory: str, filename_suffix: str) -> tuple[bool, None | Exception]:
        '''
        Recibe una lista de diccionarios o tuplas y crea un CSV para el ID de restaurante asignado
        '''
        try:    
            df = pd.DataFrame(data)
            path = os.path.join(directory, f"{r_id}_id_{filename_suffix}.csv")
            df.to_csv(path, index=False)
        
        except Exception as e:
            return False, e
        
        return True, None
    


