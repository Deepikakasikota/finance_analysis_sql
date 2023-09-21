# Finance and Sales Analysis
This repository contains code for finance and sales analytics. The code is designed to perform various financial and sales analysis tasks. Below are the main components of the code and their functionalities:

## Finance Analytics
### A. Customer Codes for Croma India
The first SQL query retrieves customer codes for the Croma India market from the dim_customer table.

### B. Sales Transaction Data for Croma India in Fiscal Year 2021
The second SQL query retrieves all the sales transaction data from the fact_sales_monthly table for the customer (Croma: 90002002) in the fiscal year 2021.

### C. Creating Functions 'get_fiscal_year' & 'get_fiscal_quarter'
A user-defined function named get_fiscal_year is created to get the fiscal year by passing a date and get_fiscal_quarter is created to get the quarter of the fiscal year.

### D. Replacing the Function in the Query
The third SQL query replaces the function created in step C and retrieves sales transaction data using the new function.

## Gross Sales Reports:

#### 1. Monthly Product Transactions

Joins product information from the dim_product table with sales data from the fact_sales_monthly table for Croma India in fiscal year 2021.

#### 2. Total Sales Amount

Generates a monthly gross sales report for Croma India for all years, aggregating the sales data from the fact_sales_monthly and fact_gross_price tables.

## Yearly Report for Croma India
Generates a yearly report for Croma India, showing two columns:

1. Fiscal Year
2. Total Gross Sales amount in that year from Croma

## Stored Procedures:
#### 1. get_monthly_gross_sales_for_customer

Generates a monthly gross sales report for any customer by passing customer codes as input.

#### 2. get_market_badge

Retrieves the market badge (Gold or Silver) based on the total sold quantity for a given market and fiscal year.

#### 3. get_forecast_accuracy
Gives the forecast accuracy by given fiscal year.

#### 4. get_top_n_customers_by_net_sales
Gives the top n customers by their net sales of given fiscal year.

#### 4. get_top_n_products_by_net_sales
Retrives the top products by their net sales.

#### 5. get_top_n_markets_by_net_sales
Gives the top n markets by their net sales of given fiscal year.

#### 4. get_top_n_products_per_division_by_sold_quantity
Retrives the top products in the given division by sold quantity.

## Supply Chain Analytics:

### Creating fact_act_est Table

This part of the code creates a new fact_act_est table, which combines data from the fact_sales_monthly and fact_forecast_monthly tables.
which helps to findout the following--
  
  - Net Error
  - Net Error %
  - Absolute Error
  - Absolute Error %
  - Forecast Accuracy
 
### Temporary Tables and Forecast Accuracy Report
This section demonstrates the use of temporary tables and stored procedures to generate a forecast accuracy report for a given fiscal year.

### User Accounts and Privileges
This section deals with user management and grants certain privileges to a new user 'thor' for the 'gdb041' database.

