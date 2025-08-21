# Sistema de gestión de inventario

Luego de trabajar como cajero unos meses en un restaurante, pude denotar la falta de eficacia y manualidad con respecto a la gestión del inventario de insumos, y no únicamente eso... Si no que al no tener un programa que indique las cantidades reales de consumo tanto
en la cocina como en la barra, se podían dar fáciles fugas de almacenamiento y stock de las cuales no era fácil darse cuenta, por lo que se me ocurrió esta solución. Un sistema que permite calcular insumos de manera automática y a su vez almacena dichos, permitiendo así
la visualización de ventas, productos y diversas métricas que considero que son de gran utilidad a la hora de tener un negocio y buscar sacarle el máximo rendimiento posible.

# Arquitectura

- El proyecto implementa un flujo de ingeniería de datos:
- Extracción: datos de ventas y productos.
- Transformación: cálculo de insumos consumidos por producto.
- Carga: almacenamiento en una base de datos relacional (PostgreSQL).
- Orquestación: tareas automatizadas con Apache Airflow.
- Visualización: dashboard de métricas (Power BI).
