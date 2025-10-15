# ETL Pipeline: E-commerce Data con Airflow, GCS, BigQuery y Dataproc

Pipeline ETL automatizado para procesar datos de e-commerce usando Apache Airflow en Astronomer, Google Cloud Storage, BigQuery y Dataproc Serverless.

## Descripción

Este proyecto implementa un pipeline de datos que:
1. Carga archivos JSON (productos y pedidos) desde Google Cloud Storage a BigQuery
2. Ejecuta un job de PySpark en Dataproc Serverless para transformar y enriquecer los datos
3. Genera una tabla final con pedidos enriquecidos incluyendo información de productos y métricas calculadas

## Arquitectura
```
GCS (productos.json, orders.json) 
    ↓
BigQuery (retail_data.products, retail_data.orders)
    ↓
Dataproc Serverless (PySpark - transformación y join)
    ↓
BigQuery (retail_data.enriched_orders)
```

## Tecnologías

- **Apache Airflow** (Astronomer)
- **Google Cloud Storage** (GCS)
- **Google BigQuery**
- **Google Dataproc Serverless**
- **PySpark**

## Estructura del Proyecto
```
my-project-astro-gcp/
├── dags/
│   └── ecomm_data_pipeline_airflow_dag.py    # DAG principal
├── scripts/
│   └── transform_join_ecommerce.py           # Script PySpark
├── Dockerfile
├── packages.txt
├── requirements.txt
└── README.md
```

## Configuración

### Prerequisitos

- Cuenta de Google Cloud Platform
- Astronomer Cloud account
- Astro CLI instalado
- Docker Desktop corriendo

### Variables de Airflow

Configura las siguientes variables en Airflow UI:

| Variable | Valor | Descripción |
|----------|-------|-------------|
| `gcpproject_id_new` | `tu-project-id` | ID del proyecto GCP |

### Conexiones de Airflow

Crea la siguiente conexión en Airflow UI:

- **Connection ID**: `gcp_conn_new`
- **Connection Type**: `Google Cloud`
- **Project ID**: Tu project ID de GCP
- **Keyfile JSON**: Service account key con permisos necesarios

### Recursos en GCP

**Buckets de Cloud Storage:**
- `astro-airflow-project_bucket` - Archivos fuente y scripts
- `bq-temp-gds-bucket` - Archivos temporales de BigQuery

**Estructura de archivos en GCS:**
```
gs://astro-airflow-project_bucket/
├── datasets/
│   ├── products/
│   │   └── products.json
│   └── orders/
│       └── orders.json
└── scripts/
    └── transform_join_ecommerce.py
```

**Dataset de BigQuery:**
- Dataset: `retail_data`
- Tablas creadas automáticamente:
  - `products`
  - `orders`
  - `enriched_orders`

## Esquema de Datos

### Tabla Final: `enriched_orders`

| Campo | Tipo | Descripción |
|-------|------|-------------|
| order_id | STRING | ID único del pedido |
| user_id | STRING | ID del usuario |
| product_id | STRING | ID del producto |
| name | STRING | Nombre del producto |
| category | STRING | Categoría del producto |
| price | FLOAT | Precio unitario |
| quantity | INTEGER | Cantidad ordenada |
| total_price | FLOAT | Precio total (price × quantity) |
| stock | BOOLEAN | Disponibilidad en stock |
| price_tier | STRING | Categoría de precio (Low/Medium/High) |
| order_dt | DATE | Fecha del pedido |

## Ejecución del Pipeline

### Deploy a Astronomer
```bash
# Autenticar
astro login

# Deploy
astro deploy
```

### Ejecutar el DAG

1. Accede a Airflow UI desde Astronomer
2. Encuentra el DAG: `gcs_to_bq_dataproc_ecommerce`
3. Activa el toggle si está pausado
4. Click en "Trigger DAG" para ejecutar manualmente

### Monitoreo

El DAG ejecuta las siguientes tareas en orden:

1. **load_products** - Carga productos a BigQuery
2. **load_orders** - Carga órdenes a BigQuery
3. **run_dataproc_transform_join** - Ejecuta transformación PySpark
4. **Dummy_Message_OP** - Mensaje de finalización

## Notas

- El DAG está configurado con `schedule=None` (ejecución manual)
- `catchup=False` - No ejecuta runs históricos
- Dataproc Serverless elimina el cluster automáticamente después de la ejecución 