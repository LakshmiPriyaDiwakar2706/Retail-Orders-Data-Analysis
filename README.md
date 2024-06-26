
# Retail Orders Analysis Project

## Overview
The main purpose of this project is to demonstrate how to transform an extracted dataset using Pandas, load it into a PostgreSQL database, and write queries to answer business questions. This project also serves as a means to assess and improve my SQL skills.

## Tools and Technologies Used
- [Pandas](https://pandas.pydata.org/)
- [PostgreSQL](https://www.postgresql.org/)
- [SQLAlchemy](https://www.sqlalchemy.org/)

## Data Sources
The dataset used in this project is the `orders.csv` file, which was downloaded from [Kaggle](https://www.kaggle.com/). The dataset contains information about retail orders.

## Data Cleaning
The data cleaning process was carried out using Pandas and involved the following steps:
1. **Renaming Columns:** Changed column names to follow a consistent naming pattern.
2. **Creating Calculated Columns:** Added columns for `discount`, `profit`, and `sales price` based on existing columns.

## Database Design
The cleaned data was loaded into a PostgreSQL database named `retail_orders` using the SQLAlchemy library. The following steps were taken to optimize the database:
1. **Data Type Conversion:** Ensured data types were compatible with SQL data types.
2. **Index Creation:** Created indexes on frequently used columns to improve query performance.

## Business Questions
The main goal of this project was to connect Python to a PostgreSQL database and use the loaded data to write complex queries to answer business questions. Some of the business questions answered include:
- Total sales by category
- Top customers by profit
- Monthly sales trends
- Product performance by region

To see the code used for data cleaning and SQL queries, please check out the following files:
- [Data Cleaning Script](https://github.com/LakshmiPriyaDiwakar2706/Retail-Orders-Data-Analysis/blob/main/retailorders_datacleaning.ipynb)
- [SQL Queries](https://github.com/LakshmiPriyaDiwakar2706/Retail-Orders-Data-Analysis/blob/main/reatil_orders_output.sql)

Sales Report:
Additionally, I have created a sales report presentation envisioning how I would present it to my technical lead. Please take a look at the report here: [Sales Report](https://github.com/LakshmiPriyaDiwakar2706/Retail-Orders-Data-Analysis/blob/main/Sales%20Report.pdf)

## References
This project was inspired by Ankit Bansal's "End to End Data Analytics Project (Python + SQL)" available on [YouTube](https://www.youtube.com/watch?v=uL0-6kfiH3g&t=276s) where I got the business questions from his videos and wrote SQL queries by myself.

---

Thank you for visiting this repository. If you have any questions or feedback, feel free to contact me or open an issue. Happy analyzing!
