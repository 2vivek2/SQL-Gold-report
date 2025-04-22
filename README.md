🛍️ Gold Customer Analytics SQL Project
📊 Project Overview
This project showcases real-world SQL data analysis skills by diving into customer, sales, and product data for a retail business. It focuses on business-critical questions such as identifying top-performing product categories, customer segmentation, product pricing insights, and creating a unified customer report using advanced SQL techniques.

🧠 Problem Statements Solved
🔹 1. Which categories contribute the most to overall sales?
Using a window function (SUM() OVER()), the solution ranks product categories based on their sales contribution and calculates their percentage share in total revenue.

🔹 2. How are products distributed across different cost segments?
Products are bucketed into four cost-based ranges using a CASE statement to understand pricing distribution and stock segmentation.

🔹 3. How to segment customers based on their spending and tenure?
Customers are grouped into:

VIP: >12 months & spent > ₹5000

Regular: >12 months & spent ≤ ₹5000

New: <12 months
Using TIMESTAMPDIFF, customer behavior over time is analyzed.

🔹 4. Create a unified customer report view
A complete customer profile is generated, including:

Customer demographics

Sales performance

Recency and frequency

Average order value and monthly spend

Customer segments (VIP, Regular, New)

Age groups

The data is organized using CTEs (WITH), aggregated metrics, CASE statements for classification, and stored as a reusable SQL View: gold_customer_report.

🧰 Tools & Techniques Used
SQL (MySQL-compatible)

CTEs (Common Table Expressions)

Window Functions

Aggregation & Grouping

CASE-based Segmentation

Views Creation

Joins (LEFT JOIN)

📁 Folder Structure
pgsql
Copy
Edit
📦gold-customer-analytics-sql
 ┣ 📄 README.md
 ┣ 📄 gold_customer_analysis.sql
🚀 How to Use
Load your gold data tables:

gold_fact_sales

gold_dim_products

gold_dim_customers

Run each SQL block in the provided order.

Use the final CREATE VIEW statement to save a reusable customer analytics report.

🎯 Use Cases
Marketing Campaign Targeting (VIP customers)

Product Pricing Strategy

Business Performance Dashboards

Sales Forecasting Inputs

Customer Lifecycle Management


