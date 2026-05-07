/*
===============================================================================
Stored Procedure: Load Gold Layer (Silver --> Gold)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'gold' schema tables from the 'silver' schema.
	Actions Performed:
		- Truncates Gold tables.
		- Inserts transformed data, with surrogate keys generation, from Silver into Gold tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Gold.load_gold_tbs;
===============================================================================
*/

CREATE OR ALTER   PROCEDURE gold.load_gold_tbs AS
BEGIN
    DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME; 
    BEGIN TRY
        SET @batch_start_time = GETDATE();
        PRINT '================================================';
        PRINT 'Loading Gold Layer';
        PRINT '================================================';


		-- Loading table gold.dim_customer
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: gold.dim_customer';
		TRUNCATE TABLE gold.dim_customer;
		PRINT '>> Inserting Data Into: gold.dim_customer';
		INSERT INTO gold.dim_customer (
			customer_key, --surrogate key
			customer_code,    
			age,             
			gender,         
			loyalty_member,  
			join_date          
		)
		SELECT
			ROW_NUMBER() OVER (ORDER BY customer_id, join_date), --create surrogate key 
			customer_id,
			age,             
			gender,	      
			loyalty_member,  
			join_date          
			FROM silver.customer_info


		SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading gold.dim_product
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: gold.dim_product';
		TRUNCATE TABLE gold.dim_product;
		PRINT '>> Inserting Data Into: gold.dim_product';
		INSERT INTO gold.dim_product (
			 product_key, --surrogate key
			 product_code,
		     product_name,
      		 brand,
      		 category,
      		 cocoa_percent,
      		 weight_g
		)
		SELECT
			 ROW_NUMBER() OVER (ORDER BY product_id), -- create surrogate key
			 product_id,	
		     product_name, 
      		 brand, 
      		 category, 
      		 cocoa_percent,
      		 weight_g
		FROM silver.product_info;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading gold.dim_store
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: gold.dim_store';
		TRUNCATE TABLE gold.dim_store;
		PRINT '>> Inserting Data Into: gold.dim_store';
		INSERT INTO gold.dim_store (
			store_key,-- surrogate key
			store_code,
			store_name,
			city,
			country,
			store_type
		)
		SELECT 
			ROW_NUMBER() OVER (ORDER BY store_id), -- create surrogate key
			store_id,
			store_name, 
			city,
			country,
			store_type
		FROM silver.store_info;
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

        -- Loading gold.fact_sales
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: gold.fact_sales';
		TRUNCATE TABLE gold.fact_sales;
		PRINT '>> Inserting Data Into: gold.fact_sales';
		INSERT INTO gold.fact_sales (
			order_id,
			order_date,
			customer_key,
			customer_code,
			product_key,
			product_code,
			store_key,
			store_code,		
			quantity,
			unit_price,
			discount,
			revenue,
			cost,
			profit
		)
		SELECT
			sls.order_id,
			sls.order_date,
			c.customer_key,
			sls.customer_id,
			p.product_key,
			sls.product_id,
			st.store_key,
			sls.store_id,
			sls.quantity,
			sls.unit_price,
			sls.discount,
			sls.revenue,
			sls.cost,
			sls.profit
			FROM
			silver.sales_detail sls
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
	    SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading gold.dim_date
        SET @start_time = GETDATE();
		PRINT '>> Truncating Table: gold.dim_date';
		TRUNCATE TABLE gold.dim_date;
		PRINT '>> Inserting Data Into: gold.dim_date';
			DECLARE @StartDated DATE = DATEADD(yy, DATEDIFF(yy, 0, (SELECT MIN(order_date) FROM silver.sales_detail)), 0);
			DECLARE @EndDated DATE = DATEADD(yy, DATEDIFF(yy, 0, (SELECT Max(order_date) FROM silver.sales_detail)) + 1, -1);
			WITH DateSequence AS (
			SELECT @StartDated AS CurrentDate
			UNION ALL
			SELECT DATEADD(DAY, 1, CurrentDate)
			FROM DateSequence
			WHERE CurrentDate < @EndDated
			)
			INSERT INTO gold.dim_date( 
			FullDate, 
			DayOfMonth, 
			DayName, 
			DayOfWeek, 
			WeekOfYear, 
			Month, 
			MonthName, 
			Quarter, 
			Year, 
			IsWeekend
			)
			SELECT
			CurrentDate AS FullDate,
			DAY(CurrentDate) AS DayOfMonth,
			DATENAME(WEEKDAY, CurrentDate) AS DayName,
			DATEPART(WEEKDAY, CurrentDate) AS DayOfWeek,
			DATEPART(WEEK, CurrentDate) AS WeekOfYear,
			MONTH(CurrentDate) AS Month,
			DATENAME(MONTH, CurrentDate) AS MonthName,
			DATEPART(QUARTER, CurrentDate) AS Quarter,
			YEAR(CurrentDate) AS Year,
			CASE WHEN DATEPART(WEEKDAY, CurrentDate) IN (1, 7) THEN 1 ELSE 0 END AS IsWeekend
			FROM DateSequence
			OPTION (MAXRECURSION 0);
        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Gold Layer is Completed';
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
