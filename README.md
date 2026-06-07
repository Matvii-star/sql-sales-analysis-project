# sql-sales-analysis-project
## Project Overview

This project analyzes sales performance using SQL and PostgreSQL.

The dataset contains information about orders, products, customers, locations, and sales targets. The goal of the analysis is to answer common business questions related to revenue, profit, customer behavior, geographic performance, and sales target achievement.

All analysis was performed using SQL in PostgreSQL.

---

## Dataset Structure

The project uses three tables:

### list_orders

Contains order-level information:

* Order ID
* Order Date
* Customer Name
* State
* City

### order_details

Contains product-level information:

* Order ID
* Amount
* Profit
* Quantity
* Category
* Sub-Category

### sales_target

Contains monthly sales targets:

* Month of Order Date
* Category
* Target

---

## Data Quality Checks

Before performing the analysis, the following checks were completed:

* Row count validation
* Missing value detection
* Orphan record detection using joins

---

## Analysis Performed

### Sales Overview

* Total Revenue
* Total Profit
* Total Orders
* Average Order Value

### Category Analysis

* Revenue by Category
* Profit by Category
* Top Performing Sub-Categories

### Customer Analysis

* Top Customers by Revenue
* Top Customers by Profit
* Order Distribution by Customer

### Geographic Analysis

* Revenue by State
* Revenue by City
* Profit by State and City

### Sales Target Analysis

* Revenue vs Sales Target by Category
* Monthly Target Achievement Analysis

### Time Analysis

* Revenue by Month
* Profit by Month
* Orders by Month
* Month-over-Month Revenue Growth

### Window Functions

* Customer Revenue Ranking
* City Revenue Ranking
* Revenue Growth Analysis using LAG()

---

## SQL Concepts Used

* Aggregations (SUM, AVG, COUNT)
* GROUP BY
* ORDER BY
* INNER JOIN
* LEFT JOIN
* Common Table Expressions (CTEs)
* Window Functions

  * RANK()
  * DENSE_RANK()
  * LAG()
* Date Functions

  * DATE_TRUNC()

---

## Key Findings

* Revenue and profit are concentrated in a small number of categories and customers.
* Sales performance varies significantly across different cities and states.
* Some categories exceeded their sales targets while others underperformed.
* Month-over-month analysis reveals periods of growth and decline in revenue.
* Customer and geographic segmentation provides useful business insights for decision-making.

---

## Tools Used

* PostgreSQL
* pgAdmin 4
* Git
* GitHub

---

## Repository Structure

├── sql_queries.sql
├── README.md
└── screenshots/

---

## Author

Created as part of my Data Analytics portfolio to practice SQL, business analysis, and data exploration using PostgreSQL.
