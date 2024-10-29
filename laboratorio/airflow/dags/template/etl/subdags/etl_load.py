from airflow import DAG
from airflow.operators.empty import EmptyOperator

def subdag_etl_load(parent_dag_name, child_dag_name, args):

    dag_subdag = DAG(
        dag_id=f'{parent_dag_name}.{child_dag_name}',
        default_args=args,
        schedule_interval=None,
    )

    with dag_subdag:
        start = EmptyOperator(task_id='start', dag=dag_subdag)

        load_data = EmptyOperator(task_id='load_data', dag=dag_subdag)

        end = EmptyOperator(task_id='end', dag=dag_subdag)

        start >> load_data >> end

    return dag_subdag
