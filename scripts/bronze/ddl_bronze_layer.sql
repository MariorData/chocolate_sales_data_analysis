/*
===============================================================================
DDL Script: Creation Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'bronze' tables
===============================================================================
*/


IF OBJECT_ID('bronze.customer', 'U') IS NOT NULL
    DROP TABLE bronze.customer_info;
GO

CREATE TABLE bronze.customer_info (
    customer_id         NVARCHAR(50),  
    age                 INT,
    gender              NVARCHAR(50),
    loyalty_member      BIT,
    join_date           DATE    
);
GO

IF OBJECT_ID('bronze.product_info', 'U') IS NOT NULL
    DROP TABLE bronze.product_info;
GO

CREATE TABLE bronze.product_info (
	product_id              NVARCHAR(50),
	product_name            NVARCHAR(50),
	brand                   NVARCHAR(50),
	category                NVARCHAR(50),
	cocoa_percent           INT,
	weight_g                INT
);
GO

IF OBJECT_ID('bronze.store_info', 'U') IS NOT NULL
    DROP TABLE bronze.store_info;
GO

CREATE TABLE bronze.store_info (
	store_id                NVARCHAR(50),
	store_name              NVARCHAR(50),
	city                    NVARCHAR(50),
	country                 NVARCHAR(50),
	store_type              NVARCHAR(50)
);
GO

IF OBJECT_ID('bronze.sales_detail', 'U') IS NOT NULL
    DROP TABLE bronze.sales_detail;
GO

CREATE TABLE bronze.sales_detail (
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
	profit                  DECIMAL(11,3)
);
GO
