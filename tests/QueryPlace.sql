-- crm_cust_info
-- Bronze -> Silver
-- Checking for Duplicate or Null Primary Key

SELECT
cst_id,
COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Checking for Unwanted Spaces

SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);

SELECT cst_marital_status
FROM bronze.crm_cust_info
WHERE cst_marital_status != TRIM(cst_marital_status);

SELECT cst_gndr
FROM bronze.crm_cust_info
WHERE cst_gndr != TRIM(cst_gndr);


-- Checking for consistency of values in low cardinality columns

SELECT DISTINCT
cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT
cst_marital_status
FROM bronze.crm_cust_info;

-- crm_prd_info
-- Checking the valididty of the dates
SELECT *
FROM bronze.crm_prd_info
WHERE prd_start_dt < prd_end_dt

-- crm_sales_details
-- Checking for invalid dates
SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 
OR LEN(sls_order_dt) != 8
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

-- crm_sales_details
-- Checking for invalid date orders
SELECT *
FROM bronze.crm_sales_details
WHERE sales_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt

-- Checking data consistency betweeen Sales, Quantity, and Price
-->> Sales = Quantity * Price
-->> Values must not be NULL, Zero, or Negative
SELECT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price 
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0


-- erp_cust_az12
-- Bronze -> Silver
-- Substrining the customer id
SELECT
cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE cid LIKE '%AW00011000%'

SELECT
cid,
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
	 ELSE cid
END AS cid,
bdate,
gen
FROM bronze.erp_cust_az12
WHERE CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING (cid, 4, LEN(cid))
	 ELSE cid
END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)

-- Identify Out-of-Range Dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data standardization and consistency
SELECT DISTINCT
gen,
CASE WHEN UPPER(TRIM(gen)) IN ('F', 'Female') THEN 'Female'
	 WHEN UPPER(TRIM(gen)) IN ('M', 'Male') THEN 'Male'
	 ELSE 'n/a'
END AS gen
FROM bronze.erp_cust_az12

-- Data standardization and consistency
-- erp_loc_a101
SELECT
REPLACE(cid, '-', '') cid,
CASE WHEN TRIM(cntry) = 'DE' THEN 'Germany'
	 WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
	 WHEN TRIM(cntry) = '' OR cntry = NULL THEN 'n/a'
	 ELSE TRIM(cntry)
END AS cntry
FROM bronze.erp_loc_a101;	

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry;

-- Checking for Unwanted spaces
-- erp_px_cat_g1v2
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) OR subcat != TRIM(subcat) OR maintenance != TRIM(maintenance);