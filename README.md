# PayPal Transaction Analytics: End-to-End SQL Case Study
📌 Project Overview

This project is an end-to-end SQL case study on a global digital payments platform (PayPal).
It demonstrates how to analyze transactions, merchants, users, currencies, and countries to generate actionable business insights.

The analysis covers:

Risk & Compliance – High-value transactions, international vs domestic transfers, regulatory checks

Merchant Insights – Top-performing merchants, performance scoring, monthly thresholds

User Behavior – High-value users, loyal/engaged customers, transaction patterns

Currency Exposure – Identifying FX risks and most-used currencies

Financial Reporting – Monthly/quarterly breakdowns, transaction classifications

🗂️ Database Schema

The database consists of the following tables:

countries – Country details

currencies – Currency codes

merchants – Merchant IDs and business details

transactions – Transaction details (IDs, amounts, currencies, sender, recipient, timestamps)

users – User details (IDs, emails, names, country_id)

🛠️ SQL Problems Solved

Top 5 countries by transaction amount (sent & received in Q4 2023)

Identify high-value transactions (> $10,000 in 2023)

Top 10 merchants by payments received (Nov 2023 – Apr 2024)

Currency conversion trends (22 May 2023 – 22 May 2024)

Transaction classification – High Value vs Regular (2023)

International vs Domestic transactions (Q1 2024)

High-value users – Avg. transaction > $5,000 (Nov 2023 – Apr 2024)

Monthly transaction report (2023)

Most valuable customer (May 2023 – May 2024)

Currency with highest exposure (last 1 year)

Most successful merchant (Nov 2023 – Apr 2024)

Transaction categorization – High/Regular & International/Domestic (2023)

Comprehensive monthly report – Value category + Location category (2023)

Merchant performance scoring (Nov 2023 – Apr 2024)

Consistently engaged users (≥6 active months, May 2023 – Apr 2024)

Merchant monthly performance – Exceeded or Not Exceeded $50,000 (Nov 2023 – Apr 2024)

📊 Insights & Outcomes

Top Sending & Receiving Countries → Identified leading transaction corridors.

High-Value Transactions → Highlighted for compliance monitoring.

Top Merchants → Ranked by total transaction amount received.

Currency Exposure → Euro dominated transaction volume (highest risk).

User Segmentation → Found high-value users & consistently engaged customers.

Performance Reports → Monthly and category-wise transaction breakdowns for finance team.

⚙️ Tech Stack

Database: MySQL

Language: SQL

Concepts Used:

Joins (INNER, SELF)

Aggregations (SUM, AVG, COUNT)

CTEs & Subqueries

CASE Statements (for classification & scoring)

Date Functions (YEAR, MONTH, DATE_FORMAT)

🚀 How to Use

Clone this repository

git clone https://github.com/your-username/paypal-sql-case-study.git
cd paypal-sql-case-study


Import the provided SQL schema and dataset into MySQL.

Run the queries from paypal_case_study.sql.

Explore insights or modify queries for further analysis.

🏆 Key Learning

This project strengthened my skills in:

Writing complex SQL queries for real-world business problems

Performing financial data analysis (risk, merchants, users, compliance)

Designing portfolio-ready case studies for data analytics

📌 Author

👤 Your Name

💼 LinkedIn

📂 Portfolio

✨ If you found this useful, give this repo a ⭐ on GitHub!
