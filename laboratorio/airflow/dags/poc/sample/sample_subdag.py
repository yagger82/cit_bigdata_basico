from airflow import DAG
from airflow.operators.subdag import SubDagOperator
from airflow.operators.empty import EmptyOperator
from airflow.providers.postgres.operators.postgres import PostgresOperator
from airflow.utils.dates import days_ago

# [START subdag]
def subdag(parent_dag_name, child_dag_name, args):

    subdag = DAG(
        dag_id=f'{parent_dag_name}.{child_dag_name}',
        default_args=args,
        schedule="@daily",
        tags=["sample"]
    )

    with subdag:

        task_1 = PostgresOperator(
            task_id='create_table',
            postgres_conn_id='your_postgres_conn_id',
            sql='''
                CREATE TABLE IF NOT EXISTS your_table (
                    id SERIAL PRIMARY KEY,
                    name VARCHAR(50),
                    age INT
                );
            '''
        )

        task_2 = PostgresOperator(
            task_id='insert_data',
            postgres_conn_id='your_postgres_conn_id',
            sql='''
                INSERT INTO your_table (name, age) VALUES ('John Doe', 30);
            '''
        )

        task_1 >> task_2

    return subdag
# [END subdag]

# [START sample_subdag]
# Define los argumentos del DAG
default_args = {
    'owner': 'airflow',
    'start_date': days_ago(0),
    'retries': 0,
}

# Crea el DAG padre
parent_dag = DAG(
    dag_id='parent_dag',
    default_args=default_args,
    description='Un ejemplo sencillo de SubDAG con PostgresOperators',
    schedule=None,
    start_date=days_ago(0),
)

with parent_dag:

    start = EmptyOperator(task_id='START', dag=parent_dag)

    # Crea el SubDAG
    subdag_task = SubDagOperator(
        task_id='SUBDAG_TASK',
        subdag=subdag('PARENT_DAG', 'SUBDAG_TASK', default_args),
        dag=parent_dag,
    )

    end = EmptyOperator(task_id='END', dag=parent_dag)

start >> subdag_task >> end
# [END sample_subdag]