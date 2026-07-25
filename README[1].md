# SQL Data Warehouse Project

A SQL Server data warehouse built using the **Medallion Architecture**
(Bronze → Silver → Gold), consolidating CRM and ERP source data into a
clean, analysis-ready star schema.

## 🏗️ Architecture

![Architecture Diagram](docs/architecture_diagram.png)

- **Bronze**: Raw ingestion from source CSVs, no transformation. Serves as
  an auditable copy of the original data.
- **Silver**: Cleaned and conformed data — deduplication, trimming, type
  correction, standardized categorical values, and business-rule validation
  (e.g. `sales = quantity * price`).
- **Gold**: A star schema exposed as views — `dim_customers`, `dim_product`,
  and `fact_sales` — built for reporting and analysis.

## 🗂️ Source Systems

![Source Systems Diagram](docs/source_systems_diagram.png)

| System | Table | Description |
|--------|-------|-------------|
| CRM | `crm_sales_details` | Transactional records about sales & orders |
| CRM | `crm_prd_info` | Current & historical product information |
| CRM | `crm_cust_info` | Customer information |
| ERP | `erp_cust_az12` | Extra customer information |
| ERP | `erp_loc_a101` | Location of customers (country) |
| ERP | `erp_px_cat_giv2` | Product categories |

## ⭐ Gold Layer Data Model

![Gold Layer ERD](docs/gold_layer_erd.png)

The Gold layer follows a star schema: `Gold.fact_sales` sits at the center,
linked to `Gold.dim_customers` and `Gold.dim_product` via surrogate keys
(`customer_key`, `product_key`). The core business rule enforced in Silver
and reflected here is:

```
Sales = Quantity * Price
```

## 📂 Repository Structure

```
├── docs/
│   ├── architecture_diagram.png       -- Bronze/Silver/Gold flow
│   ├── source_systems_diagram.png     -- CRM/ERP table relationships
│   └── gold_layer_erd.png             -- Gold layer star schema
├── scripts/
│   ├── init_database.sql              -- Creates DB, schemas, and Bronze/Silver tables
│   ├── load_bronze.sql                -- Bronze.load_bronze stored procedure
│   ├── load_silver.sql                -- Silver.load_silver stored procedure
│   └── gold_layer.sql                 -- Gold layer views (star schema)
├── tests/
│   ├── quality_checks_bronze_to_silver.sql  -- Data profiling & validation queries
│   └── quality_checks_gold.sql              -- Star schema integrity checks
└── README.md
```

## 🚀 How to Run

1. Run `scripts/init_database.sql` to create the database, schemas, and tables.
2. Update the file paths in `scripts/load_bronze.sql` to match your local CSV
   source locations.
3. Execute the stored procedures in order:
   ```sql
   EXEC Bronze.load_bronze;
   EXEC Silver.load_silver;
   ```
4. Run `scripts/gold_layer.sql` to create the Gold layer views.
5. Query the Gold layer for analysis:
   ```sql
   SELECT * FROM Gold.fact_sales;
   ```

## ✅ Data Quality Approach

Before writing transformation logic, the Bronze layer was profiled for:
- Duplicate/null primary keys
- Unwanted whitespace
- Inconsistent categorical values (abbreviations, typos)
- Invalid or out-of-range dates
- Referential mismatches between related tables
- Business rule violations (e.g. Sales ≠ Quantity × Price)

The queries used for this are documented in
`tests/quality_checks_bronze_to_silver.sql` and `tests/quality_checks_gold.sql`,
showing the reasoning behind each cleaning rule applied in the Silver layer.

## 🛠️ Notes / Design Decisions

- Gold layer dimension/fact tables are implemented as **views**, not
  materialized tables, so they always reflect the latest Silver data.
- `fact_sales` uses `LEFT JOIN`s to its dimensions — a sale with no matching
  product or customer key still appears in the fact table (with a `NULL`
  key) rather than being silently dropped. This is a deliberate choice to
  avoid losing transactional data.
- Surrogate keys (`customer_key`, `product_key`) are generated with
  `ROW_NUMBER()` since the source systems only provide natural/business keys.

## 📄 License

MIT — feel free to reuse and adapt.
