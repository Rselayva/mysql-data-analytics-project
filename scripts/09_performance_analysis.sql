/*
===============================================================================
Performance Analysis (Year-over-Year, Month-over-Month)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - Benchmarking current sales against both product historical average and prior year.
    - To track yearly growth trends using percentage metrics.

Functions Used:
    - LAG() OVER(), AVG() OVER(), MULTI-STAGE CTEs, NULLIF()
===============================================================================
*/

-- Step 1: Aggregate sales by Year and Product
WITH yearly_product_sales AS (
    SELECT
        YEAR(s.order_date) AS order_year,
        p.product_name,
        SUM(s.sales_amount) AS current_sales
    FROM datawarehouse_gold.fact_sales s
    LEFT JOIN datawarehouse_gold.dim_products p
        ON s.product_key = p.product_key
    WHERE s.order_date IS NOT NULL
    GROUP BY 
        YEAR(s.order_date),
        p.product_name
),

-- Step 2: Calculate Windows Metrics
metrics_calculations AS (
    SELECT
        order_year,
        product_name,
        current_sales,
        AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,
        LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales
    FROM yearly_product_sales
)

-- Step 3: Final Output with Clean Labeling and Percentage Growth Rates
SELECT
    order_year,
    product_name,
    current_sales,
    ROUND(avg_sales, 2) AS avg_sales,
    
    -- Comparisons against Average
    ROUND(current_sales - avg_sales, 2) AS diff_avg,
    CASE 
        WHEN current_sales > avg_sales THEN 'Above Avg'
        WHEN current_sales < avg_sales THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,
    
    -- Year-over-Year Analysis (Absolute & Percentage)
    ROUND(py_sales, 2) AS py_sales,
    ROUND(current_sales - py_sales, 2) AS diff_py,
    
    -- Safe YoY Growth Rate Calculation
    ROUND(((current_sales - py_sales) / NULLIF(py_sales, 0)) * 100, 2) AS yoy_growth_percent,
    
    CASE 
        WHEN current_sales > py_sales THEN 'Increase'
        WHEN current_sales < py_sales THEN 'Decrease'
        ELSE 'No Change'
    END AS py_change
FROM metrics_calculations
ORDER BY product_name, order_year;
