/*
===============================================================================
Quality Checks — Bronze to Silver Layer
===============================================================================
Script Purpose:
    This script contains the exploratory data quality checks performed on the
    Bronze layer tables before designing the Silver layer transformation logic.

    These checks were used to identify:
        - Duplicate or null primary keys
        - Unwanted whitespace in string fields
        - Inconsistent categorical values (e.g. abbreviations, typos)
        - Invalid or out-of-range dates
        - Referential mismatches between related tables
        - Business rule violations (e.g. Sales = Quantity * Price)

    Note: This script is for inspection only — it does not modify any data.
    Run these queries against the Bronze layer to understand the "why" behind
    each transformation rule applied in Silver.load_silver.
===============================================================================
*/

-- ===========================================================================
-- Bronze.crm_cus_info
-- ===========================================================================

-- Check for duplicate or missing customer IDs
SELECT cst_id, COUNT(*) AS total
FROM Bronze.crm_cus_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- ===========================================================================
-- Bronze.crm_prd_info
-- ===========================================================================

-- Check for duplicate or missing product IDs
SELECT prd_id, COUNT(*) AS total
FROM Bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for nulls in product cost
SELECT *
FROM Bronze.crm_prd_info
WHERE prd_cost IS NULL;

-- Preview product key split: first 5 chars as category ID (with '-' replaced by '_')
SELECT
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    prd_name,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM Bronze.crm_prd_info
WHERE REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') IN (
    SELECT cat FROM Bronze.erp_px_cat_giv2
);

-- Preview product key split: remaining characters as the actual product key
SELECT
    prd_id,
    prd_key,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key2,
    prd_name,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
FROM Bronze.crm_prd_info
WHERE SUBSTRING(prd_key, 7, LEN(prd_key)) IN (
    SELECT prd_key FROM Bronze.crm_sales_details
);

-- Check for negative or null product cost
SELECT prd_cost
FROM Bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check all distinct product line values (to map abbreviations to full names)
SELECT DISTINCT prd_line FROM Bronze.crm_prd_info;

-- Check for invalid date order: end date occurring before start date
SELECT *
FROM Bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Preview corrected end date using LEAD() (next start date minus 1 day)
SELECT
    prd_id,
    prd_key,
    prd_name,
    prd_start_dt,
    prd_end_dt,
    DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt_test
FROM Bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'CL-SO-SO-B909-M', 'AC-HE-HL-U509-B');


-- ===========================================================================
-- Bronze.crm_sales_details
-- ===========================================================================

-- Check for unwanted leading/trailing whitespace in order numbers
SELECT *
FROM Bronze.crm_sales_details
WHERE sls_order_num != TRIM(sls_order_num);

-- Check referential integrity: product keys not present in Silver.crm_prd_info
SELECT *
FROM Bronze.crm_sales_details
WHERE sls_prd_key NOT IN (SELECT prd_key FROM Silver.crm_prd_info);

-- Check referential integrity: customer IDs not present in Silver.crm_cus_info
SELECT *
FROM Bronze.crm_sales_details
WHERE sls_cusID NOT IN (SELECT cst_id FROM Silver.crm_cus_info);

-- Check date quality: invalid, zero, or out-of-range order dates
SELECT sls_order_dt
FROM Bronze.crm_sales_details
WHERE sls_order_dt <= 0
   OR LEN(sls_order_dt) != 8
   OR sls_order_dt > 20500101
   OR sls_order_dt < 19900101;

-- Check that order date is not later than ship date
SELECT *
FROM (
    SELECT
        CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) AS OrderDate,
        CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)  AS ShipDate
    FROM Bronze.crm_sales_details
    WHERE LEN(sls_order_dt) = 8
) t
WHERE DATEDIFF(DAY, OrderDate, ShipDate) < 0;

-- Check that order date is not later than due date
SELECT *
FROM (
    SELECT
        CAST(CAST(sls_order_dt AS VARCHAR) AS DATE) AS OrderDate,
        CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)   AS DueDate
    FROM Bronze.crm_sales_details
    WHERE LEN(sls_order_dt) = 8
) t
WHERE DATEDIFF(DAY, OrderDate, DueDate) < 0;

-- Check business rule: Sales = Quantity * Price (and no nulls/negatives/zeros)
SELECT DISTINCT
    sls_price,
    sls_qty,
    sls_sales
FROM Bronze.crm_sales_details
WHERE sls_sales != sls_price * sls_qty
   OR sls_sales IS NULL OR sls_qty IS NULL OR sls_price IS NULL
   OR sls_sales <= 0 OR sls_qty <= 0 OR sls_price <= 0
ORDER BY sls_price, sls_qty, sls_sales;


-- ===========================================================================
-- Bronze.erp_cust_az12
-- ===========================================================================

-- Check for the 'NAS' prefix mismatch against Silver.crm_cus_info.cst_key
SELECT
    cid,
    CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid)) ELSE cid END AS cid_cleaned,
    bdate,
    gen
FROM Bronze.erp_cust_az12;

-- Check for invalid birth dates (too old or in the future)
SELECT bdate
FROM Bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();


-- ===========================================================================
-- Bronze.erp_loc_a101
-- ===========================================================================

-- Check for consistency/standardization of country values
SELECT DISTINCT cntry
FROM Bronze.erp_loc_a101
ORDER BY cntry;


-- ===========================================================================
-- Bronze.erp_px_cat_giv2
-- ===========================================================================

-- Check subcategory values for consistency (data confirmed clean — no
-- transformation needed before loading to Silver)
SELECT DISTINCT subcat FROM Bronze.erp_px_cat_giv2;

