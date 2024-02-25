import psycopg2
from psycopg2 import OperationalError
import pandas as pd
from sqlalchemy import create_engine
from List_CSV import dameArchivos, obtenerRutaDataCSV
import re

def to_snake_case(name):
    """
    Convierte un string a snake_case.
    
    Parameters:
    - name (str): El string a convertir.
    
    Returns:
    - str: El string convertido a snake_case.
    """
    name = re.sub(r'\W+', '_', name)
    return name.lower()

def establecer_conexion(db_config):
    """
    Establece una conexión a la base de datos PostgreSQL.

    Parameters:
    - db_config (dict): Configuración de la base de datos.

    Returns:
    - connection (psycopg2.extensions.connection): Objeto de conexión PostgreSQL.
    """
    try:
        connection = psycopg2.connect(**db_config)
        return connection
    except OperationalError as e:
        print(f"Error de conexión: {e}")
        return None

def crear_tabla_desde_csv(connection, tabla_nombre, ruta_csv):
    """
    Crea una tabla en la base de datos a partir de un archivo CSV.

    Parameters:
    - connection (psycopg2.extensions.connection): Objeto de conexión PostgreSQL.
    - tabla_nombre (str): Nombre de la tabla a crear.
    - ruta_csv (str): Ruta del archivo CSV.

    Returns:
    - None
    """
    try:
        engine = create_engine('postgresql://', creator=lambda: connection)
        data = pd.read_csv(ruta_csv)

        # Convertir los nombres de las columnas a snake_case o minúsculas
        data.columns = [to_snake_case(c) for c in data.columns]

        # Asegurar que el nombre de la tabla también esté en snake_case o minúsculas
        tabla_nombre_formato = to_snake_case(tabla_nombre)

        data.to_sql(tabla_nombre_formato, engine, if_exists='replace', index=False)
        print(f"Tabla '{tabla_nombre_formato}' creada exitosamente desde {ruta_csv}")
    except Exception as e:
        print(f"Error al crear la tabla desde el archivo CSV: {e}")

# Configuración de la base de datos
db_config = {
    'user': 'postgres',
    'password': 'BDpassWord@1',
    'host': 'localhost',
    'port': '5432',
    'database': 'ApuestasFutbolPG'
}

# Carpeta de archivos csv
carpeta_archivos_csv = obtenerRutaDataCSV() 
# Nombre de archivos csv
archivos_csv = dameArchivos(carpeta_archivos_csv)

# Establecer conexión
conexion = establecer_conexion(db_config)

if conexion:
    # Ruta de cada archivo
    for archivo_csv in archivos_csv:
        ruta_archivo_csv = f'{carpeta_archivos_csv}/{archivo_csv}'
        # Crear tabla en la base de datos desde el archivo CSV
        crear_tabla_desde_csv(conexion, archivo_csv[:-4], ruta_archivo_csv)
    
    # Cerrar conexión al finalizar
    conexion.close()
else:
    print("No se pudo establecer la conexión.")
