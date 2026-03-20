# Retail Sales SQL Project

## Project Overview
This project analyzes retail sales data using SQL, covering data cleaning, transformation, and business insights extraction.

It demonstrates practical SQL skills required for a Data Analyst role, including:
- Data Cleaning
- Exploratory Data Analysis (EDA)
- Aggregations & Filtering
- Window Functions
- Customer Segmentation

---

##  Database Setup

CREATE DATABASE NEW_PROJECT_1;
USE NEW_PROJECT_1;

---

## Table Creation

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id VARCHAR(100),
    gender VARCHAR(50),
    age INT,
    category VARCHAR(100),
    quantiy INT,
    price_per_unit DECIMAL(5,2),
    cogs DECIMAL(5,2),
    total_sale INT
);

---

## Data Cleaning

-- Check NULL values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- Delete NULL values
SET SQL_SAFE_UPDATES = 0;

DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantiy IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

-- Rename column
ALTER TABLE retail_sales
CHANGE quantiy quantity INT;

-- Standardize category
UPDATE retail_sales
SET category = LOWER(TRIM(category));

---

## SQL Analysis Queries

-- 1. Filter clothing sales
SELECT transactions_id, category, quantity, total_sale, sale_date
FROM retail_sales
WHERE LOWER(TRIM(category)) = 'clothing'
AND quantity > 10
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-01';

-- 2. Total sales by category
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- 3. Average age (beauty)
SELECT category, AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'beauty'
GROUP BY category;

-- 4. Categories with sales > 1000
SELECT category, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY category
HAVING SUM(total_sale) > 1000;

-- 5. Transactions by gender
SELECT gender, category, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY gender, category
ORDER BY category DESC;

-- 6. Highest average daily sales
SELECT sale_date, AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY sale_date
ORDER BY avg_sales DESC
LIMIT 1;

-- 7. Highest monthly sales
SELECT YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY year, month
ORDER BY avg_sales DESC
LIMIT 2;

-- 8. Top 5 customers
SELECT customer_id, gender, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id, gender
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Unique customers per category
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- 10. Orders by shift
WITH hourly_sales AS (
    SELECT *,
    CASE
        WHEN HOUR(sale_time) < 12 THEN 'morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 14 THEN 'afternoon'
        WHEN HOUR(sale_time) BETWEEN 15 AND 17 THEN 'evening'
        ELSE 'night'
    END AS shift
    FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;

-- 11. Peak sales hour
SELECT HOUR(sale_time) AS hour, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY hour
ORDER BY total_orders DESC;

-- 12. Revenue contribution %
SELECT category,
SUM(total_sale) AS total_sales,
ROUND(SUM(total_sale) * 100.0 /
(SELECT SUM(total_sale) FROM retail_sales), 2) AS percentage
FROM retail_sales
GROUP BY category
ORDER BY total_sales DESC;

-- 13. Repeat customers
SELECT customer_id, COUNT(*) AS purchase_count
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY purchase_count DESC;

-- 14. Customer segmentation
SELECT customer_id,
SUM(total_sale) AS total_spent,
CASE
    WHEN SUM(total_sale) > 2000 THEN 'high'
    WHEN SUM(total_sale) BETWEEN 1000 AND 2000 THEN 'medium'
    ELSE 'low'
END AS customer_segment
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC;

-- 15. Running total
SELECT sale_date,
SUM(total_sale) AS daily_sales,
SUM(SUM(total_sale)) OVER (ORDER BY sale_date) AS running_total
FROM retail_sales
GROUP BY sale_date;

---

## Tools Used
- SQL (MySQL)
- VS Code / MySQL Workbench

---

## Author
Parthiban  
Aspiring Data Analyst  
Skills: SQL | Python | Power BI

---

##  Support
If you like this project, give it a like on GitHub!
