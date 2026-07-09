/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Segments customers into custom Age Groups and Value Segments (VIP, Regular, New).
    2. Computes core metrics: Total Orders, Sales, Quantities, Products, and Lifespan.
    3. Calculates critical KPIs: Recency, Average Order Value (AOV), and Avg Monthly Spend.
===============================================================================
*/

DROP VIEW IF EXISTS datawarehouse_gold.report_customers;

CREATE VIEW datawarehouse_gold.report_customers AS

-- 1. Pre-aggregate the heavy fact table at the customer_key level.
WITH sales_aggregation AS (
    SELECT
        customer_key,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM datawarehouse_gold.fact_sales
    WHERE customer_key IS NOT NULL
    GROUP BY customer_key
),

-- 2. Join the aggregated sales with the customer dimensions and compute base demographics.
customer_metrics_base AS (
    SELECT
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        TIMESTAMPDIFF(YEAR, c.birthdate, CURRENT_DATE()) AS age,
        COALESCE(s.total_orders, 0) AS total_orders,
        COALESCE(s.total_sales, 0) AS total_sales,
        COALESCE(s.total_quantity, 0) AS total_quantity,
        COALESCE(s.total_products, 0) AS total_products,
        s.last_order_date,
        COALESCE(TIMESTAMPDIFF(MONTH, s.first_order_date, CURRENT_DATE()), 0) AS lifespan_months
    FROM datawarehouse_gold.dim_customers c
    LEFT JOIN sales_aggregation s
        ON c.customer_key = s.customer_key
)

-- 3. Final Selection, Segmentation, and advanced KPI derivations.
SELECT
    customer_key,
    customer_number,
    customer_name,
    age,
    -- Demographics Segmentation
    CASE 
         WHEN age < 20 THEN 'Under 20'
         WHEN age BETWEEN 20 AND 29 THEN '20-29'
         WHEN age BETWEEN 30 AND 39 THEN '30-39'
         WHEN age BETWEEN 40 AND 49 THEN '40-49'
         WHEN age BETWEEN 50 AND 59 THEN '50-59'
         WHEN age BETWEEN 60 AND 69 THEN '60-69'
         ELSE '70 and above'
    END AS age_group,
    
    -- Customer Value Segmentation
    CASE 
        WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    last_order_date,
    TIMESTAMPDIFF(MONTH, last_order_date, CURRENT_DATE()) AS recency,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    total_quantity,
    total_products,
    lifespan_months AS lifespan,
    
    -- KPI 1: Average Order Value (AOV) with defensive division check
    ROUND(total_sales / NULLIF(total_orders, 0), 2) AS avg_order_value,
    
    -- KPI 2: Average Monthly Spend with defensive division check
    ROUND(total_sales / NULLIF(lifespan_months, 0), 2) AS avg_monthly_spend

FROM customer_metrics_base;
