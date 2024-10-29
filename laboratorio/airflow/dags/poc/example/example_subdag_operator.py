
"""Ejemplo DAG que demuestra el uso de SubDagOperator."""

from __future__ import annotations

# [START example_subdag_operator]
import datetime

import example.subdags.subdag as sd
from airflow.models.dag import DAG
from airflow.operators.empty import EmptyOperator
from airflow.operators.subdag import SubDagOperator

DAG_NAME = "example_subdag_operator"

with DAG(
    dag_id=DAG_NAME,
    default_args={"retries": 2},
    start_date=datetime.datetime(2024, 12, 1),
    schedule="@once",
    tags=["example"],
) as dag:
    start = EmptyOperator(
        task_id="start",
    )

    section_1 = SubDagOperator(
        task_id="section-1",
        subdag=sd.subdag_taks(DAG_NAME, "section-1", dag.default_args),
    )

    some_other_task = EmptyOperator(
        task_id="some-other-task",
    )

    section_2 = SubDagOperator(
        task_id="section-2",
        subdag=sd.subdag_taks(DAG_NAME, "section-2", dag.default_args),
    )

    end = EmptyOperator(
        task_id="end",
    )

    start >> section_1 >> some_other_task >> section_2 >> end
# [END example_subdag_operator]
