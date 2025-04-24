
#!/bin/bash

#Dale permisos de ejecución usando el siguiente comando: chmod +x 
#Luego, puedes ejecutar el script simplemente con: ./start_airflow.sh
# sed -i -e 's/\r$//' start_airflow.sh

# Ir al directorio del proyecto
cd /home/richard/analytics/airflow_project/

# Activar Entorno Virtual
source venv/bin/activate

# Inicia el servidor web de Airflow
airflow webserver -D

# Inicia el scheduler de Airflow
airflow scheduler -D

# Inicia el trigger de Airflow
airflow triggerer -D

echo "Todos los servicios de Airflow han sido iniciados."