-- Which categories contribute the most to overall sales??

WITH category_sales AS(
SELECT 
      category,
      SUM(sales_amount) AS total_sales
      FROM gold_fact_sales f
      LEFT JOIN gold_dim_products p
      ON p.product_key = f.product_key
      GROUP BY category)
      
	SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER() AS overall_sales,
    CONCAT(ROUND((total_sales / SUM(total_sales) OVER()) * 100,2),"%") AS percentage_of_total
    FROM category_sales
    ORDER BY total_sales DESC;
    
    -- Segment products into cost ranges and count how many products fall into each segment
    
    WITH product_segment AS (
    SELECT 
          product_key,
          product_name,
          cost,
          CASE 
          WHEN cost < 100 THEN "Below 100"
          WHEN cost BETWEEN 100 AND 500 THEN "100-500"
          WHEN cost BETWEEN 500 AND 1000 THEN "500-1000"
          ELSE "Above 1000"
          END AS cost_range
          FROM gold_dim_products
          )
          
	SELECT 
          cost_range,
          COUNT(product_key) AS total_products
          FROM product_segment
          GROUP BY cost_range
          ORDER BY total_products DESC;
        
          /* Group customers into three segments based on their spending behaviour:
          - VIP - customers with at least 12 months of history and spending more than 5000
          - Regular - customers with at least 12 months of history and spending  5000 Or less
          - New - customers with at least 12 months 
          And find the total number of customers by each group */
          
          WITH customer_spending AS (
          SELECT 
                c.customer_key,
                SUM(f.sales_amount) AS total_spent,
				MIN(order_date) AS first_order,
                MAX(order_date) AS last_order,
                TIMESTAMPDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
                FROM gold_fact_sales f 
                LEFT JOIN gold_dim_customers c 
                ON f.customer_key = c.customer_key
                GROUP BY c.customer_key
                )
                
                SELECT 
                      customer_segment,
                      COUNT(customer_key) AS total_customers
                      FROM(
			SELECT 
                  customer_key,
				  CASE 
				  WHEN lifespan >= 12 AND total_spent >5000  THEN "VIP"
                  WHEN lifespan >= 12 AND total_spent <= 5000 THEN "Regular"
                  ELSE "New"
                  END AS customer_segment
                  FROM customer_spending)t 
                  GROUP BY customer_segment
                  ORDER BY total_customers DESC;
                  
                  
                  
-- 1. Base query : Retrieves core columns from tables

CREATE VIEW gold_customer_report AS
WITH base_query AS (

SELECT 
f.order_number,
f.product_key,
f.order_date,
f.sales_amount,
f.quantity,
c.customer_key,
c.customer_number,
concat(c.first_name, " ", c.last_name) AS customer_name,
timestampdiff(YEAR, c.birthdate, NOW()) AS Age
 FROM 
gold_fact_sales f 
LEFT JOIN gold_dim_customers c 
ON c.customer_key = f.customer_key
WHERE order_date IS NOT NULL
),

customer_aggregation AS (

SELECT
customer_key,
customer_number,
customer_name,
Age,
COUNT(DISTINCT order_number) AS total_orders,
SUM(sales_amount) AS total_sales,
SUM(quantity) AS total_quantity,
COUNT(DISTINCT product_key) AS total_products,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
customer_key,
customer_number,
customer_name,
age
)
SELECT
customer_key,
customer_number,
customer_name,
age,
CASE 
WHEN age<20 THEN "Under 20"
WHEN age BETWEEN 20 AND 29 THEN "20-29"
WHEN age BETWEEN 30 AND 39 THEN "30-39"
WHEN age BETWEEN 40 AND 49 THEN "40-49"
ELSE "50 and Above"
END AS age_group,

CASE 
	WHEN lifespan >= 12 AND total_sales > 5000  THEN "VIP"
	WHEN lifespan >= 12 AND total_sales <= 5000 THEN "Regular"
	ELSE "New"
	END AS customer_segment,
last_order_date,
timestampdiff(month, last_order_date, NOW()) AS recency,
total_orders,
total_sales,
total_quantity,
total_products,
-- compute average order value
CASE WHEN total_orders = 0 THEN 0
ELSE total_sales / total_orders 
END AS avg_order_value,
-- compute avg monthly spend
CASE
    WHEN lifespan = 0 THEN total_sales
    ELSE ROUND((total_sales/lifespan),0)
    END AS avg_monthly_spend
FROM customer_aggregation;
      
          
          
          
          
          
          
          
          
          
          
          
          
          