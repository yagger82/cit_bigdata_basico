"""UNIVERSIDAD NACIONAL DE ASUNCION - FACULTAD POLITECNICA (FPUNA)

Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data

Descripción:
    DAG para cargar un archivo CSV a una base de datos PostgreSQL usando pandas.to_sql()
    y configurar las columnas a insertar, sigue estos pasos:

Autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
Fecha_creación: Octubre, 2024
Version: 1.0
"""

from __future__ import annotations

import pandas as pd
from airflow import DAG
from airflow.models import Variable
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from jinja2 import Environment, FileSystemLoader
from sqlalchemy import create_engine

# Parámetros de configuración inicial
DAG_ID='csv_to_postgres_with_panda'
TABLE_SCHEMA='raw'
TABLE_TARGET_1='raw_sfp_nomina'
TABLE_TARGET_2='raw_sfp_nomina_eliminado'

# ID de conexión a PostgreSQL
POSTGRES_CONN_ID='postgres_dwh'

# URL de conexión a PostgreSQL
POSTGRES_CONN_URL=Variable.get('POSTGRES_CONN_URL_DWH')

# Ubicación de archivos SQL
SQL_FILE_PATH=Variable.get("DAG_FOLDER") + 'test/copiador/sql'

# Ubicación del archivo CSV
CSV_FILE_PATH=Variable.get('DATASET_PATH_INPUT') + Variable.get('DATASET_SFP_NOMINA')

CSV_COLUMNS_NAME=[
    'anho',
    'mes',
    'nivel',
    'descripcion_nivel',
    'entidad',
    'descripcion_entidad',
    'oee',
    'descripcion_oee',
    'documento',
    'nombres',
    'apellidos',
    'sexo',
    'fecha_nacimiento',
    'discapacidad',
    'tipo_discapacidad',
    'profesion',
    'anho_ingreso',
    'cargo',
    'funcion',
    'estado',
    'fuente_financiamiento',
    'objeto_gasto',
    'concepto',
    'linea',
    'categoria',
    'presupuestado',
    'devengado'
]

CSV_COLUMNS_TYPE={
    'anho':'int16',
    'mes':'int16',
    'nivel':'int16',
    'descripcion_nivel':'object',
    'entidad':'int16',
    'descripcion_entidad':'object',
    'oee':'int16',
    'descripcion_oee':'object',
    'documento':'object',
    'nombres':'object',
    'apellidos':'object',
    'sexo':'object',
    'fecha_nacimiento':'object',
    'discapacidad':'object',
    'tipo_discapacidad':'object',
    'profesion':'object',
    'anho_ingreso':'int16',
    'cargo':'object',
    'funcion':'object',
    'estado':'object',
    'fuente_financiamiento':'object',
    'objeto_gasto':'object',
    'concepto':'object',
    'linea':'object',
    'categoria':'object',
    'presupuestado':'int32',
    'devengado':'int32'
}

# Definir argumentos por defecto para el DAG
default_args = {
    'owner': 'airflow',
    'start_date': None,
    'retries': None,
}

# Función Python para copiar el archivo CSV al servidor de PostgreSQL
def load_csv_to_postgres():

    # Leer el archivo CSV, seleccionando solo las columnas deseadas
    df = pd.read_csv(CSV_FILE_PATH, encoding='ISO-8859-1', usecols=CSV_COLUMNS_NAME, dtype=CSV_COLUMNS_TYPE)

    # Crear la conexión a la base de datos PostgreSQL
    engine = create_engine(POSTGRES_CONN_URL)

    # Cargar los datos en la tabla de PostgreSQL
    df1 = df.query('not (presupuestado == 0 and devengado == 0)')
    df1.to_sql(name=TABLE_TARGET_1, con=engine, schema=TABLE_SCHEMA, if_exists='replace', index=False)

    # Cargar los datos en la tabla de eliminados
    df2= df.query('presupuestado == 0 and devengado == 0')
    df2.to_sql(name=TABLE_TARGET_2, con=engine, schema=TABLE_SCHEMA, if_exists='replace', index=False)

# Definir el DAG
with DAG(
    dag_id=DAG_ID,
    description='DAG Bulk Data Loading CSV to PostgreSQL with panda to_sql.',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
    tags=['csv_bulk_data', 'panda_to_sql', 'test']
) as dag:

    start = EmptyOperator(task_id='start', dag=dag)

    # Configurar Jinja2
    env = Environment(loader=FileSystemLoader(SQL_FILE_PATH))
    template = env.get_template('task_truncate_table_nomina.sql')

    # Renderizar el archivo SQL con los parámetros
    rendered_sql = template.render(schema=TABLE_SCHEMA, target_1=TABLE_TARGET_1, target_2=TABLE_TARGET_2)

    # Tarea 1: Truncar datos de la tabla Target en PostgreSQL
    truncate_data = PostgresOperator(
        task_id='truncate_table_data',
        postgres_conn_id=POSTGRES_CONN_ID,
        sql=rendered_sql
    )

    # Tarea 2: Cargar datos masivos de CSV a PostgreSQL
    load_bulk_data = PythonOperator(
        task_id='load_csv_bulk_data',
        python_callable=load_csv_to_postgres
    )

    end = EmptyOperator(task_id='end', dag=dag)

    # Definir el orden de las tareas
    start >> truncate_data >> load_bulk_data >> end