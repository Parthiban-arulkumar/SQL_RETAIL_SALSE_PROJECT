create DATABASE NEW_PROJECT_1;
USE NEW_PROJECT_1;
CREATE TABLE retail_sales (

transactions_id int primary  key,
	sale_date	date,
    sale_time	time,
    customer_id varchar(100),
	gender	varchar(50),
    age	int,
    category varchar(100),
	quantiy	int,
    price_per_unit decimal(5,2),
	cogs	decimal(5,2),
    total_sale int

);
SELECT * FROM retail_sales;
-- DATA CLEANING
-- checking for null values 

select* from retail_sales
where transactions_id	is null
or sale_date	is null
or sale_time is null
or customer_id is null
or gender	is null
or age	is null
or category	is null
or quantiy	is null
or price_per_unit	is null
or cogs	is null
or total_sale is null;
select * from retail_sales;

-- check number of rows in the table

select count(*) from retail_sales;

-- checking count of null in each cooumn

select count(*) from retail_sales
where transactions_id	is null
or sale_date	is null
or sale_time is null
or customer_id is null
or gender	is null
or age	is null
or category	is null
or quantiy	is null
or price_per_unit	is null
or cogs	is null
or total_sale is null;

-- deleting nulL values 

SET SQL_SAFE_UPDATES = 0; -- temporary safe mode off
delete from retail_sales
where transactions_id	is null
or sale_date	is null
or sale_time is null
or customer_id is null
or gender	is null
or age	is null
or category	is null
or quantiy	is null
or price_per_unit	is null
or cogs	is null
or total_sale is null;

select count(*) from retail_sales;
SELECT * FROM retail_sales
where category = "Clothing" and quantiy > 10 ;
SELECT transactions_id, category, quantiy, total_sale, sale_date
FROM retail_sales
WHERE LOWER(TRIM(category)) = 'clothing'
  AND quantiy > 10
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';
select * from retail_sales;

-- change coloumn name 

alter table retail_sales
CHANGE quantiy quantity int;
SELECT COUNT(*) 
FROM retail_sales
WHERE LOWER(TRIM(category)) = 'clothing';
UPDATE retail_sales
SET category = LOWER(TRIM(category));
UPDATE retail_sales
SET category = NULL
WHERE TRIM(category) = '';
SELECT MIN(quantity), MAX(quantity)
FROM retail_sales;
SELECT count(*) as total_count FROM retail_sales
WHERE category = 'clothing' AND quantity > 3;

-- quantity sold more than 3 on clothing 

SELECT * FROM retail_sales
WHERE category = 'clothing'
  AND quantity >= 3
  AND sale_date >= '2022-11-01'
  AND sale_date < '2022-12-01';

  -- total sales and count on each category

  select category , sum(total_sale) as net_sale , count(*) as total_count
  from retail_sales
  group by category;

  -- average age of customers who purchased from beauty  category

  select category , avg(age) as average_age , count(*) as total_count from retail_sales
  where category = 'Beauty'
  group by category;

  -- total salse more than 1000

 select category , sum(total_sale) from retail_sales
 group by category
 having sum(total_sale) > 1000;

 -- total transaction made by each gender in each category

 select count(transactions_id) as total_transactions , gender , category  from retail_sales
 group by gender ,category
 order by category desc;

 -- find avg sales more in one day 

 select sale_date , avg(total_sale) as average_sale from retail_sales
 group by sale_date
 order by  avg(total_sale) desc limit 1;

 -- find avg salse more in which month 

 select year(sale_date) as year ,
 month (sale_date) as month ,
 avg(total_sale) as average_sales  from retail_sales
 group by  year(sale_date),month (sale_date)
 order by avg(total_sale) desc limit 2;

 -- top 5 customers based on total sales

 select  customer_id , gender , sum(total_sale) as total_salse from retail_sales
 group by customer_id , gender 
 order by sum(total_sale) desc limit 5;

 -- find unoque customers

 select category , count(distinct customer_id) as unique_customers  from retail_sales
 group by category ;

 -- form a seperate coloumn shift and no:of oeders (eg: morning shift <=12 , afternoon b/w 12 , evening >=17)

 with hourley_sales as (
 select * , CASE 
 when hour(sale_time) <12 then "morning"
 when hour(sale_time) between 12 and 14 then "afternoon"
 when hour(sale_time) between 15 and 17 then "evening"
 else "night"
 end as shift
 from retail_sales
 )
 select shift , count(*) as total_orders
 from hourley_sales 
 group by shift ;

 -- PEAK SASE HOUR IN WHICH HOUR DO YOU GET MAX SALSE 

 SELECT hour(sale_time) as Hour , count(*) as total_orders from retail_sales
 group by hour
 order by total_orders desc ;

 -- REVENUE CONTRIBUTION BY CATEGORY % which category contributes most of reveneue 

 select category , sum(total_sale) as Total_Salse,
ROUND(sum(total_Sale) * 100.0 / (select sum(total_sale) from retail_sales),2 )as percentage_toatl_sales from retaiL_sales
 group by category 
 order by Total_salse desc;

 -- finding repeated customers 

 select customer_id , count(*) as purchase_Count from retail_sales
 group by customer_id 
 having count(*)> 1
 order by purchase_Count desc ;

 -- CUSTOMER SEGMENTATION AS HIGH MEDIUM LOW BASED ON THEIIR PURCHASING 

 select  customer_id ,sum(total_sale) as total_amount_spend , CASE
 WHEN sum(total_sale) >2000 then "high value customer"
 when sum(total_sale) between 1000 and 2000 then "medium value customer"
 else "low value customer"
 end as customer_segmentation
from retail_sales
group by customer_id 
order by total_amount_spend desc;

-- running total to calculate cummulative sales over time using window function

select sale_date ,sum(total_sale) as daily_sales ,
sum(sum(total_sale)) over (order by sale_date) as running_total from retail_sales
group by sale_date;

 
 
 

