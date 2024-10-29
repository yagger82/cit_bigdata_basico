"""UNIVERSIDAD NACIONAL DE ASUNCION - FACULTAD POLITECNICA (FPUNA)

Proyecto Centro de Innovación TIC - Curso Básico de Introducción a Big Data

Descripción:
    DAG para procesar ETL - DWH

Autor: Prof. Ing. Richard D. Jiménez-R. <rjimenez@pol.una.py>
Fecha_creación: Octubre, 2024
Version: 1.0
"""

from __future__ import annotations

from airflow.models.dag import DAG
from airflow.operators.empty import EmptyOperator
from airflow.utils.edgemodifier import Label
from airflow.utils.task_group import TaskGroup

import dwh.datospy.sfp.remuneracion.etl.raw.task_extract_nomina as rn
import dwh.datospy.sfp.remuneracion.etl.raw.task_extract_oee as ro
import dwh.datospy.sfp.remuneracion.etl.stage.task_load_dimension as dim
import dwh.datospy.sfp.remuneracion.etl.datamart.task_load_fact_table as fact

# Parámetros de configuración inicial
DAG_ID='fact-remuneracion-sfp-etl'

# Definir argumentos por defecto para el DAG
default_args = {
    'owner': 'rjimenez',
    'start_date': None,
    'retries': None,
}

# [START ETL PROCESS]
with DAG(
    dag_id=DAG_ID,
    description='ETL Process in Data Warehouse SFP fact_pago_remuneracion',
    default_args=default_args,
    schedule_interval=None,
    catchup=False,
    tags=['dwh', 'sfp', 'mensual']
) as dag:

    start = EmptyOperator(task_id="start")

    # [START section_extract_data]
    with TaskGroup("taks_extraction", tooltip="Tasks for raw data") as taks_extraction:

        with TaskGroup("extract_data_oee", tooltip="Tasks for raw data") as extract_data_oee:
            task1 = ro.truncate_table()
            task2 = ro.load_csv_to_table()

            task1 >> task2

        with TaskGroup("extract_data_nomina", tooltip="Tasks for raw data") as extract_data_nomina:
            task1 = rn.truncate_table()
            task2 = rn.load_csv_to_table()

            task1 >> task2
    # [END section_extract_data]

    # [START section_transform_data]
    with TaskGroup("taks_transformation", tooltip="Tasks for stage data") as taks_transformation:
        star = EmptyOperator(task_id="star")
        task2 = dim.load_dim_institucion()
        task3 = dim.load_dim_funcionario()
        success = EmptyOperator(task_id="success")

        star >> [task2, task3] >> success
    # [END section_transform_data]

    # [START section_load_data]
    with TaskGroup("taks_loading", tooltip="Tasks for datamart") as taks_loading:
        task1 = fact.load_fact_table_temporal()
        task2 = fact.load_fact_table()
        task3 = fact.load_fact_table_pendiente()
        task4 = fact.load_fact_table_duplicado()

        task1 >> task2 >> task3 >> task4
    # [END section_load_data]

    end = EmptyOperator(task_id="end")

    # Definir orden de ejecución de tareas
    start >> Label("EXTRACT") >> taks_extraction
    taks_extraction >> Label("TRANSFORM") >> taks_transformation
    taks_transformation >> Label("LOAD") >> taks_loading >> end

# [END ETL PROCESS]