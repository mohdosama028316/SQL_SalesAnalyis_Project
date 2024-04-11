CREATE TABLE Sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    VAT INT NOT NULL,
    total DECIMAL(12,4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment_method VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12,4) NOT NULL,
    rating FLOAT(2,1)
);
--------------------------------------------

-- Feature Enginnering--

-- TIME OF DATE
SELECT time,
(
	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN "Morning"
        ELSE "Evening"
END) AS time_of_date
 FROM sales;
 
 ALTER TABLE sales ADD COLUMN time_of_name VARCHAR(20);
 
 UPDATE sales
 SET time_of_name=(

	CASE 
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:00:00" AND "16:00:00" THEN "Morning"
        ELSE "Evening"
END
);
---------------------------------------------

-- DAY NAME
SELECT date , dayname(date) as day_name
		FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales 
	SET day_name=(
		dayname(date)
    );
    -------------------------------------
    
-- MONTH NAME
SELECT date,monthname(date) as month_name
	from sales;
ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales 
		SET month_name=(
			monthname(date)
        );
        
------------------------------------

-- EXPLORATERY DATA ANALYSIS (EDA)
-- _______________GENERIC_________________--

-- 1.How many unique cities does the data have?

select 
	distinct(city)
AS Unique_city from sales;

-- 2.In which city each branch?
select 
	distinct(branch)
AS Unique_city from sales;

select 
	distinct(city), branch
AS Unique_city from sales;

-- ____________PRODUCT RELATED QUESTION______________

-- 1.How many unique product lines does the data hava?
SELECT COUNT(distinct(product_line)) 
AS Product_lines
from sales;

-- 2.What is the most common payment method?
select 
 payment_method,
 count(payment_method) AS cnt
	from sales GROUP BY payment_method order by cnt desc;

-- 3.What is the most selling product line?

select 
	product_line ,
    count(product_line) as count
FROM sales group by product_line order by count desc;

-- 4.What is the total revenue by month?

SELECT month_name, SUM(total) AS revenue
FROM sales group by month_name order by revenue desc;

-- 5.What month had the largest COGS?

SELECT month_name, SUM(COGS) as Lst_cogs
FROM sales group by month_name order by Lst_cogs desc;

-- 6.What product line has the largest revenue?

SELECT product_line,SUM(total) AS revenue
FROM sales group by product_line order by revenue desc;

-- what city has the largest revenue?

SELECT branch,city, SUM(total) as revenue
FROM sales group by city,branch order by revenue desc;

-- What product line has the largest VAT?

SELECT product_line, AVG(VAT) as VAT
FROM sales group by product_line order by VAT DESC;

-- Which branch sold more products than average product sold?

SELECT branch,
	SUM(quantity) as qty
FROM sales 
group by branch 
having SUM(quantity)>(select AVG(quantity) FROM sales);

-- What is the most common product line by gender?

SELECT product_line, gender,count(gender) as cnt
FROM sales group by product_line,gender 
order by cnt desc;

-- What is the average rating of each product line?

SELECT product_line,
round(AVG(rating) ,2) AS Avg_rating
FROM sales group by product_line order by Avg_rating DESC;


-- ---------------------------------- --
-- -----------------Sales------------ --
 -- Number of sales made in each time of the day per weekday
 
 SELECT 
	time_of_name,
    COUNT(*) AS Total_sales
FROM sales
WHERE day_name="Sunday"
GROUP BY time_of_name
ORDER BY total_sales desc;

-- Which type of customer type brings most revenue?

SELECT customer_type,round(SUM(total),2) as Revenue 
FROM sales 
group by customer_type
order by Revenue desc;

-- WHich city has largest VAT(values added Tax)

SELECT City, round(AVG(VAT),2) as VAT
from sales
group by city
order by VAT desc;

-- Which customer type has most VAT

SELECT customer_type,round(AVG(VAT),2) as VAT 
FROM sales 
group by customer_type
order by VAT desc;


-- -------------------CUSTOMER----------------------
-- -------------------------------------------------

-- How many unique customer types does the data have?

SELECT distinct customer_type
from sales;

-- How many unique payment method does data have?

SELECT distinct payment_method
from sales;

-- What is the most common customer type?

SELECT customer_type,COUNT(Customer_type) CNT
from sales
group by customer_type
order by CNT desc;

-- What id the gender of most of the customer;

SELECT gender,COUNT(*) as CNT 
FROM sales group by gender
order by CNT desc;

-- What id the gender of each specifoc bracnch?

SELECT branch, gender, COUNT(*) as gender_count
FROM sales 
group by branch,gender;

-- Which time of the day customer give most rating?

SELECT time_of_name ,ROUND(AVG(rating),2) as avg_rating
FROM sales
group by time_of_name order by avg_rating desc;

-- Which time of day do customer give most rating per branch?

SELECT time_of_name,branch ,ROUND(AVG(rating),2) as avg_rating
FROM sales
Where branch="A"
group by time_of_name order by avg_rating desc;

-- Which day of the week has the best avg rating?

SELECT day_name ,ROUND(AVG(rating),2) as avg_rating
FROM sales
group by day_name order by avg_rating desc;

-- Which day of the week has the best avg rating per branch?


SELECT day_name,branch ,ROUND(AVG(rating),2) as avg_rating
FROM sales
Where branch="A"
group by day_name order by avg_rating desc;