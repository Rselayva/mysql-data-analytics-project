/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

Functions Used:
    - YEAR(), MONTH(), DATE_FORMAT()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- ====================================================================
-- Approach 1: Grouping by Year and Month as Separate Numeric Columns
-- ====================================================================
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM datawarehouse_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- ====================================================================
-- Approach 2: Truncating Date to the First Day of the Month
-- ====================================================================
SELECT
    STR_TO_DATE(DATE_FORMAT(order_date, '%Y-%m-01'), '%Y-%m-%d') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM datawarehouse_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY STR_TO_DATE(DATE_FORMAT(order_date, '%Y-%m-01'), '%Y-%m-%d')
ORDER BY order_date;

-- ====================================================================
-- Approach 3: Formatting Date to a Readable String (e.g., '2026-Jul')
-- ====================================================================
SELECT
    DATE_FORMAT(order_date, '%Y-%b') AS order_date,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM datawarehouse_gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_FORMAT(order_date, '%Y-%b')
ORDER BY MIN(order_date);
