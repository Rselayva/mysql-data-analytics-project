/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors into a Gold Layer View.
    - Optimized using DE best practices: Pre-aggregating fact data before joining dimensions.

Highlights:
    1. Segments products into performance tiers (High-Performer, Mid-Range, Low-Performer).
    2. Aggregates product-level metrics: total orders, sales, quantity, unique customers, and lifespan.
    3. Calculates valuable KPIs: recency, average selling price, AOR, and avg monthly revenue.
===============================================================================
*/

DROP VIEW IF EXISTS datawarehouse_gold.report_products;

CREATE VIEW datawarehouse_gold.report_products AS

-- 1. Pre-aggregate the heavy fact table at the product_key level.
WITH sales_aggregation AS (
    SELECT
        product_key,
        MIN(order_date) AS first_sale_date,
        MAX(order_date) AS last_sale_date,
        COUNT(DISTINCT order_number) AS total_orders,
        COUNT(DISTINCT customer_key) AS total_customers,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        -- Calculate average selling price directly at line level safely
        ROUND(AVG(sales_amount / NULLIF(quantity, 0)), 2) AS avg_selling_price
    FROM datawarehouse_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY product_key
),

-- 2. Join the aggregated sales table with product dimensions to pull descriptive metadata.
product_metrics_base AS (
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        s.last_sale_date,
        COALESCE(s.total_orders, 0) AS total_orders,
        COALESCE(s.total_sales, 0) AS total_sales,
        COALESCE(s.total_quantity, 0) AS total_quantity,
        COALESCE(s.total_customers, 0) AS total_customers,
        COALESCE(s.avg_selling_price, 0) AS avg_selling_price,
        COALESCE(TIMESTAMPDIFF(MONTH, s.first_sale_date, CURRENT_DATE()), 0) AS lifespan_months
    FROM datawarehouse_gold.dim_products p
    LEFT JOIN sales_aggregation s
        ON p.product_key = s.product_key
)

-- 3. Final Query to calculate rankings, periods, and high-level business KPIs.
SELECT 
    product_key,
    product_name,
    category,
    subcategory,
    cost,
    last_sale_date,
    TIMESTAMPDIFF(MONTH, last_sale_date, CURRENT_DATE()) AS recency_in_months,
    
    -- Performance Segmentation based on revenue thresholds
    CASE
        WHEN total_sales > 50000 THEN 'High-Performer'
        WHEN total_sales >= 10000 THEN 'Mid-Range'
        ELSE 'Low-Performer'
    END AS product_segment,
    
    lifespan_months AS lifespan,
    total_orders,
    ROUND(total_sales, 2) AS total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,
    
    -- KPI 1: Average Order Revenue (AOR) with defensive division check
    ROUND(total_sales / NULLIF(total_orders, 0), 2) AS avg_order_revenue,

    -- KPI 2: Average Monthly Revenue with defensive division check
    ROUND(total_sales / NULLIF(lifespan_months, 0), 2) AS avg_monthly_revenue

FROM product_metrics_base;
