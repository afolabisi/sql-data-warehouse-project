/*
DDL Scripts:  Create Bronze Tabbles
=============================================================================
Script Purpose:
  This script creates tables in the 'bronze' schema, dropping existing tables 
  if they already exist.
  Run ths script to re-define the DDL structure of 'bronze' Tables
=============================================================================
*/

IF OBJECT_ID ('Bronze.crm_cus_info', 'U') IS  NOT NULL
	DROP TABLE Bronze.crm_cus_info;
CREATE  TABLE Bronze.crm_cus_info (
	cst_id               INT,
	cst_key              NVARCHAR (50),
	cst_firstName        NVARCHAR(50),
	cst_lastName         NVARCHAR(50),
	cst_material_status  NVARCHAR(100),
	cst_gndr             NVARCHAR(10),
	cst_created_date     DATE,
);

IF OBJECT_ID ('Bronze.crm_prd_info', 'U') IS  NOT NULL
	DROP TABLE Bronze.crm_prd_info;
CREATE TABLE Bronze.crm_prd_info (
	prd_id INT,
	prd_key      NVARCHAR (50),
	prd_name     NVARCHAR(50),
	prd_cost     NVARCHAR(50),
	prd_line     NVARCHAR(50),
	prd_start_dt DATE,
	prd_end_dt   DATE,
);

IF OBJECT_ID ('Bronze.crm_sales_details', 'U') IS  NOT NULL
	DROP TABLE Bronze.crm_sales_details;
CREATE TABLE Bronze.crm_sales_details (
	sls_order_num NVARCHAR (50),
	sls_prd_key   NVARCHAR(50),
	sls_cusID     INT,
	sls_order_dt  INT,
	sls_ship_dt   INT,
	sls_due_dt    INT,
	sls_sales     INT,
	sls_qty       INT,
	sls_price     INT
);

IF OBJECT_ID ('Bronze.erp_cust_az12', 'U') IS  NOT NULL
	DROP TABLE Bronze.erp_cust_az12;
CREATE TABLE Bronze.erp_cust_az12 (
	cid   NVARCHAR(50),
	bdate DATE,
	gen   NVARCHAR(50)
);

IF OBJECT_ID ('Bronze.erp_loc_a101', 'U') IS  NOT NULL
	DROP TABLE Bronze.erp_loc_a101;
CREATE TABLE Bronze.erp_loc_a101 (
	cid   NVARCHAR(50),
	cntry NVARCHAR (50)
);

IF OBJECT_ID ('Bronze.erp_px_cat_giv2', 'U') IS  NOT NULL
	DROP TABLE Bronze.erp_px_cat_giv2;
CREATE TABLE Bronze.erp_px_cat_giv2 (
	id			    NVARCHAR (50),
	cat			    NVARCHAR (50),
	subcat		  NVARCHAR (50),
	maintenance NVARCHAR (50)
);
