-- 1. Database Setup
create database p1_retail_db;

drop table if exists retail_sales;
create table retail_sales
(
 transactions_id int primary key,
 sale_date date,
 sale_time time,
 customer_id int,
 gender varchar(10),
 age int,
 category varchar(20),
 quantity int,
 price_per_unit float,
 cogs float,
 total_sale float
);

-- One of the way to import a csv file 
copy retail_sales(transactions_id,sale_date,sale_time,customer_id,gender,age,category,quantity,price_per_unit,cogs,total_sale
)
from 'C:\Imarticus\SQL\Project\Retail_Sales_Analysis\SQL - Retail Sales Analysis_utf .csv'
delimiter ','
csv header;

select * from retail_sales limit 5;

-- 2.Data Exploration and Cleaning
-- Count of records in the table
select count(*) from retail_sales;

--Count of distinct customers:
select count(distinct customer_id) from retail_sales;

-- Count of distict categories:
select distinct category from retail_sales;

--Check for any null values in the dataset and delete records with missing data.
select * from retail_sales
where 
     sale_date is null or sale_time is null or customer_id is null or
	 gender is null or age is null or category is null or 
	 quantity is null or price_per_unit is null or cogs is null;

delete from retail_sales
where 
     sale_date is null or sale_time is null or customer_id is null or
	 gender is null or age is null or category is null or 
	 quantity is null or price_per_unit is null or cogs is null;

-- 3.Data Analysis and Findings:
-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05':
select * from retail_sales 
where sale_date='2022-11-05';

-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
select * from retail_sales 
where category='Clothing' and 
      quantity >=  4 and 
	  TO_CHAR(sale_date,'YYYY-MM')='2022-11';
	  
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
select category,sum(total_sale) as est_sale,count(total_sale) as total_orders
from retail_sales
group by category;

-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),2) as avg_age
from retail_sales 
where category='Beauty';

-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
select * from retail_sales
where total_sale>1000;

-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category,gender,count(transactions_id) as trans_count
from retail_sales
group by category,gender
order by category,gender;

-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
select year,month,avg_sale
from (
   select 
      extract(year from sale_date)as year,
	  extract(month from sale_date) as month,
	  round(cast(avg(total_sale) as numeric),2) as avg_sale,
	  dense_rank() over(partition by extract(YEAR from sale_date) order by round(avg(total_sale)) desc) as rank
	  from retail_sales
	  group by 1,2) as t1
      where rank=1;

-- 8.Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id,sum(total_sale) as total_sales
from retail_sales
group by 1
order by 2 desc
limit 5;

-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.
select category,count(distinct customer_id) as cnt_unique_cs
from retail_sales
group by category;

-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
with hourly_sale
as 
(select *,
     case
	     when extract(hour from sale_time)<12 then 'Morning'
		 when extract(hour from sale_time) between 12 and 17 then 'Afternoon'
		 else 'Evening'
	  end as shift
 from retail_sales
)
select  
     shift,count(*) as total_orders
	 from hourly_sale
	 group by shift;














