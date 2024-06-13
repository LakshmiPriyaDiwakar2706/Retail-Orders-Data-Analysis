-- Loaded the transformed data to retail_orders table.

SELECT * FROM retail_orders;

ALTER TABLE retail_orders
ALTER COLUMN order_id SET DATA TYPE int,
ALTER COLUMN postal_code SET DATA TYPE int,
ALTER COLUMN quantity SET DATA TYPE int,
ALTER COLUMN ship_mode SET DATA TYPE varchar(30),
ALTER COLUMN segment SET DATA TYPE varchar(30),
ALTER COLUMN country SET DATA TYPE varchar(30),
ALTER COLUMN city SET DATA TYPE varchar(30),
ALTER COLUMN state SET DATA TYPE varchar(30),
ALTER COLUMN region SET DATA TYPE varchar(30),
ALTER COLUMN product_id SET DATA TYPE varchar(30),
ALTER COLUMN discount SET DATA TYPE numeric,
ALTER COLUMN sales_price SET DATA TYPE numeric,
ALTER COLUMN profit SET DATA TYPE numeric;
ALTER TABLE retail_orders ALTER COLUMN order_date SET DATA TYPE date;

-- Creating indexes for columns which I think would be used in filtering clauses a lot.

CREATE INDEX prod_id_indx ON retail_orders(product_id);
CREATE INDEX region_indx ON retail_orders(region);
CREATE INDEX cat_indx ON retail_orders(category);
CREATE INDEX orderdate_indx ON retail_orders(order_date);

-- Viewing the entire table 
SELECT * FROM retail_orders;

-- Our retail_orders table contains products sold in the years 2022 and 2023

-- 1. Which products have generated the highest revenue in the past two years (2022 and 2023)?


SELECT  product_id,
       ROUND(SUM(sales_price),2) AS total_revenue_generated
FROM retail_orders
GROUP BY  product_id
ORDER BY  total_revenue_generated DESC
LIMIT 10;

SELECT category, product_id,
       ROUND(SUM(sales_price),2) AS total_revenue_generated
FROM retail_orders
GROUP BY category, product_id
ORDER BY  total_revenue_generated DESC
LIMIT 10;


-- 2. What are the top 5 highest selling products in each region over the past two years?
SELECT *
FROM (
	  SELECT region, product_id, 
	  SUM(sales_price) AS tot_sales_price, 
	  ROW_NUMBER()OVER(PARTITION BY region ORDER BY SUM(sales_price) DESC) AS rank
      FROM retail_orders
	  GROUP BY region, product_id ) AS product_ranks
WHERE rank < 6;


-- 3. How does our monthly sales growth compare between 2022 and 2023?
sales_2022 AS(
      SELECT  TO_CHAR(order_date, 'yyyy-mm') AS year_month,
	  	      SUM(sales_price) AS sales_ym_2022
      FROM retail_orders
      WHERE TO_CHAR(order_date, 'yyyy-mm') LIKE '2022%'
      GROUP BY year_month
      ORDER BY year_month ASC),

sales_2023 AS(
      SELECT  TO_CHAR(order_date, 'yyyy-mm') AS year_month,
	  	      SUM(sales_price) AS sales_ym_2023
      FROM retail_orders
      WHERE TO_CHAR(order_date, 'yyyy-mm') LIKE '2023%'
      GROUP BY year_month
      ORDER BY year_month ASC)

SELECT EXTRACT(MONTH FROM  TO_DATE(s1.year_month,'yyyy-mm')) AS month_num, sales_ym_2022,sales_ym_2023
FROM sales_2022 s1 LEFT JOIN sales_2023 s2
ON s1.year_month = TO_CHAR((TO_DATE(s2.year_month,'yyyy-mm')-INTERVAL '1 year'),'yyyy-mm');

-- 4. What are the highest selling months for each product category?

SELECT category, year_month, total_sales
FROM (SELECT category,
	         TO_CHAR(order_date, 'yyyy-mm') AS year_month, 
	         SUM(sales_price) AS total_sales,
	         RANK() OVER (PARTITION BY category ORDER BY SUM(sales_price) DESC)
      FROM retail_orders
      GROUP BY category, year_month
      ORDER BY category, total_sales DESC)
WHERE rank = 1


-- 5. Which category dominated sales for each month in each year?

WITH 
category_sales_2022 AS (
       SELECT  EXTRACT(MONTH FROM order_date) AS month,
               category, 
               SUM(sales_price) AS total_sales,
               RANK() OVER (PARTITION BY EXTRACT(MONTH FROM order_date) ORDER BY SUM(sales_price) DESC) AS rank
       FROM retail_orders
       WHERE EXTRACT(YEAR FROM order_date) = 2022
       GROUP BY month, category
),
category_sales_2023 AS (
       SELECT  EXTRACT(MONTH FROM order_date) AS month,
               category, 
               SUM(sales_price) AS total_sales,
               RANK() OVER (PARTITION BY EXTRACT(MONTH FROM order_date) ORDER BY SUM(sales_price) DESC) AS rank
       FROM retail_orders
       WHERE EXTRACT(YEAR FROM order_date) = 2023
       GROUP BY month, category
)
SELECT DISTINCT((COALESCE(cs22.month, cs23.month))) AS month,
    cs22.category AS category_2022,
    cs22.total_sales AS total_sales_2022,
    cs23.category AS category_2023,
    cs23.total_sales AS total_sales_2023
FROM category_sales_2022 cs22 
FULL OUTER JOIN category_sales_2023 cs23
ON cs22.month = cs23.month
WHERE cs22.rank = 1 AND cs23.rank = 1
ORDER BY month;


-- 6. Which sub-category (top 5) experienced the highest profit growth in 2023 compared to 2022?

WITH 
sub_category_2022 AS (
	SELECT sub_category, ROUND(SUM(profit),2) AS total_profit_2022
	FROM retail_orders
	WHERE ((EXTRACT (YEAR FROM order_date)) :: text) LIKE '2022%'
	GROUP BY sub_category
),
sub_category_2023 AS (
	SELECT sub_category, ROUND(SUM(profit),2) AS total_profit_2023
	FROM retail_orders
	WHERE ((EXTRACT (YEAR FROM order_date)) :: text) LIKE '2023%'
	GROUP BY sub_category
)

SELECT sub_category, total_profit_2022, total_profit_2023
FROM sub_category_2023 LEFT JOIN sub_category_2022
USING (sub_category)
WHERE total_profit_2023 > total_profit_2022
ORDER BY total_profit_2023 DESC
LIMIT 5;

-- 7. Which sub-category (top 5) had the highest growth percentage in sales in 2023 compared to 2022?

WITH 
sub_category_2022 AS (
	SELECT sub_category, ROUND(SUM(sales_price),2) AS total_sales_2022
	FROM retail_orders
	WHERE ((EXTRACT (YEAR FROM order_date)) :: text) LIKE '2022%'
	GROUP BY sub_category
),
sub_category_2023 AS (
	SELECT sub_category, ROUND(SUM(sales_price),2) AS total_sales_2023
	FROM retail_orders
	WHERE ((EXTRACT (YEAR FROM order_date)) :: text) LIKE '2023%'
	GROUP BY sub_category
)

SELECT s1.sub_category, 
	   s2.total_sales_2022,
	   s1.total_sales_2023,
	   ROUND(((total_sales_2023 - total_sales_2022)/total_sales_2022) * 100, 0)  AS growth_percent
FROM sub_category_2023 s1 LEFT JOIN sub_category_2022 s2
USING (sub_category)
ORDER BY growth_percent DESC
LIMIT 5;





 






