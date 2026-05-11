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

--  Find the average selling price

SELECT
AVG(unit_price) AS avg_gross_price,
SUM(revenue)/SUM(quantity) AS avg_net_price
FROM gold.fact_sales

-- Find the Total number of Orders
SELECT
COUNT(order_id) AS total_orders
FROM gold.fact_sales
SELECT
COUNT(DISTINCT order_id) AS total_orders
FROM gold.fact_sales

-- Find the total number of products
SELECT
COUNT(DISTINCT product_code)
FROM gold.dim_product

-- Find the total number of products sold
SELECT
COUNT(DISTINCT product_code)
FROM gold.fact_sales

-- Find the total number of customers
SELECT
COUNT(DISTINCT customer_code)
FROM gold.dim_customer

-- Find the total number of customers that has placed an order
SELECT
COUNT(DISTINCT customer_code)
FROM gold.fact_sales

-- Report with all key business metrics

SELECT 'Total Sales' AS measure_name, SUM(revenue) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Average Net Price', SUM(revenue)/SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'Total Orders', COUNT(DISTINCT order_id) FROM gold.fact_sales
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_code) FROM gold.dim_product
UNION ALL
SELECT 'Total Customers', COUNT(customer_code) FROM gold.dim_customer;
