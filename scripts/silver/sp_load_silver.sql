/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze --> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver_tbs;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver_tbs AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';


		-- Loading silver.customer_info
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.customer_info';
		TRUNCATE TABLE silver.customer_info;
		PRINT '>> Inserting Data Into: silver.customer_info';
		INSERT INTO silver.customer_info (
			customer_id,    
			age,             
			gender,         
			loyalty_member,  
			join_date          
		)
		SELECT
			TRIM(customer_id), --removing unwanted spaces    
			age,             
			TRIM(gender),	--removing unwanted spaces         
			loyalty_member,  
			join_date          
			FROM bronze.customer_info


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.product_info
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.crm_prd_info';
		TRUNCATE TABLE silver.product_info;
		PRINT '>> Inserting Data Into: silver.product_info';
		INSERT INTO silver.product_info (
			 product_id,
		     product_name,
      		 brand,
      		 category,
      		 cocoa_percent,
      		 weight_g
		)
		SELECT
			 TRIM(product_id),	--removing unwanted spaces
		     TRIM(product_name), --removing unwanted spaces
      		 TRIM(brand), --removing unwanted spaces
      		 TRIM(category), --removing unwanted spaces
      		 cocoa_percent,
      		 weight_g
		FROM bronze.product_info;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.store_info
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.store_info';
		TRUNCATE TABLE silver.store_info;
		PRINT '>> Inserting Data Into: silver.store_info';
		INSERT INTO silver.store_info (
			store_id,
			store_name,
			city,
			country,
			store_type
		)
		SELECT 
			TRIM(store_id), --removing unwanted spaces
			TRIM(REPLACE(store_name,'Chocolate','')), --removing word 'Chocolate' and unwanted spaces
			TRIM(city), --removing unwanted spaces
			TRIM(country), --removing unwanted spaces
			TRIM(store_type) --removing unwanted spaces
		FROM bronze.store_info;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading silver.sales_detail
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: silver.sales_detail';
		TRUNCATE TABLE silver.sales_detail;
		PRINT '>> Inserting Data Into: silver.sales_detail';
		INSERT INTO silver.sales_detail (
			order_id,
			order_date,
			product_id,
			store_id,
			customer_id,
			quantity,
			unit_price,
			discount,
			revenue,
			cost,
			profit
		)
		SELECT
			TRIM(order_id), --removing unwanted spaces
			order_date,
			TRIM(product_id), --removing unwanted spaces
			TRIM(store_id), --removing unwanted spaces
			TRIM(customer_id), --removing unwanted spaces
			quantity,
			unit_price,
			discount,
			revenue,
			cost,
			profit
		FROM bronze.sales_detail
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='
		
	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END
