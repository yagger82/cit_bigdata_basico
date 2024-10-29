#Importa los módulos necesarios
from airflow import DAG
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
    dag_id="cargar_datos_en_postgres",
    default_args=default_args,
    description='Cargar datos en PostgreSQL usando Airflow',
    schedule_interval=None,  # Frecuencia de ejecución del DAG (@once)
    template_searchpath='/home/richard/analytics/airflow_project/dags/sample/sql',
    #template_searchpath=['/path/to/airflow_project/dags/sample/sql'] ,
    catchup=False,
    tags=['sample']
)

# Agrega el operador PostgresOperator
with dag:
    start = EmptyOperator(task_id='start', dag=dag)

    execute_sql_task = PostgresOperator(
        task_id='ejecutar_sql',
        sql='cargar_postgres.sql'# Ruta al archivo SQL
        #conn_id='postgres_defaul',# Nombre de la conexión configurada
        #dag=dag
    )

    end = EmptyOperator(task_id='end', dag=dag)

start >> execute_sql_task >> end