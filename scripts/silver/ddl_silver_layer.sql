/*
===============================================================================
DDL Script: Creation Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' tables
===============================================================================
*/


IF OBJECT_ID('silver.customer_info', 'U') IS NOT NULL
    DROP TABLE silver.customer_info;
GO

CREATE TABLE silver.customer_info (
    customer_id         NVARCHAR(50),  
    age                 INT,
    gender              NVARCHAR(50),
    loyalty_member      BIT,
    join_date           DATE, 
    dwh_creation_date   DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.product_info', 'U') IS NOT NULL
    DROP TABLE silver.product_info;
GO

CREATE TABLE silver.product_info (
    product_id              NVARCHAR(50),
    product_name            NVARCHAR(50),
    brand                   NVARCHAR(50),
    category                NVARCHAR(50),
    cocoa_percent           INT,
    weight_g                INT,
    dwh_creation_date   DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.store_info', 'U') IS NOT NULL
    DROP TABLE silver.store_info;
GO

CREATE TABLE silver.store_info (
    store_id                NVARCHAR(50),
    store_name              NVARCHAR(50),
    city                    NVARCHAR(50),
    country                 NVARCHAR(50),
    store_type              NVARCHAR(50),
    dwh_creation_date   DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.sales_detail', 'U') IS NOT NULL
    DROP TABLE silver.sales_detail;
GO

CREATE TABLE silver.sales_detail (
    order_id                NVARCHAR(50),
    order_date              DATE,
    product_id              NVARCHAR(50),
    store_id                NVARCHAR(50),
    customer_id             NVARCHAR(50),
    quantity                DECIMAL(11,3),
    unit_price              DECIMAL(11,3),
    discount                DECIMAL(11,3),
    revenue                 DECIMAL(11,3),
    cost                    DECIMAL(11,3),
    profit                  DECIMAL(11,3),
    dwh_creation_date   DATETIME2 DEFAULT GETDATE()
);
GO
