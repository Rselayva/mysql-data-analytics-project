/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data and customer demographics.

Functions Used:
    - MIN(), MAX(), TIMESTAMPDIFF(), CURRENT_DATE()
===============================================================================
*/

-- =============================================================
-- 1. Sales Horizon: Determine the first/last order date and duration
-- =============================================================
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    TIMESTAMPDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM datawarehouse_gold.fact_sales;

-- ====================================================================
-- 2. Customer Demographics: Find the youngest and oldest customer based on birthdate
-- ====================================================================
SELECT
    MIN(birthdate) AS oldest_birthdate,
    TIMESTAMPDIFF(YEAR, MIN(birthdate), CURRENT_DATE()) AS oldest_age,
    MAX(birthdate) AS youngest_birthdate,
    TIMESTAMPDIFF(YEAR, MAX(birthdate), CURRENT_DATE()) AS youngest_age
FROM datawarehouse_gold.dim_customers;
