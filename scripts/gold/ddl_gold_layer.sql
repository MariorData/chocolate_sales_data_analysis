/*
===============================================================================
DDL Script: Creation Gold Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'gold' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'gold' tables
===============================================================================
*/


IF OBJECT_ID('gold.dim_customer', 'U') IS NOT NULL
    DROP TABLE gold.dim_customer;
GO

CREATE TABLE gold.dim_customer (
    customer_key        INT,
    customer_code       NVARCHAR(50),  
    age                 INT,
    gender              NVARCHAR(50),
    loyalty_member      BIT,
    join_date           DATE
);
GO

IF OBJECT_ID('gold.dim_product', 'U') IS NOT NULL
    DROP TABLE gold.dim_product;
GO

CREATE TABLE gold.dim_product (
    product_key             INT,
    product_code            NVARCHAR(50),
    product_name            NVARCHAR(50),
    brand                   NVARCHAR(50),
    category                NVARCHAR(50),
    cocoa_percent           INT,
    weight_g                INT
);
GO

IF OBJECT_ID('gold.dim_store', 'U') IS NOT NULL
    DROP TABLE gold.dim_store;
GO

CREATE TABLE gold.dim_store (
    store_key               INT,
    store_code              NVARCHAR(50),
    store_name              NVARCHAR(50),
    city                    NVARCHAR(50),
    country                 NVARCHAR(50),
    store_type              NVARCHAR(50) 
);
GO

IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
    DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales (
    order_id                NVARCHAR(50),
    order_date              DATE,
    customer_key            INT,
    customer_code           NVARCHAR(50),
    product_key             INT,
    product_code            NVARCHAR(50),
    store_key               INT,
    store_code              NVARCHAR(50),
    quantity                DECIMAL(11,3),
    unit_price              DECIMAL(11,3),
    discount                DECIMAL(11,3),
    revenue                 DECIMAL(11,3),
    cost                    DECIMAL(11,3),
    profit                  DECIMAL(11,3)   
);
GO
