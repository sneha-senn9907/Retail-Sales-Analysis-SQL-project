--Database setup
create database Retail_sales_db
use Retail_sales_db
--Data imported
select * from Retail_sales 
--Data cleaning and exploration 
--Check for any null values in the dataset 
select * from Retail_sales 
where
	sale_date is null  or sale_time is null or 
	customer_id is null  or gender is null or 
	age is null  or category is null or
	quantity is null  or price_per_unit is null
	or cogs is null

--Delete records with missing data or null value.
delete from Retail_sales
where
    sale_date is null  or sale_time is null or 
	customer_id is null  or gender is null or 
	age is null  or category is null or
	quantity is null  or price_per_unit is null
	or cogs is null

--Determine the total number of records in the dataset.
select COUNT(*) from Retail_sales

--Find out how many unique customers are in the dataset.
select COUNT(distinct customer_id) from Retail_sales

--Identify all unique product categories in the dataset.
select distinct category from Retail_sales

--Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05'

select * from Retail_sales
	where sale_date='2022-11-05'

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than equal to 4 in the month of Nov-2022
select * from Retail_sales
	where category='Clothing' and quantity>=4 and datename(YYYY,sale_date)='2022' and DATENAME(MM,sale_date)='November'

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as Total_Sale from retail_sales 
	group by category

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select AVG(age) as Avg_age from Retail_sales 
	where category='Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from Retail_sales where total_sale>1000

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category,gender,COUNT(transactions_id) as Total_no_of_Transactions from Retail_sales
	group by category,gender

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
Select Avg_sale,Year,Month from
(
	select AVG(total_sale) As Avg_sale,
		   DATENAME(YYYY,sale_date) as Year,
		   DATENAME(MM,sale_date) as Month,
		   RANK() over(partition by DATENAME(YYYY,sale_date) order by avg(total_sale) desc) as rn
	from Retail_sales
	group by DATENAME(YYYY,sale_date),DATENAME(MM,sale_date)
) as T1 where rn=1

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select top(5) SUM(total_sale) as Total_sales,customer_id from Retail_sales 
	group by customer_id
	order by SUM(total_sale) desc

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select COUNT(distinct customer_id) as No_of_Customer,category from Retail_sales
	group by category

--Q.10 Write a SQL query to find the number of unique customers who purchased items from all category.
select COUNT(distinct customer_id) as number_of_customer
from Retail_sales
where customer_id in(
	select customer_id from Retail_sales
	group by customer_id 
	having COUNT(distinct category)=3
	)

-- Q.11 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select shift,count(*) as Number_Of_Orders from
(select total_sale,
    case
        when datepart(HOUR,sale_time) < 12 then 'Morning'
        when datepart(HOUR,sale_time) between 12 and 17 then 'Afternoon'
        else 'Evening'
    end as Shift
from Retail_sales
) as t2
group by Shift


----End of Project
