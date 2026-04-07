-- Customer - Dimension
-- *Joining on the Left the 'silver.erp_cust_az12' and 'silver.erp_loc_a101' on 'silver.crm_cust_info'
SELECT
	ci.cst_id,
	ci.cst_key,
	ci.cst_firstname,
	ci.cst_lastname,
	ci.cst_marital_status,
	ci.cst_gndr,
	ci.cst_create_date,
	cb.bdate,
	cb.gen,
	cl.cntry
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON		  ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON		  ci.cst_key = cl.cid;


-- Showing cst_id that are duplicated and how many times they appear
SELECT cst_id, COUNT(*)
FROM(
	SELECT
		ci.cst_id,
		ci.cst_key,
		ci.cst_firstname,
		ci.cst_lastname,
		ci.cst_marital_status,
		ci.cst_gndr,
		ci.cst_create_date,
		cb.bdate,
		cb.gen,
		cl.cntry
	FROM silver.crm_cust_info ci
	LEFT JOIN silver.erp_cust_az12 cb
	ON		  ci.cst_key = cb.cid
	LEFT JOIN silver.erp_loc_a101 cl
	ON		  ci.cst_key = cl.cid
)t
GROUP BY cst_id
HAVING COUNT(*) > 1

-- checking for unique combination of the two similar columns, sorting and matching them
SELECT DISTINCT
	ci.cst_gndr,
	cb.gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON		  ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON		  ci.cst_key = cl.cid
ORDER BY 1, 2

-- If ci.cst_gndr is not 'n/a', use it. Otherwise, try to use cb.gen. If cb.gen is NULL, then use 'n/a'.
SELECT DISTINCT
	ci.cst_gndr,
	cb.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		 ELSE COALESCE(cb.gen, 'n/a')
	END AS new_gen
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON		  ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON		  ci.cst_key = cl.cid
ORDER BY 1, 2

-- the code will be. Then giving the columns proper names and arrange them
SELECT
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(cb.gen, 'n/a')
	END AS gender,
	cb.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON		  ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON		  ci.cst_key = cl.cid;

-- Creating/Generating Surrogate Keys (System generated unique identifier on each record)
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(cb.gen, 'n/a')
	END AS gender,
	cb.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON		  ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON		  ci.cst_key = cl.cid;

-- Creating the Object
CREATE VIEW gold.dim_customers AS
SELECT
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id,
	ci.cst_key AS customer_number,
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	cl.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
		ELSE COALESCE(cb.gen, 'n/a')
	END AS gender,
	cb.bdate AS birthdate,
	ci.cst_create_date AS create_date
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 cb
ON		  ci.cst_key = cb.cid
LEFT JOIN silver.erp_loc_a101 cl
ON		  ci.cst_key = cl.cid

-- *****************************************************************************

-- Product - Dimension
-- Joining only Products with the Current Info (NULL prd_end_dt)
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON		  pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filtering out all historical data

-- Showing prd_key that are duplicated and how many times they appear
SELECT prd_key, COUNT(*) FROM (
SELECT
	pn.prd_id,
	pn.cat_id,
	pn.prd_key,
	pn.prd_nm,
	pn.prd_cost,
	pn.prd_line,
	pn.prd_start_dt,
	pc.cat,
	pc.subcat,
	pc.maintenance
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON		  pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filtering out all historical data
)t
GROUP BY prd_key
HAVING COUNT(*) > 1

-- Rearranging the columns to be organized and giving Friendly names
SELECT
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON		  pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filtering out all historical data

-- Creating/Generating Surrogate Keys (System generated unique identifier on each record)
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON		  pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filtering out all historical data

-- Creating Object/View
CREATE VIEW gold.dim_products AS
SELECT
	ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt, pn.prd_key) AS product_key,
	pn.prd_id AS product_id,
	pn.prd_key AS product_number,
	pn.prd_nm AS product_name,
	pn.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pn.prd_cost AS cost,
	pn.prd_line AS product_line,
	pn.prd_start_dt AS start_date
FROM silver.crm_prd_info pn
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON		  pn.cat_id = pc.id
WHERE prd_end_dt IS NULL -- Filtering out all historical data


-- ********************************************************************************************
-- Sales- Fact
