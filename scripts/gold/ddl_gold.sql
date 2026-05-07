/*
===============================================================================
DDL Script: Create Gold Views
===============================================================================
Script Purpose:
    This script creates views for the Gold layer in the data warehouse. 
    The Gold layer represents the final dimension and fact tables (Star Schema)

    Each view performs transformations and combines data from the Silver layer 
    to produce a clean, enriched, and business-ready dataset.

Usage:
    - These views can be queried directly for analytics and reporting.
===============================================================================
*/

-- =============================================================================
-- Create Dimension: gold.dim_customers
-- =============================================================================
IF OBJECT_ID('gold.vdim_customer', 'V') IS NOT NULL
    DROP VIEW gold.vdim_customer;

GO

CREATE VIEW gold.vdim_customer AS
SELECT
			ROW_NUMBER() OVER (ORDER BY customer_id, join_date) AS customer_key, --create surrogate key 
			customer_id AS customer_code,
			age,             
			gender,	      
			loyalty_member,  
			join_date          
FROM silver.customer_info;

GO

-- =============================================================================
-- Create Dimension: gold.dim_product
-- =============================================================================

IF OBJECT_ID('gold.vdim_product', 'V') IS NOT NULL
    DROP VIEW gold.vdim_product;

GO

CREATE VIEW gold.vdim_product AS
SELECT
			 ROW_NUMBER() OVER (ORDER BY product_id) AS product_key, -- create surrogate key
			 product_id AS product_code,	
		     product_name, 
      		 brand, 
      		 category, 
      		 cocoa_percent,
      		 weight_g
FROM silver.product_info;

GO

-- =============================================================================
-- Create Dimension: gold.dim_store
-- =============================================================================

IF OBJECT_ID('gold.vdim_store', 'V') IS NOT NULL
    DROP VIEW gold.vdim_store;

GO
CREATE VIEW gold.vdim_store AS
SELECT 
			ROW_NUMBER() OVER (ORDER BY store_id) AS store_key, -- create surrogate key
			store_id AS store_code,
			store_name, 
			city,
			country,
			store_type
FROM silver.store_info;

GO

-- =============================================================================
-- Create Fact Table: gold.fact_sales
-- =============================================================================

IF OBJECT_ID('gold.vfact_sales', 'V') IS NOT NULL
    DROP VIEW gold.vfact_sales;

GO
CREATE VIEW gold.vfact_sales AS
SELECT
			sls.order_id AS order_id,
			sls.order_date  AS order_date,
			c.customer_key  AS customer_key,
			sls.customer_id AS customer_code,
			p.product_key	AS product_key,
			sls.product_id	AS product_code,
			st.store_key	AS store_key,
			sls.store_id	AS store_code,
			sls.quantity	AS quantity,
			sls.unit_price	AS unit_price,
			sls.discount	AS discount,
			sls.revenue		AS revenue,
			sls.cost		AS cost,
			sls.profit		AS profit
FROM		silver.sales_detail sls
			
LEFT JOIN (SELECT
			ROW_NUMBER() OVER (ORDER BY customer_id, join_date) AS customer_key, 
			customer_id,
			age,             
			gender,	      
			loyalty_member,  
			join_date          
			FROM silver.customer_info
)c
ON		  sls.customer_id=c.customer_id
LEFT JOIN (SELECT
			ROW_NUMBER() OVER (ORDER BY product_id) AS product_key,
			product_id,	
			product_name, 
      		brand, 
      		category, 
      		cocoa_percent,
      		weight_g
			FROM silver.product_info
) p
ON		sls.product_id=p.product_id
LEFT JOIN (SELECT 
			ROW_NUMBER() OVER (ORDER BY store_id) AS store_key,
			store_id,
			store_name, 
			city,
			country,
			store_type
			FROM silver.store_info
) st
ON		sls.store_id=st.store_id;

GO
