import pytz
from airflow import DAG
# from airflow.operators.bash import BashOperator
from airflow.operators.python import PythonOperator
from datetime import timedelta, datetime
from airflow.utils.dates import days_ago
from airflow.providers.common.sql.operators.sql import SQLExecuteQueryOperator
from airflow.operators.empty import EmptyOperator

TZ = pytz.timezone('America/Asuncion')
TODAY = datetime.now(TZ).strftime('%Y-%m-%d')

# cargar argumentos
ARGS = {
    'owner': 'airflow',
    'start_date': days_ago(1),
    'retries': 1,
    'retry_delay': timedelta(minutes=0.5)
}

dag = DAG(
    dag_id='ejemplo_basico_dag',
    default_args=ARGS,
    schedule_interval='@daily',
    template_searchpath="/home/victor/airflow/SQL",  ##configuracion para que encuentre los archivos sql
    catchup=False,
)
##definir funciones en python
# def crearsqltarifas():
# df=pd.read_csv(URL_ORIGEN_ARCHIVO+'tarifas.tab',sep=SEPARADOR,header=None)
# df=df.fillna(method='ffill')
#  print(df)

#  with open(OUTPUT_SQL+'SQL_TARIFAS.sql','w')as f:
#       for index, row in df.iterrows():
#
#          values=f"('{row[0]}','{row[1]}','{row[2]}','{row[3]}','{row[4]}','{row[5]}','{row[6]}','{row[7]}')"
#          insert=f"insert into TARIFAS values {values};\n"
#          f.write(insert)
##Definir operadores o task para los dags
with dag:
    iniciar = EmptyOperator(task_id="Inicio",
                            task_display_name='Inicio del proceso'
                            )
    proceso = EmptyOperator(task_id="proceso",
                            task_display_name='procesando'
                            )
    fin = EmptyOperator(task_id="fin",
                        task_display_name='Proceso terminado'
                        )
    ##operadores para pyton y sql
# creasqlinstarifa=PythonOperator(
# task_id='TABTARIFAS',
# task_display_name='Crear Archivo Insert TARIFAS',
# python_callable=crearsqltarifas
# )
# insertadatostarifas=SQLExecuteQueryOperator(
#   task_id='INSTARIFAS',
#   task_display_name='Insertar datos del archivo TARIFAS',
#  conn_id='localhostprueba',
#  sql="SQL_TARIFAS.sql"
# )
##orden de ejecucion
iniciar >> proceso >> fin
