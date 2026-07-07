/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the databases, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- =============================================================
-- 1. Inventory Check: List all tables and views across datawarehouse layers
-- =============================================================
SELECT 
    TABLE_SCHEMA AS database_name, 
    TABLE_NAME AS table_name, 
    TABLE_TYPE AS table_type
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA LIKE 'datawarehouse_%'
ORDER BY TABLE_TYPE, TABLE_SCHEMA;

-- =============================================================
-- 2. Schema Inspection: Generic template to inspect any table's columns
-- =============================================================
-- Instructions: Change the TABLE_NAME to inspect other assets
-- (e.g., 'dim_products', 'fact_sales')
SELECT
	TABLE_SCHEMA AS database_name,
    TABLE_NAME AS table_name,
    COLUMN_NAME AS column_name, 
    DATA_TYPE AS data_type, 
    IS_NULLABLE AS is_nullable, 
    CHARACTER_MAXIMUM_LENGTH AS max_length,
    ORDINAL_POSITION AS column_order
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA LIKE 'datawarehouse_%'
  AND TABLE_NAME = 'dim_customers' -- The target table
ORDER BY ORDINAL_POSITION;
