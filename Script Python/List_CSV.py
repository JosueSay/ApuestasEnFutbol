import os
import sys

# Obtener el directorio "DataCSV"
def obtenerRutaDataCSV():
    # Ruta del script de ejecución
    ruta_script = os.path.realpath(sys.argv[0])

    # Directiorio con la data csv
    ruta_data = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(ruta_script))), "ApuestasEnFutbol", "DataCSV")

    return ruta_data

# Obtener el nombre de archivos csv
def dameArchivos(_ruta):
    # Obtiene la lista de archivos en la ruta
    archivos_csv = os.listdir(_ruta)
    return archivos_csv

# Imprime el nombre de cada archivo
def verArchivos(_lista_archivos):
    x = 1 # contador
    for archivo in _lista_archivos: # recorrer nombre de archivos
        print(f'{x}. {archivo}')
        x += 1

# Función principal para probar todo
def probarCodigo():
    # Obtener la ruta de "DataCSV"
    ruta_data = obtenerRutaDataCSV()

    # Probar funciones
    archivos_csv = dameArchivos(ruta_data)
    verArchivos(archivos_csv)

# Llamar a la función principal para probar el código
#probarCodigo()
