-- 1) Crear dataset
CREATE SCHEMA IF NOT EXISTS `airflow-etl-project-475112.retail_data`;

-- 1) Tabla productos 
CREATE TABLE IF NOT EXISTS `airflow-etl-project-475112.retail_data.products` (
  product_id INT64,
  name       STRING,
  category   STRING,
  price      FLOAT64,
  in_stock      INT64
);

-- 2) Tabla orders
CREATE TABLE IF NOT EXISTS `airflow-etl-project-475112.retail_data.orders` (
  order_id   INT64,
  user_id    INT64,
  product_id INT64,
  quantity   INT64,
  order_date   TIMESTAMP
);

-- 3) Tabla enriched_orders
CREATE TABLE IF NOT EXISTS `airflow-etl-project-475112.retail_data.enriched_orders` (
  order_id       INT64,
  user_id        INT64,
  product_id     INT64,
  name           STRING,
  category       STRING,
  price          FLOAT64,
  quantity       INT64,
  total_price    FLOAT64,
  stock          INT64,
  price_tier     STRING,
  order_dt       DATE
);