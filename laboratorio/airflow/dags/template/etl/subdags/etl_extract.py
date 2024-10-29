from airflow import DAG
from airflow.operators.empty import EmptyOperator
from datetime import datetime


def subdag_etl_extract(parent_dag_name, child_dag_name, args):

    dag_subdag = DAG(
        dag_id=f'{parent_dag_name}.{child_dag_name}',
        default_args=args,
        schedule_interval=None,
    )

    with dag_subdag:
        start = EmptyOperator(task_id='start', dag=dag_subdag)

        extract_data = EmptyOperator(task_id='extract_data', dag=dag_subdag)

        end = EmptyOperator(task_id='end', dag=dag_subdag)

        start >> extract_data >> end

    return dag_subdag
