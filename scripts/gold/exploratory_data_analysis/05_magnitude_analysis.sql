/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To quantify data and group results by specific dimensions.
    - For understanding data distribution across categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/

-- Find total stores by countries
SELECT
    country,
    COUNT(store_code) AS total_stores
FROM gold.dim_store
GROUP BY country
ORDER BY total_stores DESC;

-- Find total customers by gender
SELECT
    gender,
    COUNT(customer_code) AS total_customers
FROM gold.dim_customer
GROUP BY gender
ORDER BY total_customers DESC;

-- Find total products by category
SELECT
    category,
    COUNT(product_code) AS total_products
FROM gold.dim_product
GROUP BY category
ORDER BY total_products DESC;

-- What is the average net price in each category?
SELECT
    p.category,
    SUM(revenue)/SUM(quantity) AS avg_netprice
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key=p.product_key
GROUP BY category
ORDER BY avg_netprice DESC;

-- What is the total revenue generated for each category?
SELECT
    p.category,
    SUM(revenue) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key=p.product_key
GROUP BY category
ORDER BY total_revenue DESC;

-- What is the average net price in each brand?
SELECT
    p.brand,
    SUM(revenue)/SUM(quantity) AS avg_netprice
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key=p.product_key
GROUP BY brand
ORDER BY avg_netprice DESC;

-- What is the total revenue generated for each brand?
SELECT
    p.brand,
    SUM(revenue) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_product p
ON f.product_key=p.product_key
GROUP BY brand
ORDER BY total_revenue DESC;



-- What is the distribution of sold quantities across countries?
SELECT
    s.country,
    SUM(f.quantity) AS total_sold_qty
FROM gold.fact_sales f
LEFT JOIN gold.dim_store s
    ON s.store_key = f.store_key
GROUP BY s.country
ORDER BY total_sold_qty DESC;

-- What is the average net price among channels/brands?
SELECT
    s.store_type,
    p.brand,
    SUM(f.revenue)/SUM(f.quantity) AS avg_net_price
FROM gold.fact_sales f
LEFT JOIN gold.dim_store s
    ON s.store_key = f.store_key
LEFT JOIN gold.dim_product p
    ON p.product_key = f.product_key
GROUP BY s.store_type,p.brand 
ORDER BY avg_net_price DESC;
