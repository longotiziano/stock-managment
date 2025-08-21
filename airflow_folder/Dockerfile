FROM apache/airflow:2.9.1
USER airflow
RUN pip install pandas

COPY ./app /opt/airflow/app
COPY ./sql /opt/airflow/sql
COPY ./airflow_folder/dags /opt/airflow/dags