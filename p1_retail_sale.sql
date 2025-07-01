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

-- Total Rows:
SELECT COUNT(*) FROM retail_sales;

-- Distinct Customers:
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

-- Product Categories:
SELECT DISTINCT category FROM retail_sales;

-- Missing Data Check:
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
   
-- Delete Incomplete Records:
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

-- Q1. All sales from November 5, 2022:
SELECT * 
FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q2. Clothing transactions with quantity > 4 during November 2022:
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
  AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
  AND quantity > 4;

-- Q3. Total sales and order count per product category:
SELECT 
    category, 
    SUM(total_sale) AS total_revenue,
    COUNT(*) AS order_count
FROM retail_sales
GROUP BY category;

-- Q4. Average age of customers buying Beauty products:
SELECT 
    ROUND(AVG(age), 2) AS avg_customer_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5. Transactions with sales exceeding 1000 units:
SELECT * 
FROM retail_sales 
WHERE total_sale > 1000;

-- Q6. Total transactions by gender within each category:
SELECT 
    category,
    gender,
    COUNT(*) AS transaction_count
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7. Identify top-performing months by average sales per year:
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

-- Q8. Top 5 customers based on total spending:
SELECT 
    customer_id, 
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- Q9. Number of unique customers per product category:
SELECT 
    category, 
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10. Classify sales by shift (Morning, Afternoon, Evening) and count orders:
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

