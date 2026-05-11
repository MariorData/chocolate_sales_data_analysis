/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality.
    - To measure growth or decline over specific periods.

SQL Functions Used:
    - Date Functions: DATEPART(), DATETRUNC(), FORMAT()
    - Aggregate Functions: SUM(), COUNT()
    - Window Functions: LAG
===============================================================================
*/

-- Analyse sales performance over time
-- Quick Date Functions
SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    SUM(revenue) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date);

-- DATETRUNC()
SELECT
    DATETRUNC(month, order_date) AS order_date,
    SUM(revenue) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date);

-- FORMAT
SELECT
    FORMAT(order_date, 'yyyy-MMM') AS order_date,
    SUM(revenue) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');

-- YEARMONTH TRICK
SELECT
    YEAR(order_date)*100+MONTH(order_date) AS order_date,
    SUM(revenue) AS total_sales,
    SUM(revenue)-LAG(SUM(revenue), 1, 0) OVER (ORDER BY YEAR(order_date)*100+MONTH(order_date)) AS Revenue_Change_mom,
    CASE WHEN LAG(SUM(revenue), 1, 0) OVER (ORDER BY YEAR(order_date)*100+MONTH(order_date))=0 THEN 0
    ELSE ROUND((SUM(revenue)/LAG(SUM(revenue), 1, 0) OVER (ORDER BY YEAR(order_date)*100+MONTH(order_date))-1)*100,2)
    END AS Revenue_Change_mom_pct,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)*100+MONTH(order_date)
ORDER BY YEAR(order_date)*100+MONTH(order_date);
