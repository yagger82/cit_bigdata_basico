from airflow import DAG
from airflow.models import Variable
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import PythonOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.providers.postgres.hooks.postgres import PostgresHook
from airflow.utils.dates import days_ago

import pandas as pd

# Definir los argumentos por defecto del DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(0),
    'retries': 0,
}

# Definir el DAG
with DAG(
    dag_id='CSV_TO_POSTGRES_V1',
    description='DAG para cargar un CSV a PostgreSQL usando el operador PostgresHook.',
    default_args=default_args,
    schedule_interval=None,  # DAG no programado automáticamente
    template_searchpath=Variable.get("dags_folder") + 'samples/sql',
    catchup=False,
    tags=['csv', 'postgresql', 'rjimenez']
) as dag:

    def read_csv_and_insert_into_postgres(**kwargs):
        # Leer el archivo CSV
        csv_file_path = '/home/richard/analytics/dataset/input/sample.csv'
        df = pd.read_csv(csv_file_path)

        # Conectar a PostgreSQL usando la conexión configurada en Airflow
        pg_hook = PostgresHook(postgres_conn_id='postgres_default')  # Cambia a tu ID de conexión
        conn = pg_hook.get_conn()
        cursor = conn.cursor()

        # Insertar los datos en la tabla
        for index, row in df.iterrows():
            cursor.execute(
                """
                INSERT INTO sample.test_persona (nombre, apellido, sexo)
                VALUES (%s, %s, %s)
                """,
                (row['nombre'], row['apellido'], row['sexo'])
            )

        # Cerrar la conexión
        conn.commit()
        cursor.close()
        conn.close()

    start = EmptyOperator(task_id='START', dag=dag)

    # Tarea para crear la tabla (si no existe)
    create_table = PostgresOperator(
        task_id='CREATE_TABLE',
        postgres_conn_id='postgres_default',  # Cambia a tu ID de conexión en Airflow
        sql="""
            DO $$
            BEGIN
                SET search_path TO sample;
                
                -- Paso 1 - Verificamos si la tabla existe
                IF EXISTS ( SELECT 1 FROM pg_tables WHERE schemaname = 'sample' AND tablename = 'test_persona' ) THEN
                    -- Si existe, la truncamos
                    TRUNCATE TABLE test_persona RESTART IDENTITY;
                ELSE
                    -- Si no existe, la creamos
                    CREATE TABLE IF NOT EXISTS test_persona (
                        id SERIAL PRIMARY KEY,
                        nombre VARCHAR(32),
                        apellido VARCHAR(32),
                        sexo CHAR(1)
                    );
                END IF;
            END $$   
        """
    )

    # Tarea para leer el CSV y cargar en PostgreSQL
    load_csv_to_postgres = PythonOperator(
        task_id='LOAD_CSV_TO_POSTGRES',
        python_callable=read_csv_and_insert_into_postgres
    )

    end = EmptyOperator(task_id='END', dag=dag)

# Definir la secuencia de tareas
start >> create_table >> load_csv_to_postgres >> end
