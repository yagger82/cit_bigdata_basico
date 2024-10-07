from airflow import DAG
from airflow.operators.empty import EmptyOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.dates import days_ago
from airflow.models import Variable

# Define los argumentos del DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(0),
    'retries': 0,
}

# Crea el DAG
dag = DAG(
    dag_id="POSTGRES_OPERATOR_V1_DAG",
    default_args=default_args,
    description='DAG implementa un PostgresOperator único.',
    schedule_interval=None,  # Frecuencia de ejecución del DAG (@once)
    template_searchpath=Variable.get("dags_folder") + 'samples/sql',
    catchup=False,
    tags=['samples', 'postgresql', 'rjimenez']
)

# Agrega el operador PostgresOperator
with dag:

    start = EmptyOperator(task_id='START', dag=dag)

    task_execute_sql = PostgresOperator(
        task_id='EXECUTE_SQL',
        sql='postgres_operator_v1.sql',  # Ruta al archivo SQL
        postgres_conn_id='postgres_default',  # Nombre de la conexión configurada en el airflow web
    )

    end = EmptyOperator(task_id='END', dag=dag)

start >> task_execute_sql >> end