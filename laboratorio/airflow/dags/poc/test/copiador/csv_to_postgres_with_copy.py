"""UNIVERSIDAD NACIONAL DE ASUNCION - FACULTAD POLITECNICA (FPUNA)

Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data

Descripción:
    DAG para cargar datos de forma masiva (Bulk Data Loading) desde un archivo CSV en una
    base de datos PostgreSQL usando el comando COPY para copiar datos entre una tabla y un archivo.

Autor: Prof. Richar D. Jiménez-R. <rjimenez@pol.una.py>
Fecha_creación: Octubre, 2024
Version: 1.0
"""

from __future__ import annotations

import os
from airflow import DAG
from airflow.models import Variable
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.providers.postgres.operators.postgres import PostgresOperator
from jinja2 import Environment, FileSystemLoader

# Parámetros de configuración inicial
DAG_ID='csv_to_postgres_with_copy'
TABLE_SCHEMA='raw'
TABLE_TARGET_1='raw_sfp_nomina'
TABLE_TARGET_2='raw_sfp_nomina_eliminado'
TABLE_TEMP='temp_sfp_nomina'

# ID de conexión a PostgreSQL
POSTGRES_CONN_ID='postgres_dwh'

# Ubicación de archivos SQL
SQL_FILE_PATH=Variable.get("DAG_FOLDER") + 'test/copiador/sql'

# Ubicación del archivo CSV
CSV_FILE_PATH=Variable.get('DATASET_PATH_INPUT') + Variable.get('DATASET_SFP_NOMINA')

SQL_CREATE_TEMP_TABLE=f"""
    CREATE TEMP TABLE {TABLE_TEMP} (
        anho int2,
        mes int2,
        nivel int2,
        descripcion_nivel text,
        entidad int2,
        descripcion_entidad text,
        oee int2,
        descripcion_oee text,
        documento text,
        nombres text,
        apellidos text,
        funcion text,
        estado text,
        carga_horaria text,
        anho_ingreso int2,
        sexo text,
        discapacidad text,
        tipo_discapacidad text,
        fuente_financiamiento int2,
        objeto_gasto int2,
        concepto text,
        linea text,
        categoria text,
        cargo text,
        presupuestado int4,
        devengado int4,
        movimiento text,
        lugar text,
        fecha_nacimiento text,
        fec_ult_modif text,
        uri text,
        fecha_acto text,
        correo text,
        profesion text,
        motivo_movimiento text
    );        
"""

SQL_LOAD_TABLE= f"""
    INSERT INTO {TABLE_SCHEMA}.{TABLE_TARGET_1}
    SELECT
        anho,
        mes,
        nivel,
        descripcion_nivel,
        entidad,
        descripcion_entidad,
        oee,
        descripcion_oee,
        documento,
        nombres,
        apellidos,
        sexo,
        fecha_nacimiento,
        discapacidad,
        tipo_discapacidad,
        profesion,
        anho_ingreso,
        cargo,
        funcion,
        estado,
        fuente_financiamiento,
        objeto_gasto,
        concepto,
        linea,
        categoria,
        presupuestado,
        devengado
    FROM {TABLE_TEMP}
    WHERE NOT (presupuestado = 0 AND devengado = 0);
"""

SQL_LOAD_TABLE_ELIMINADO= f"""
    INSERT INTO {TABLE_SCHEMA}.{TABLE_TARGET_2}
    SELECT
        anho,
        mes,
        nivel,
        descripcion_nivel,
        entidad,
        descripcion_entidad,
        oee,
        descripcion_oee,
        documento,
        nombres,
        apellidos,
        sexo,
        fecha_nacimiento,
        discapacidad,
        tipo_discapacidad,
        profesion,
        anho_ingreso,
        cargo,
        funcion,
        estado,
        fuente_financiamiento,
        objeto_gasto,
        concepto,
        linea,
        categoria,
        presupuestado,
        devengado
    FROM {TABLE_TEMP}
    WHERE presupuestado = 0 AND devengado = 0;
"""

# Definir argumentos por defecto para el DAG
default_args = {
    'owner': 'rjimenez',
    'start_date': None,
    'retries': None,
}

# Función Python para copiar el archivo CSV al servidor de PostgreSQL
def load_csv_to_postgres():

    # Crear la conexión a PostgreSQL (usando el ID de la conexión configurada en Airflow)
    hook = PostgresHook(postgres_conn_id=POSTGRES_CONN_ID)

    # Crear la consulta de carga masiva usando el comando COPY de PostgreSQL
    copy_sql = f"""
        COPY {TABLE_TEMP} FROM stdin WITH(FORMAT csv, HEADER true, DELIMITER ',');
    """

    # Abrir archivo CSV y cargarlo a PostgreSQL
    if os.path.exists(CSV_FILE_PATH):
        with open(CSV_FILE_PATH, 'r', encoding='ISO-8859-1') as f:
            conn = hook.get_conn()
            cursor = conn.cursor()
            try:
                cursor.execute(SQL_CREATE_TEMP_TABLE)
                cursor.copy_expert(sql=copy_sql, file=f)
                cursor.execute(SQL_LOAD_TABLE)
                cursor.execute(SQL_LOAD_TABLE_ELIMINADO)
                conn.commit()
            except Exception as e:
                conn.rollback()
            finally:
                cursor.close()
                conn.close()
    else:
        print(f"El archivo {CSV_FILE_PATH} no existe.")

# Definir el DAG
with DAG(
    dag_id=DAG_ID,
    description='DAG Bulk Data Loading CSV to PostgreSQL with COPY.',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
    tags=['csv_bulk_data', 'postgres_copy', 'test']
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