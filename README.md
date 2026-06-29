# E-Commerce-Customer-Analytics
SQL analysis of  e-commerce transactions — revenue trends, churn &amp; RFM segmentation
## Dataset
250,000 transactions | 39,920 customers | 2020–2023

## Business Questions Answered
1. Which product categories generate the most revenue?
2. What are the most popular payment methods?
3. Who are the top 10 highest-value customers?
4. What is the return rate by product category?
5. How does purchasing behavior differ between churned and retained customers?
6. RFM segmentation: Who are Champions vs Lost customers?

## Key Findings
1. Revenue
•	Total revenue across all categories is evenly distributed — Home leads at $171.1M , followed closely by Clothing ($170.7M), Electronics ($170.1M), and Books ($169.3M).
•	Revenue was stable across 2020–2022 (~$184M/year) with a natural drop in 2023 as the dataset ends mid-year.
2. Returns
•	The overall return rate is around 50% across all product categories: consistent and unusually high, suggesting a potential issue with product quality or customer expectations that warrants further investigation.
•	No single category stands out as a significantly higher return risk.
Payment Methods
•	All three payment methods are used almost equally: Credit Card (33.4%), PayPal (33.4%), Cash (33.2%), indicating no strong customer preference.
3. Customers
•	Average customer makes 5 orders , with a maximum of 17 orders.
• There are 1,653 customers (3.3%) who are one-time buyers, representing the target customer group for re-engagement campaigns.
•	Customer base is almost perfectly split by gender: 50.23% Male / 49.77% Female .
•	Age ranges from 18–70 with a median age of 44 years .
4. Churn
•	9,929 customers have churned.
•	Churned customers tend to have fewer orders and higher return rates compared to retained customers (key indicators for an early warning model) .
5. RFM Segmentation
•	Using Recency, Frequency, and Monetary scores, customers are segmented into: Champion , Loyal , At Risk , and Lost — enabling targeted marketing strategies for each group.

## Tools
SQLite · DB Browser for SQLite
SQL techniques: GROUP BY , JOIN, CASE WHEN, Subqueries, CTEs ( WITH), Window Functions ( NTILE, OVER)

## Author
[Bao Chau Tran | Clara Tran] 
Bachelor of Business Informatics — University of Canberra
