# 🚀 Apuestas En Futbol

¡Bienvenido/a a ApuestasEnFutbol! Este proyecto utiliza tecnologías de bases de datos para la creación y carga de modelos de datos, con el objetivo de utilizar lenguaje SQL para investigación, desarrollo y presentación de resultados sobre preguntas de negocio para apoyo de toma de decisiones.

## Enlace a repositorio
{"icon":{"category":"Logos","commonName":"git","id":"20906","name":"Git","platform":"color","isFree":true,"isColor":true,"isExplicit":false,"authorId":"","authorName":"icons8","sourceFormat":"svg"},"id":"20906","svg":null}
**Enlace:** https://github.com/JosueSay/ApuestasEnFutbol

## 📋 Descripción del Proyecto

El conjunto de datos a utilizar son archivos en formato CSV. Estos archivos contienen información detallada sobre todos los juegos de fútbol de las cinco principales ligas europeas entre las temporadas de 2014 a 2020 (7 años), así como información de los jugadores y sus características.

El objetivo general del proyecto es investigar los datos presentados para responder a la siguiente pregunta: **Basado en el desempeño de los equipos y jugadores según este modelo, ¿a qué equipo le apostaría usted?** Debe dar fundamentos basados en los datos.

## 📊 Resultados y Método de Análisis

*Equipos por el cual apostar:*

- **Paris Saint Germain en la "Ligue 1" o Bayern Munich en la "Bundesliga"**

¡Gracias por seguir nuestro proyecto ApuestasEnFutbol! 🌐⚽️

## 📂 Organización de Carpetas

- **Comprimibles:** En esta carpeta encontrarás el archivo `Data.rar`, que contiene todos los archivos CSV necesarios para el proyecto.

- **DataCSV:** Aquí se encuentran todos los archivos CSV que servirán como fuente de datos para el análisis.

- **Instrucciones:** Instrucciones del proyeto, incisos que se realizaron, etc.

- **Queries:** Todos los queries utilizados están organizados por etapas para facilitar la comprensión y ejecución, además de un excel donde se realizaron todas las estadísticas para fundamentar el equipo por el cual apostar.

- **Script Python:**
  - **List_CSV:** Este script enumera todos los archivos CSV disponibles en el proyecto.
  - **Script_CSV_To_Postgres:** Contiene el código necesario para pasar de archivos CSV a tablas en PostgreSQL usando pgAdmin 4.

## 🚀 Ejecutando el Script para Cargar CSV a PostgreSQL

Para ejecutar con éxito el script que carga los archivos CSV a la base de datos PostgreSQL, asegúrate de modificar la información en la sección `Script_CSV_To_Postgres`. Reemplaza 'tu_usuario_bd', 'tu_contraseña_bd', 'tu_host_bd', 'tu_puerto_bd', y 'tu_nombre_bd' con la información correspondiente de tu base de datos PostgreSQL. Esto es crucial para establecer la conexión adecuada y realizar la carga de datos correctamente.

```python
db_config = {
    'user': 'tu_usuario_bd',
    'password': 'tu_contraseña_bd',
    'host': 'tu_host_bd',
    'port': 'tu_puerto_bd',
    'database': 'tu_nombre_bd'
}
