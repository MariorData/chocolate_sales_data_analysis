/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics for quick business insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/

-- Find total sales
SELECT
SUM(revenue) AS total_revenue
FROM gold.fact_sales

-- Find total quantity sold
SELECT
SUM(quantity) AS total_quantity
FROM gold.fact_sales

-- Find total kg sold
WITH kg_cal AS (
    SELECT
    f.quantity,
    p.weight_g,
    f.quantity * ISNULL(p.weight_g,(SELECT AVG(weight_g) FROM gold.dim_product))/1000 AS kg
    --if weight in grams for some item is null, then we assume the conversion is the average weight
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_product p
    ON        f.product_key = p.product_key
    )
SELECT
SUM(kg) AS total_kg
FROM kg_cal
