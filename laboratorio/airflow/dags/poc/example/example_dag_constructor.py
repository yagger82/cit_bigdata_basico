
import datetime

from airflow import DAG
from airflow.operators.empty import EmptyOperator

my_dag = DAG(
    dag_id="example_dag_constructor_id",
    dag_display_name= "example_dag_constructor",
    description='Ejemplo que demuestra el uso de un constructor para declarar un DAG.',
    start_date=datetime.datetime(2024, 12, 1),
    schedule="@daily",
    catchup=False,
    tags= ['example']
)

start = EmptyOperator(task_id="start", dag=my_dag)

taks_process = EmptyOperator(task_id="taks_process", dag=my_dag)

end = EmptyOperator(task_id="end", dag=my_dag)

start >> taks_process >> end