
Retail Sales Analysis Using SQL

This project focuses on analyzing retail sales data through structured queries. The goal is to simulate tasks a junior data analyst might perform, including setting up a relational database, conducting basic data cleaning, and extracting actionable insights using SQL. The project is ideal for those aiming to build foundational data querying skills while understanding business metrics.

Project Goals
1. Create a Retail Sales Database: Initialize and populate a database to store retail transactions.
2. Clean Raw Data: Identify incomplete records and remove them to ensure clean data for analysis.
3. Explore Data Features: Conduct exploratory analysis to understand the dataset's structure and content.
4. Generate Business Insights: Use SQL to answer real-world business questions related to retail operations.

Project Workflow
-- Database Initialization
Start by creating a new database and defining the schema for the sales records.

CREATE DATABASE p1_retail_sale;

CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Data Cleaning 
Perform a series of checks to understand the quality and composition of the dataset:

* Total Rows:
SELECT COUNT(*) FROM retail_sales;

* Distinct Customers:
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

* Product Categories:
SELECT DISTINCT category FROM retail_sales;

* Missing Data Check:
SELECT * FROM retail_sales
WHERE sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL;

* Delete Incomplete Records:
DELETE FROM retail_sales
WHERE sale_date IS NULL 
   OR sale_time IS NULL 
   OR customer_id IS NULL 
   OR gender IS NULL 
   OR age IS NULL 
   OR category IS NULL 
   OR quantity IS NULL 
   OR price_per_unit IS NULL 
   OR cogs IS NULL;

-- Data analysis 
Below are queries used to derive insights from the sales dataset:

1. All sales from November 5, 2022:
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

2. Clothing transactions with quantity > 4 during November 2022:
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;

3. Total sales and order count per product category:
SELECT 
    category, 
    SUM(total_sale) AS total_revenue,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY category;

4. Average age of customers buying Beauty products:
SELECT 
    ROUND(AVG(age), 2) AS avg_customer_age
FROM retail_sales
WHERE category = 'Beauty';

5. Transactions with sales exceeding 1000 units:
SELECT * 
FROM retail_sales 
WHERE total_sale > 1000;

6. Total transactions by gender within each category:
SELECT 
    category,
    gender,
    COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

7. Identify top-performing months by average sales per year:
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year,
        EXTRACT(MONTH FROM sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS ranked_months
WHERE rank = 1;

8. Top 5 customers based on total spending:
SELECT 
    customer_id, 
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

9. Number of unique customers per product category:
SELECT 
    category, 
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

10. Classify sales by shift (Morning, Afternoon, Evening) and count orders:
WITH shift_classification AS (
    SELECT *,
        CASE 
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift, 
    COUNT(*) AS order_count
FROM shift_classification
GROUP BY shift;

Key Insights
* Customer Profile: Shoppers represent diverse age groups and gender distributions, actively purchasing across multiple categories.
* Revenue Highlights: High-value purchases (above 1000) signal luxury or bulk buyers.
* Time-Based Patterns: Certain months show stronger average sales, which can inform seasonal marketing strategies.
* Loyalty Indicators: High-spending customers and repeat buyers by category suggest targets for loyalty programs.
* Shift Distribution: Morning and afternoon shifts receive significant traffic, useful for staffing and promotion scheduling.

Results 
* Sales Dashboard Summary: Total revenue, product category performance, and customer engagement.
* Time-Series Analysis: Sales trends by month and time of day.
* Customer Segmentation: Spend patterns by customer ID and demographic breakdowns.

Conclusion
This project provides a structured approach to learning SQL within a business context. From data modeling to answering stakeholder-driven questions, the hands-on experience reinforces analytical thinking and practical SQL skills. Whether used for portfolio building or interview prep, this project offers a solid foundation in data analysis.


