
import datetime

from airflow import DAG
from airflow.models.baseoperator import chain
from airflow.operators.empty import EmptyOperator

with DAG(
        dag_id="example_dag_with_id",
        dag_display_name= "example_dag_with",
        description='Ejemplo que demuestra el uso de with para declarar un DAG.',
        start_date=datetime.datetime(2024, 12, 1),
        schedule="@daily",
        catchup=False,
        tags= ['example']
):
    task1 = EmptyOperator(task_id="task1")

    task2 = EmptyOperator(task_id="task2")

    task3 = EmptyOperator(task_id="task3")

    task4 = EmptyOperator(task_id="task4")

# task1 >> [task2, task3]
# task3 << task4

# task1.set_downstream([task2, task3])
# task3.set_upstream(task4)

# cross_downstream([task1, task2], [task3, task4])

# task1 >> task2 >> task3 >> task4
chain(task1, task2, task3, task4)