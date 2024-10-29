
import datetime

from airflow import DAG
from airflow.models.baseoperator import chain
from airflow.operators.empty import EmptyOperator

# Opcion 1
# with DAG(
#         dag_id="example_dag_dynamic_id",
#         dag_display_name= "example_dag_dynamic",
#         description='Ejemplo que demuestra el uso de un DAG dynamic.',
#         start_date=datetime.datetime(2024, 12, 1),
#         schedule=None, #"@daily"
#         catchup=False,
#         tags= ['example']
# ):
#     chain(*[EmptyOperator(task_id='task' + str(i)) for i in range(1, 6)])

# Opcion 2
with DAG("loop_example", 'Ejemplo que demuestra el uso de un DAG dynamic.'):
    first = EmptyOperator(task_id="first")
    last = EmptyOperator(task_id="last")

    options = ["branch_a", "branch_b", "branch_c", "branch_d", "branch_z"]
    for option in options:
        t = EmptyOperator(task_id=option, task_display_name=option)
        first >> t >> last