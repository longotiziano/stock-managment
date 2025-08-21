from app.models.auto_models import Products
from app.repositories.base_repository import Repository
import pandas as pd
import random
from pathlib import Path

class ProductsRepository(Repository):
    model = Products
    name = 'product_name'
    id = 'product_id'

    def random_consumption(self) -> tuple[bool, None | Exception]:
        '''
        Crea un CSV de consumo aleatorio para cada restaurante en la base de datos y devuelve su directorio
        '''
        # Importación local para evitar importación circular
        from app.verifiers.products_verifiers import ProductVerifier

        restaurants_id = self.get_restaurants()
        products = ProductVerifier(self.session)

        for r_id in restaurants_id:
            products_list = products._get_existing_values(r_id)
            
            data = []
            for _ in range(50):
                product = random.choice(products_list)
                amount = random.randint(1, 10)
                data.append({'r_id': r_id,'product_name': product, 'amount': amount})
            
            BASE_DIR = Path(__file__).parent.parent.parent
            directory = BASE_DIR / "data" / "consumption"
            ok, error = self._save_csv(r_id, data, directory, 'products_consumption')
            if not ok:
                return False, error
            
        return True, directory
    