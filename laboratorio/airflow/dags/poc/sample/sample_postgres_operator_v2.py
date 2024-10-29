#Importa los módulos necesarios
from airflow import DAG
from airflow.models import Variable
from airflow.operators.empty import EmptyOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.dates import days_ago

#Define los argumentos del DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(0),
    'retries': 0,
}

# Crea el DAG
dag = DAG(
    dag_id="postgres_operator_v2",
    default_args=default_args,
    description='Este es un DAG de prueba con el Operador de PostgreSQL para modularizar Scripts SQL.',
    schedule_interval=None,  # Frecuencia de ejecución del DAG (@once)
    template_searchpath=Variable.get('DAG_FOLDER') + 'sample/sql',
    catchup=False,
    tags=['sample']
)

# Agregar los operadores PostgresOperator
with dag:

    start = EmptyOperator(task_id='start', dag=dag)

    execute_sql_step_1 = PostgresOperator(
        task_id='execute_sql_step_1',
        sql='postgres_operator_v2_step_1.sql'  # Ruta al archivo SQL
    )

    execute_sql_step_2 = PostgresOperator(
        task_id='execute_sql_step_2',
        sql='postgres_operator_v2_step_2.sql'  # Ruta al archivo SQL
    )

    end = EmptyOperator(task_id='end', dag=dag)

start >> execute_sql_step_1 >> execute_sql_step_2 >> end