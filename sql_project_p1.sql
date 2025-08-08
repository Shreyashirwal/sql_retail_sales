-- create table
CREATE TABLE retail_sales 
(
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id INT,
	gender VARCHAR(15),
	age INT,
	category VARCHAR(15),
	quantity INT,
	price_per_unit FLOAT,
	cogs FLOAT,
	total_sale FLOAT
);

--Data cleaning
SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*) 
FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id is NULL

SELECT * FROM retail_sales
WHERE 
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR 
	gender is NULL
	OR 
	category is NULL
	OR
	quantity is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL

--delete rows
DELETE FROM retail_sales
WHERE
	transactions_id is NULL
	OR
	sale_date is NULL
	OR
	sale_time is NULL
	OR 
	gender is NULL
	OR 
	category is NULL
	OR
	quantity is NULL
	OR
	cogs is NULL
	OR
	total_sale is NULL

--Data exploration

--How many sales we have?
SELECT 
	COUNT(*) 
FROM retail_sales;

--How many customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale 

SELECT DISTINCT category FROM retail_sales

--Data analysis & business Key problems and answers

--Q.1 Write a sql query to retrieve all columns for sales made on '2022-11-8'
SELECT  *
FROM retail_sales
WHERE sale_date = '2022-11-05';

--Q.2 Write a sql query to retrieve all transactions where the category is "clothing" and the quantity sold is more than or equal to 4 in the month of Nov-2022
SELECT 
	*
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date,'YYYY-MM') = '2022-11'
	AND
	quantity >= 4

--Q.3 Write a sql query to calculate the total sales(total_sales) for each category
SELECT 
	category, 
	SUM (total_sale) as net_sale,
	COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1

--Q.4 Write a sql query to find the average age of customers who purchased items from the "beauty" category
SELECT 
	ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--Q.5 Write a SQL query to find all transactions where total_sale is greater than 1000
SELECT 
	*
FROM retail_sales
WHERE total_sale > 1000

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT 
	category,
	gender,
	COUNT(transactions_id) as TOTAL
FROM retail_sales
GROUP 
	BY
	category,
	gender

--Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT year,month,avg_sale FROM
(
	SELECT 
	    year,
	    month,
	    avg_sale,
	    RANK() OVER (
	        PARTITION BY year
	        ORDER BY avg_sale DESC
	    ) AS rank_in_year
	FROM (
	    SELECT 
	        EXTRACT(YEAR FROM sale_date) AS year,
	        EXTRACT(MONTH FROM sale_date) AS month,
	        AVG(total_sale) AS avg_sale
	    FROM retail_sales
	    GROUP BY 1, 2
	) AS monthly_sales
)
WHERE rank_in_year = 1;


--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT 
	customer_id, 
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
SELECT 
	category,
	COUNT(DISTINCT customer_id) AS UNIQUE_CUSTOMERS
FROM retail_sales
GROUP BY category

--Q.10 Write a SQL query to create each shift and number of orders (Example morning <= 12 , Afternoon between 12 & 17, Evening > 17)
WITH HOURLY_SALE 
AS
(
	SELECT * ,
		CASE
			WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'MORNING'
			WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
			ELSE 'EVENING'
		END AS shift
	FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) AS TOTAL_ORDERS 
FROM HOURLY_SALE
GROUP BY shift 