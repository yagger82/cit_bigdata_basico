from __future__ import annotations

from datetime import datetime

from airflow import DAG
from airflow.models import Variable
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator

import dwh.bcp.etl.raw.extract_data as ext

# Parámetros de configuración inicial
DAG_ID='fact-cotizacion-bcp-etl'

# Definición de los periodos de extracción de datos
ANHO_DESDE=2001
ANHO_HASTA=datetime.now().year

# Definición de divisas
MONEDAS=['USD', 'GBP', 'BRL', 'ARS', 'CLP', 'EUR', 'UYU', 'BOB', 'PEN', 'MXN', 'COP']
# MONEDAS=['USD', 'BRL', 'ARS', 'EUR']

# Definir argumentos por defecto para el DAG
default_args = {
    'owner': 'rjimenez',
    'start_date': None,
    'retries': None,
}

# [START ETL PROCESS]
with DAG(
        dag_id=DAG_ID,
        description='ETL Process in Data Warehouse: fact_cotizacion_mensual_bcp',
        default_args=default_args,
        template_searchpath=Variable.get('DAG_FOLDER') + 'dwh/bcp/etl',
        schedule_interval=None,
        catchup=False,
        tags=['dwh', 'bcp', 'mensual']
) as dag:

    start = EmptyOperator(task_id="start")

    extract = PythonOperator(
        task_id='extract',
        python_callable=ext.extract_data_to_raw,
        op_kwargs={'anho_desde': ANHO_DESDE,
                   'anho_hasta': ANHO_HASTA,
                   'monedas': MONEDAS}
    )

    transform = PostgresOperator(
        task_id='transform',
        postgres_conn_id='postgres_dwh',
        sql='/stage/sql/stg_dim_moneda_extranjera.sql',
    )

    load = PostgresOperator(
        task_id='load',
        postgres_conn_id='postgres_dwh',
        sql='/datamart/sql/fact_cotizacion_mensual_bcp.sql',
    )

    end = EmptyOperator(task_id="end")

    start >> extract >> transform >> load >> end

# [END ETL PROCESS]