#  Retail Sales Analysis SQL Project

## 1. Database Setup

- **Database Creation**: Create database `NEW_PROJECT_1`
- **Table Creation**: Create table `retail_sales`

```sql
CREATE DATABASE NEW_PROJECT_1;
USE NEW_PROJECT_1;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id VARCHAR(100),
    gender VARCHAR(50),
    age INT,
    category VARCHAR(100),
    quantity INT,
    price_per_unit DECIMAL(5,2),
    cogs DECIMAL(5,2),
    total_sale INT
);
```

---

## 2. Data Exploration & Cleaning

```sql
-- Total Records
SELECT COUNT(*) FROM retail_sales;

-- Check NULL values
SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;

### Delete NULL values
```sql
DELETE FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR age IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR cogs IS NULL
OR total_sale IS NULL;
```

### Standardize category
```sql
UPDATE retail_sales
SET category = LOWER(TRIM(category));
```

---

## 3. Data Analysis Queries

### 1. Sales on Specific Date
```sql
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';
```

### 2. Clothing Sales (Nov 2022)
```sql
SELECT *
FROM retail_sales
WHERE category = 'clothing'
AND quantity > 10
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
```

### 3. Total Sales by Category
```sql
SELECT category, SUM(total_sale) AS net_sale, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;
```

### 4. Average Age (Beauty)
```sql
SELECT AVG(age) AS avg_age
FROM retail_sales
WHERE category = 'beauty';
```

### 5. Transactions > 1000
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

### 6. Transactions by Gender
```sql
SELECT category, gender, COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender;
```

### 7. Best Selling Month
```sql
SELECT YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
AVG(total_sale) AS avg_sales
FROM retail_sales
GROUP BY year, month
ORDER BY avg_sales DESC;
```

### 8. Top 5 Customers
```sql
SELECT customer_id, SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

### 9. Unique Customers
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

### 10. Orders by Shift
```sql
WITH hourly_sales AS (
SELECT *,
CASE
WHEN HOUR(sale_time) < 12 THEN 'Morning'
WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders
FROM hourly_sales
GROUP BY shift;
```

### 11. Peak Sales Hour
```sql
SELECT HOUR(sale_time) AS hour, COUNT(*) AS total_orders
FROM retail_sales
GROUP BY hour
ORDER BY total_orders DESC;
```

### 12. Revenue Contribution
```sql
SELECT category,
SUM(total_sale) AS total_sales,
ROUND(SUM(total_sale) * 100.0 / (SELECT SUM(total_sale) FROM retail_sales), 2) AS percentage
FROM retail_sales
GROUP BY category;
```

### 13. Repeat Customers
```sql
SELECT customer_id, COUNT(*) AS purchase_count
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(*) > 1;
```

### 14. Customer Segmentation
```sql
SELECT customer_id,
SUM(total_sale) AS total_spent,
CASE
WHEN SUM(total_sale) > 2000 THEN 'High'
WHEN SUM(total_sale) BETWEEN 1000 AND 2000 THEN 'Medium'
ELSE 'Low'
END AS customer_segment
FROM retail_sales
GROUP BY customer_id;
```

### 15. Running Total
```sql
SELECT sale_date,
SUM(total_sale) AS daily_sales,
SUM(SUM(total_sale)) OVER (ORDER BY sale_date) AS running_total
FROM retail_sales
GROUP BY sale_date;
```

---

## 👨‍💻 Author
Parthiban  
