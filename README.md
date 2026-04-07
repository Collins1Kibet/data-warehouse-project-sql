# Data Warehouse and Analytics Project

## Welcome to the Data Warehouse and Analytics Project repository

This project showcases an end-to-end data warehousing and analytics solution, from raw data ingestion to actionable business insights.  

The solution covers the full data pipeline, including:

* Data ingestion from source systems (Bronze layer)
* Data cleaning and transformation (Silver layer)
* Data modeling and analytics-ready structures (Gold layer)
* Insight generation through analytical queries

## Data Architecture
The data architecture for this project follows the Medallion Architecture, consisting of Bronze, Silver, and Gold layers:
<img width="1480" height="764" alt="data_architecture" src="https://github.com/user-attachments/assets/63f559d9-d70a-4c13-85a7-1f4775d6d2ac" />

## Project Overview
This project involves:

- Data Architecture: Designing a Modern Data Warehouse Using Medallion Architecture Bronze, Silver, and Gold layers.
- ETL Pipelines: Extracting, transforming, and loading data from source systems into the warehouse.
- Data Modeling: Developing fact and dimension tables optimized for analytical queries.
- Analytics & Reporting: Creating SQL-based reports and dashboards for actionable insights.

## Project Requirements
### Building the Data Warehouse (Data Engineering)
#### Objective
Develop a modern data warehouse using SQL Server to consolidate sales data, enabling analytical reporting and informed decision-making.

### Specifications
- **Data Sources:** Import data from two source systems (ERP and CRM) provided as CSV files  
- **Data Quality:** Cleanse and resolve data quality issues prior to analysis  
- **Integration:** Combine both sources into a single, user-friendly data model designed for analytical queries  
- **Scope:** Focus on the latest dataset only; historization of data is not required  
- **Documentation:** Provide clear documentation of the data model to support both business stakeholders and analytics teams  

## How to Run the Project
1. Load raw data (CSV files) into the Bronze layer
2. Run SQL scripts to clean and transform data into the Silver layer
3. Execute transformation scripts to create Gold layer views
4. Run analytical queries on the Gold layer

## Future Improvements
- Add incremental data loading
- Implement Slowly Changing Dimensions (SCD)
- Integrate Power BI dashboards
- Automate ETL pipeline
