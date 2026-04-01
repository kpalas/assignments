#  Supermarket Relational Database

## 🎯 Overview
This project is a fully structured MySQL relational database designed to manage the operations of a supermarket. It handles complex data relationships between customers, employees, inventory (stock), promotional deals, and daily transaction records.

## 🌟 Key Features
* **Schema Design:** Designed and implemented a robust relational schema using `CREATE TABLE` statements with strict Primary Key and Foreign Key constraints to maintain referential integrity.
* **Data Population:** Utilized `INSERT` scripts to populate the database with realistic test data for robust query testing.
* **Complex View Generation:** Engineered advanced SQL `VIEW`s to extract meaningful business intelligence from raw data, including:
  * Tracking specific employee sales metrics within defined date ranges.
  * Calculating age dynamically using `TIMESTAMPDIFF` to enforce age-restricted item sales (e.g., Alcohol).
  * Grouping and aggregating inventory data to monitor remaining stock levels.
  * Identifying high-value customers for promotional prize draws based on transaction volume.
  * Determining the cheapest items within categorized transaction lists using self-joins.

## 🛠️ Technical Stack
* **Language:** SQL (MySQL Dialect)
* **Concepts Demonstrated:** Multi-table `JOIN`s, Aggregate Functions (`COUNT`, `MAX`), Conditional Logic (`CASE WHEN`), Date/Time Mathematics (`DATEDIFF`, `TIMESTAMPDIFF`), and Subqueries.

## 🚀 How to Run
1. Open a MySQL client (e.g., MySQL Workbench, DataGrip, or the command line).
2. Create a new, empty database: `CREATE DATABASE supermarket; USE supermarket;`
3. Execute the `supermarket.sql` script to build the schema, populate the initial data, and generate the analytical views.
4. *(Optional)* Execute the provided `INSERT Statements for public test data.sql` to populate the database with extended test records.
