/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively (Both Monthly and Annually).
    - Useful for growth analysis or identifying long-term trends.

Functions Used:
	- Window Functions: SUM() OVER(), AVG() OVER()
    - Window Frame: ROWS BETWEEN ...
===============================================================================
*/

-- ====================================================================
-- Part 1: Monthly Analysis (Calculate total sales per month & running total)
-- ====================================================================
SELECT
    order_month AS order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_month) AS running_total_sales,
    ROUND(
		AVG(avg_price) OVER (
        ORDER BY order_month
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
		), 2
    ) AS moving_average_price
FROM
(
    SELECT
        STR_TO_DATE(DATE_FORMAT(order_date, '%Y-%m-01'), '%Y-%m-%d') AS order_month,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM datawarehouse_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY STR_TO_DATE(DATE_FORMAT(order_date, '%Y-%m-01'), '%Y-%m-%d')
) t_month;

-- ====================================================================
-- Part 2: Annual Analysis (Calculate annual running total / Year-to-Date style)
-- ====================================================================
SELECT
    order_year AS order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_year) AS annual_running_total_sales
FROM
(
    SELECT 
        STR_TO_DATE(DATE_FORMAT(order_date, '%Y-01-01'), '%Y-%m-%d') AS order_year,
        SUM(sales_amount) AS total_sales
    FROM datawarehouse_gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY STR_TO_DATE(DATE_FORMAT(order_date, '%Y-01-01'), '%Y-%m-%d')
) t_year;
