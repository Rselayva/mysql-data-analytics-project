/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - Specifically analyzing category contribution to overall sales.

Functions Used:
    - SUM(), AVG(), SUM() OVER() for total calculations.
===============================================================================
*/
-- Find the category which contribute the most to overall sales
WITH category_sales AS (
    SELECT
        p.category,
        SUM(s.sales_amount) AS total_sales
    FROM datawarehouse_gold.fact_sales s
    LEFT JOIN datawarehouse_gold.dim_products p
        ON p.product_key = s.product_key
    GROUP BY p.category
)
SELECT
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,
    ROUND((total_sales / SUM(total_sales) OVER ()) * 100, 2) AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC;
