/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.

===============================================================================
*/

SELECT 
    DISTINCT category, brand, product_name
FROM gold.dim_product
ORDER BY category, brand, product_name


SELECT 
    DISTINCT country, city
FROM gold.dim_store

SELECT 
    DISTINCT store_type
FROM gold.dim_store

SELECT 
    distinct gender, age
FROM gold.dim_customer
ORDER BY gender, age
