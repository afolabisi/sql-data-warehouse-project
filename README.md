# SQL Data Warehouse Project

## Overview

This project demonstrates the design and implementation of a modern SQL data warehouse using the Bronze, Silver, and Gold architecture.

The project covers the complete ETL process, from loading raw data into the warehouse to transforming it into business-ready reports and analytical views.

---

## Project Architecture

The warehouse follows a three-layer architecture:

- Bronze Layer: Stores raw data imported from source systems.
- Silver Layer: Cleans, validates, and transforms the raw data.
- Gold Layer: Contains business-ready views and reports for analytics.

### Architecture Diagram

![Architecture](docs/Architecture_Diagram.jpg)

---

## Repository Structure

```text
sql-data-warehouse-project/

├── datasets/
│
├── docs/
│   ├── Architecture_Diagram.jpg
│   ├── Source_System_Diagram.jpg
│   ├── Bronze Table
│   ├── Silver Table Load
│   ├── Gold Layer View
│   └── Data Cleansing
│
├── script/
│   ├── Bronze/
│   │   ├── ddl_script.sql
│   │   └── proc.load_bronze.sql
│   │
│   ├── Silver/
│   │   ├── ddl_silver.sql
│   │   ├── proc.load_silver.sql
│   │   └── init_database.sql
│   │
│   └── Gold/
│       ├── ddl_scripts.sql
│       ├── Customer_Report.sql
│       └── Product_Report.sql
│
├── Tests/
│   ├── quality_checks_silver.sql
│   └── quality_checks_gold.sql
│
└── README.md
```

---

# Data Warehouse Layers

## Bronze Layer

The Bronze layer stores raw data exactly as received from source systems.

### Tasks

- Import CSV files
- Preserve original data
- Create staging tables
- Load raw records

---

## Silver Layer

The Silver layer focuses on data cleaning and transformation.

### Tasks

- Remove duplicates
- Standardize formats
- Handle null values
- Clean customer and product data
- Apply business rules

---

## Gold Layer

The Gold layer contains analytical views optimized for reporting.

### Reports

#### Customer Report

Provides customer insights, including:

- Customer segmentation
- Total orders
- Total sales
- Total quantity purchased
- Customer lifespan
- Average order value
- Average monthly spending
- Customer recency

#### Product Report

Provides product insights, including:

- Product segmentation
- Total sales
- Total quantity sold
- Total customers
- Product lifespan
- Average selling price
- Average order revenue
- Average monthly revenue

---

# ETL Workflow

1. Extract data from source systems.
2. Load raw data into Bronze tables.
3. Clean and transform data in Silver tables.
4. Build analytical views in Gold.
5. Validate data quality using test scripts.

---

# Data Quality Checks

The project includes validation scripts to ensure:

- No duplicate records
- No missing keys
- Correct relationships
- Data consistency
- Accurate business calculations

---

# Technologies Used

- SQL Server
- T-SQL
- SSMS
- ETL
- Data Warehouse Modeling
- Git
- GitHub

---

# Documentation

Additional documentation is available in the `docs` folder:

- Architecture diagrams
- Source system diagrams
- Data cleansing process
- Table structures
- Gold-layer views

---

# Future Improvements

- Power BI dashboard integration
- Incremental loading
- SQL Agent automation
- Performance optimization
- Index tuning

---

# Author

**Afolabi Sunday**

Aspiring Data Analyst and future Data Scientist passionate about SQL, data engineering, and analytics.
