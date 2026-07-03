/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the unique categorical values within dimension tables.
    
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/

-- =============================================================
-- 1. Customer Geography: Retrieve a list of unique countries
-- =============================================================
SELECT DISTINCT 
    country 
FROM datawarehouse_gold.dim_customers
ORDER BY country;

-- =============================================================
-- 2. Product Catalog: Retrieve the full unique hierarchy of products
-- =============================================================
SELECT DISTINCT 
    category, 
    subcategory, 
    product_name 
FROM datawarehouse_gold.dim_products
ORDER BY category, subcategory, product_name;
