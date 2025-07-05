
CREATE TABLE retail_sales
		(
			transactions_id INT PRIMARY KEY,	
			sale_date	DATE,
			sale_time	TIME,
			customer_id	INT,
			gender	VARCHAR(15),
			age INT,
			category VARCHAR(15),	
			quantiy	INT,
			price_per_unit FLOAT,	
			cogs	FLOAT,
			total_sale FLOAT
		);

select * from retail_sales 
limit 10

select 
	count(*) 
from retail_sales

--to check if we have any null values
--DATA CLEANING
SELECT * FROM retail_sales
WHERE 
	   transactions_id IS NULL
	   OR
	   sale_date IS NULL
	   OR 
	   sale_time IS NULL
	   OR
	   customer_id IS NULL
	   OR
	   gender IS NULL
	   OR 
	   age IS NULL
	   OR 
	   category IS NULL
	   OR 	  
	   quantiy IS NULL
	   OR
	   price_per_unit IS NULL 
	   OR
	   cogs IS NULL
	   OR
	   total_sale IS NULL;

--Data Exploration

--How many sales we have?
select count(*) as total_sale from retail_sales

--How many unique customers we have?

select count(distinct customer_id) as total_customers from retail_sales 

--How many unique categories we have?
select count(distinct category) from retail_sales

select distinct category from retail_sales

--how many categories are there based on category name
select count(*) as no_of_categories,category as cat_name
from retail_sales
group by category

--Data Analysis
--Q.1 Write a SQL query to retrive all columns for sales made on 2022-11-05

select *
from retail_sales
where sale_date='2022-11-05';

--Q.2 Write a SQL query to retrieve all transactions where
--the category is 'Clothing' and the quantity sold is more than 2 in the month of Nov-2022

select *
from retail_sales
where category='Clothing'
	and 
	to_char(sale_date,'yyyy-mm')='2022-11'
	and 
	quantiy>2

--Q.3 Write a SQL query to calculate total sales for each category

select 
	category,
	SUM(total_sale) as net_sale,
	count(*) as total_orders
from retail_sales
group by category

--Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

select 
	round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'

--Q.5 Write a SQL query to find all trasactions where the total_sale is greater than 1000

select * from retail_sales
where total_sale > 1000

--Q.6 Write a SQL query to find total no of transactions made by each gender in each category

select 
	category,
	gender,
	count(*) as total_transactions
from retail_sales
group by category,gender
order by 1

--Q.7 Write a SQL query to calculate the average sale for each month. 
--Find out best selling month in each year.

select 
	extract (year from sale_date) as year,
	extract (month from sale_date) as month,
	avg(total_sale)
from retail_sales
group by 1, 2
order by 1, 3 desc


--to find out best selling month in each year
select
		year,
		month,
		avg_sale
from
(
	select 
		extract (year from sale_date) as year,
		extract (month from sale_date) as month,
		avg(total_sale) as avg_sale,
		rank() over(partition by extract (year from sale_date) order by avg(total_sale) desc)
	from retail_sales
	group by 1, 2
) as t1
where rank=1

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sale

select 
		customer_id,
		sum(total_sale)
from retail_sales
group by 1
order by 2 desc
limit 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select 
	category,
	count(distinct customer_id) as unique_customers
from retail_sales
group by 1

--Q.10 Write a SQL query to create each shift and number of orders (like mrng<=12 afternoon btw 12 and 17 eveng>17)

with hourly_sales
as(
	select *,
		case 
			when extract(hour from sale_time) < 12 then 'Morning'
			when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
			else 'Evening'
		end as shift
	from retail_sales
)
select 
	shift,
	count(*) as total_orders
from hourly_sales
group by shift


--END 