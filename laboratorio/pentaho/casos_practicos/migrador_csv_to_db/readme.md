<center><h1>UNIVERSIDAD NACIONAL DE ASUNCIÓN 
     FACULTAD POLITECNICA</h1></center>
<center><h3>PROYECTO CENTRO DE INNOVACIÓN TIC, FPUNA-KOICA</center>

<center><h4>Curso Básico de Introducción a Big Data</h4></center>

<center>Prof. Ing. Richard D. Jiménez-R.</center>

### **<u>Guía de Actividad:</u> Diseño de Base de Datos Relacional e Implementación de un Proceso ETL con Pentaho Data Integration (Kettle) y PostgreSQL.**



### Objetivo

El objetivo de esta actividad es que el estudiante analice el diseño de una base de datos relacional para almacenar un conjunto de datos específico, y luego analice la implementación de un proceso ETL con **Pentaho Data Integration** (Kettle) para cargar los datos desde un archivo *CSV* hacia la base de datos diseñada para **PostgreSQL**.



### Estructura de Directorios del Proyecto

A continuación, se detalla los directorios del proyecto con **Pentaho Data Integration** (Kettle):

**/src/**: Este es el directorio raíz que contiene todo el código fuente del proyecto. Dentro de él, puedes dividir las transformaciones y los trabajos en directorios específicos:

- **/transformaciones/**: Almacena las transformaciones en formato `.ktr`.
- **/trabajos/**: Contiene los archivos `.kjb` de los trabajos.
- **/sql/**: Para scripts SQL que puedas necesitar ejecutar como parte del proceso.
- **/config/**: Para almacenar los archivos de configuración, como archivos de propiedades (`.properties`), configuraciones de base de datos o variables de entorno.
- **/scripts/**: Scripts adicionales, como scripts de shell, Python, etc., que son parte del flujo.
- **README.md:** Manual de configuración e instalación del proyecto.

**/data/**: Aquí almacenas los datos de entrada y salida. Se recomienda dividirlo en subdirectorios:

- **/input/**: Archivos de datos de entrada.
- **/output/**: Resultados generados por las transformaciones.

**/logs/**: Carpeta dedicada para almacenar los logs de ejecución de las transformaciones y trabajos, permitiendo el seguimiento y análisis de errores.

**/docs/**: Para documentar el proyecto, instrucciones de uso, configuración y cualquier otra información importante relacionada.

**/libs/**: Aquí puedes poner librerías externas necesarias, como drivers JDBC u otras dependencias que necesita el proyecto.

**/modelo/:** Para almacenar los diagramas y archivos fuentes de los modelos conceptuales, lógicos y físico de la base de datos. 

**/queries/:** Para almacenar las consultas SQL varios.



### Tarea

1. Análisis de los datos:
   - Obtener el archivo CSV proporcionado.
   - Identificar las entidades y atributos presentes en los datos.
   - Establecer las relaciones entre las entidades.
   - Definir los tipos de datos apropiados para cada atributo.
2. Análisis del diseño del modelo relacional:
   - Analizar el diagrama entidad-relación (DER) que represente la estructura de la base de datos.
   - Verificar las normalizaciones de las tablas para eliminar redundancias y anomalías.
   - Identificar en el DER las las claves primarias y foráneas.
3. Análisis de la implementación de la base de datos:
   - Crear la base de datos utilizando PostgreSQL como sistema gestor de bases de datos relacional (SGBDR).
   - Crear las tablas de acuerdo al modelo de datos diseñado.
   - Crear los índices necesarios para mejorar el rendimiento de las consultas.
4. Análisis de la implementación del proceso ETL:
   - Analizar los archivos SQL, Transformation y Job del Proyecto ETL implementado en Pentaho Data Integration:
     - Extraer los datos del archivo CSV.
     - Transformar los datos para ajustarlos al esquema de la base de datos.
     - Cargar los datos en las tablas de la base de datos.
5. Elaborar una documentación para su entrega:
   - Elaborar un informe técnico que incluya:
     - Descripción del problema y los objetivos.
     - Análisis de los datos y diseño del modelo de datos.
     - Descripción del proceso ETL implementado.
     - Código fuente de los scripts utilizados.
     - Resultados de las pruebas realizadas.
     - Conclusiones y recomendaciones.



### Herramientas

- **SGBDR:** PostgreSQL.
- **Herramientas ETL:** Pentaho.
- **Diagramación:** Draw.io, SQL Power Architect.
- **Lenguajes de programación:** SQL, PL/PgSQL.



### Entorno de Trabajo

Instalación y configuración de herramientas en su entorno de trabajo local.

- ###### <u>Servidor de Base de Datos:</u> PostgreSQL (15.x en adelante)

`https://www.postgresql.org/download/`

`https://www.enterprisedb.com/downloads/postgres-postgresql-downloads`



- ###### <u>Cliente de Base de Datos:</u> DBeaver Community Edition

`https://dbeaver.io/download/`



- ###### <u>Modelado de Datos:</u> SQL Power Architect Community Edition (el más reciente)

`https://bestofbi.com/architect-download/`



- ###### <u>JDBC Driver en SQL Power Architect:</u> PostgreSQL JDBC Driver

`https://jdbc.postgresql.org/download/`



- ###### <u>Herramienta ETL:</u> Pentaho Data Integration (PDI) v9.4.

`https://www.hitachivantara.com/en-us/products/pentaho-plus-platform/data-integration-analytics/pentaho-community-edition.html`



- ###### Navicat Data Modeler Express (Opcional)

`https://www.navicat.com/es/products/navicat-data-modeler`



### DataSet

Datos abiertos publicados por la SFP, correspondiente a las nóminas de funcionarios públicos por periodo.

##5-Descarga Nómina de Funcionarios del Portal de la SFP- Dataset
##Para fines prácticos usar la nómina de funcionarios del periodo julio-2023
https://datos.sfp.gov.py/data/funcionarios/download

##6-Instalar y Configurar: Pentaho Data Integration

------------------------------



### Criterios de Evaluación (30 puntos)

- Diseño del modelo de datos (10 puntos):
  - Correcta identificación de entidades y atributos.
  - Diseño adecuado de las relaciones.
  - Normalización correcta de las tablas.
  - Definición clara de claves primarias y foráneas.
- Implementación de la base de datos (10 puntos):
  - Creación correcta de las tablas y relaciones.
  - Creación de índices adecuados.
  - Optimización del rendimiento de la base de datos.
- Implementación del proceso ETL (5 puntos):
  - Extracción correcta de los datos del archivo CSV.
  - Transformación adecuada de los datos.
  - Carga exitosa de los datos en la base de datos.
- Documentación (5 puntos):
  - Claridad y concisión en la presentación de la información.
  - Completitud de la documentación.
  - Uso correcto de la terminología técnica.

- 

### Entrega

El estudiante deberá entregar un informe técnico en formato digital que incluya todos los elementos mencionados anteriormente.

### Consideraciones Adicionales

- Se recomienda que el estudiante investigue sobre las mejores prácticas en el diseño de bases de datos relacionales y en la implementación de procesos ETL.
- Es importante que el estudiante pruebe exhaustivamente la base de datos y el proceso ETL para garantizar su correcto funcionamiento.
- Se valorará la capacidad del estudiante para resolver problemas y adaptarse a cambios en los requisitos.
