/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank dimensions (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 5 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 5
    p.brand, p.product_name,
    SUM(f.revenue) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.brand, p.product_name
ORDER BY total_revenue DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM (
    SELECT
        p.brand,p.product_name,
        SUM(f.revenue) AS total_revenue,
        RANK() OVER (ORDER BY SUM(f.revenue) DESC) AS rank_products
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
        ON p.product_key = f.product_key
    GROUP BY p.brand,p.product_name
) AS ranked_products
WHERE rank_products <= 5;

-- What are the 5 worst-performing products in terms of sales?
SELECT TOP 5
    p.brand, p.product_name,
    SUM(f.revenue) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY p.brand, p.product_name
ORDER BY total_revenue;

-- Find the top 10 stores who have generated the highest revenue
SELECT TOP 10
    s.store_key,
    s.store_name,
    SUM(f.revenue) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_store s
    ON s.store_key = f.store_key
GROUP BY 
    s.store_key,
    s.store_name
ORDER BY total_revenue DESC;

-- The 3 customers with the fewest orders placed
SELECT TOP 3
    s.store_name,
    COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_store s
    ON s.store_key = f.store_key
GROUP BY 
    s.store_name
ORDER BY total_orders;
