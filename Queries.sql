SQL Query
-- Verify gender split
SELECT Gender,
       COUNT(DISTINCT "Customer ID") AS customer_count,
       ROUND(COUNT(DISTINCT "Customer ID") * 100.0 / 
             (SELECT COUNT(DISTINCT "Customer ID") FROM ecommerce_customer_data_large), 2) AS percentage
FROM ecommerce_customer_data_large
GROUP BY Gender;

-- Verify age stats
SELECT 
    MIN("Customer Age") AS min_age,
    MAX("Customer Age") AS max_age,
    ROUND(AVG("Customer Age"), 1) AS avg_age
FROM ecommerce_customer_data_large;

Question 1:
-- Q1: Total revenue by each category
SELECT "Product Category",
       COUNT(*) AS total_orders,
       ROUND(SUM("Total Purchase Amount"), 2) AS total_revenue,
       ROUND(AVG("Total Purchase Amount"), 2) AS avg_order_value
FROM ecommerce_customer_data_large
GROUP BY "Product Category"
ORDER BY total_revenue DESC;

Question 2:
-- Q2: Payment method usage
SELECT "Payment Method",
       COUNT(*) AS usage_count,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ecommerce_customer_data_large), 2) AS percentage
FROM ecommerce_customer_data_large
GROUP BY "Payment Method"
ORDER BY usage_count DESC;

Question 3:
-- Q3: Customer distribution by age
SELECT 
    CASE 
        WHEN Age BETWEEN 18 AND 29 THEN '18-29'
        WHEN Age BETWEEN 30 AND 39 THEN '30-39'
        WHEN Age BETWEEN 40 AND 49 THEN '40-49'
        WHEN Age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,
    COUNT(DISTINCT "Customer ID") AS customer_count
FROM ecommerce_customer_data_large
GROUP BY age_group
ORDER BY age_group

Question 4:
-- Q4: Top 10 customers by total spending
SELECT "Customer ID",
       "Customer Name",
       COUNT(*) AS total_orders,
       ROUND(SUM("Total Purchase Amount"), 2) AS lifetime_value
FROM ecommerce_customer_data_large
GROUP BY "Customer ID", "Customer Name"
ORDER BY lifetime_value DESC
LIMIT 10;

Question 5:
-- Q5: Revenue by year and month (trend analysis)
SELECT 
    SUBSTR("Purchase Date", 1, 4) AS year,
    SUBSTR("Purchase Date", 6, 2) AS month,
    ROUND(SUM("Total Purchase Amount"), 2) AS monthly_revenue,
    COUNT(*) AS total_orders
FROM ecommerce_customer_data_large
GROUP BY year, month
ORDER BY year, month;

Question 6:
-- Q6: Return rate by product category
SELECT "Product Category",
       COUNT(*) AS total_orders,
       SUM(CASE WHEN "Returns" = 1.0 THEN 1 ELSE 0 END) AS returned_orders,
       ROUND(SUM(CASE WHEN "Returns" = 1.0 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS return_rate
FROM ecommerce_customer_data_large
WHERE "Returns" IS NOT NULL
GROUP BY "Product Category"
ORDER BY return_rate DESC;

Question 7:
-- Q7: Caculating one-time buyers
SELECT COUNT(*) AS one_time_buyers,
       ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT "Customer ID") FROM ecommerce_customer_data_large), 2) AS percentage
FROM (
    SELECT "Customer ID"
    FROM ecommerce_customer_data_large
    GROUP BY "Customer ID"
    HAVING COUNT(*) = 1
);

Question 8:
-- Q8: Compare the purchasing behavior between churned vs non-churned customers
WITH customer_stats AS (
    SELECT "Customer ID",
           churn,
           COUNT(*) AS total_orders,
           ROUND(AVG("Total Purchase Amount"), 2) AS avg_order_value,
           ROUND(SUM("Total Purchase Amount"), 2) AS total_spent,
           SUM(CASE WHEN Returns = 1.0 THEN 1 ELSE 0 END) AS total_returns
    FROM ecommerce_customer_data_large
    GROUP BY "Customer ID", Churn
)
SELECT Churn,
       COUNT(*) AS customer_count,
       ROUND(AVG(total_orders), 2) AS avg_orders,
       ROUND(AVG(avg_order_value), 2) AS avg_order_value,
       ROUND(AVG(total_spent), 2) AS avg_lifetime_value,
       ROUND(AVG(total_returns), 2) AS avg_returns
FROM customer_stats
GROUP BY Churn;

Question 9:
-- Q9: RFM Analysis (Recency, Frequency, Monetary)
WITH rfm AS (
    SELECT "Customer ID",
           "Customer Name",
           MAX("Purchase Date") AS last_purchase,
           COUNT(*) AS frequency,
           ROUND(SUM("Total Purchase Amount"), 2) AS monetary
    FROM ecommerce_customer_data_large
    GROUP BY "Customer ID", "Customer Name"
),
rfm_scored AS (
    SELECT *,
           NTILE(4) OVER (ORDER BY last_purchase DESC) AS recency_score,
           NTILE(4) OVER (ORDER BY frequency DESC) AS frequency_score,
           NTILE(4) OVER (ORDER BY monetary DESC) AS monetary_score
    FROM rfm
)
SELECT "Customer ID", "Customer Name",
       recency_score, frequency_score, monetary_score,
       (recency_score + frequency_score + monetary_score) AS rfm_total,
       CASE 
           WHEN (recency_score + frequency_score + monetary_score) >= 10 THEN 'Champion'
           WHEN (recency_score + frequency_score + monetary_score) >= 7 THEN 'Loyal'
           WHEN (recency_score + frequency_score + monetary_score) >= 5 THEN 'At Risk'
           ELSE 'Lost'
       END AS customer_segment
FROM rfm_scored
ORDER BY rfm_total DESC;

