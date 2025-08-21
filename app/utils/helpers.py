import os

def list_csv_files(directory: str) -> tuple[bool, tuple[str, list] | Exception]:
    '''
    Devuelve una lista de CSVs en el directorio dado
    '''
    try:
        csv_files = [f for f in os.listdir(directory) if f.endswith(".csv")]
    except Exception as e:
        return False, e

    return True, (directory, csv_files) 
