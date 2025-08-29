
USE paypal;

-- Preview the tables
SELECT * FROM countries;
SELECT * FROM currencies;
SELECT * FROM merchants;
SELECT * FROM transactions;
SELECT * FROM users;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 1. Problem Statement
Determine the top 5 countries by total transaction amount for both sending and receiving funds 
in the last quarter of 2023 (October to December 2023). 
Provide separate lists for the countries that sent the most funds and those that received the most funds. 
Round totals to 2 decimal places. */

-- Top 5 sending countries
SELECT c.country_name, ROUND(SUM(t.transaction_amount),2) AS total_sent
FROM transactions t
JOIN users u ON t.sender_id = u.user_id
JOIN countries c ON u.country_id = c.country_id
WHERE t.transaction_date BETWEEN '2023-10-01' AND '2024-01-01'
GROUP BY c.country_name
ORDER BY total_sent DESC
LIMIT 5;

-- Top 5 receiving countries
SELECT c.country_name, ROUND(SUM(t.transaction_amount),2) AS total_received
FROM transactions t
JOIN users u ON t.recipient_id = u.user_id
JOIN countries c ON u.country_id = c.country_id
WHERE t.transaction_date BETWEEN '2023-10-01' AND '2024-01-01'
GROUP BY c.country_name
ORDER BY total_received DESC
LIMIT 5;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 2. Problem Statement
Identify high-value transactions exceeding $10,000 in the year 2023.
Include transaction ID, sender ID, recipient ID, amount, and currency. */

SELECT transaction_id, sender_id, recipient_id, transaction_amount, currency_code
FROM transactions
WHERE transaction_amount > 10000
AND YEAR(transaction_date) = 2023;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 3. Problem Statement
Find the top 10 merchants by total transaction amount received between 
November 2023 and April 2024. 
Provide merchant ID, business name, total received, and average transaction. */

SELECT m.merchant_id, m.business_name,
       SUM(t.transaction_amount) AS total_received,
       AVG(t.transaction_amount) AS average_transaction
FROM transactions t
JOIN merchants m ON m.merchant_id = t.recipient_id
WHERE t.transaction_date >= '2023-11-01'
  AND t.transaction_date < '2024-05-01'
GROUP BY m.merchant_id, m.business_name
ORDER BY total_received DESC
LIMIT 10;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 4. Problem Statement
Analyze currency conversion trends from 22 May 2023 to 22 May 2024.
Show total converted amount for each currency. Display top 3 currencies. */

SELECT currency_code, SUM(transaction_amount) AS total_converted
FROM transactions
WHERE transaction_date >= '2023-05-22'
  AND transaction_date < '2024-05-22'
GROUP BY currency_code
ORDER BY total_converted DESC
LIMIT 3;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 5. Problem Statement
Categorize transactions in 2023 as 'High Value' (> $10,000) or 'Regular' (< $10,000).
Calculate total amount for each category. */

SELECT transaction_category, SUM(transaction_amount) AS total_amount
FROM (
  SELECT transaction_amount,
         CASE 
           WHEN transaction_amount > 10000 THEN 'High Value'
           ELSE 'Regular'
         END AS transaction_category
  FROM transactions
  WHERE YEAR(transaction_date) = 2023
) t
GROUP BY transaction_category
ORDER BY total_amount DESC;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 6. Problem Statement
Classify transactions in Q1 2024 (Jan–Mar) as 'Domestic' or 'International'. 
Provide a count of each type. */

WITH cte AS (
  SELECT t.sender_id, u1.country_id AS sender_country,
         t.recipient_id, u2.country_id AS receiver_country
  FROM transactions t
  JOIN users u1 ON t.sender_id = u1.user_id
  JOIN users u2 ON t.recipient_id = u2.user_id
  WHERE t.transaction_date >= '2024-01-01'
    AND t.transaction_date < '2024-04-01'
)
SELECT CASE 
         WHEN sender_country = receiver_country THEN 'Domestic'
         ELSE 'International'
       END AS transaction_type,
       COUNT(*) AS transaction_count
FROM cte
GROUP BY transaction_type
ORDER BY transaction_count DESC;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 7. Problem Statement
Find users with average transaction amount > $5,000 between Nov 2023 and Apr 2024. */

WITH avg_transaction AS (
  SELECT sender_id, AVG(transaction_amount) AS avg_amount
  FROM transactions
  WHERE transaction_date >= '2023-11-01'
    AND transaction_date < '2024-05-01'
  GROUP BY sender_id
)
SELECT u.user_id, u.email, a.avg_amount
FROM avg_transaction a
JOIN users u ON a.sender_id = u.user_id
WHERE a.avg_amount > 5000;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 8. Problem Statement
Generate monthly total transaction reports for 2023. */

SELECT YEAR(transaction_date) AS transaction_year,
       MONTH(transaction_date) AS transaction_month,
       SUM(transaction_amount) AS total_amount
FROM transactions
WHERE YEAR(transaction_date) = 2023
GROUP BY transaction_year, transaction_month
ORDER BY transaction_month;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 9. Problem Statement
Find the most valuable customer between 22 May 2023 and 22 May 2024. */

SELECT u.user_id, u.name, u.email, t.total_amount
FROM users u
JOIN (
  SELECT sender_id, SUM(transaction_amount) AS total_amount
  FROM transactions
  WHERE transaction_date > '2023-05-22'
    AND transaction_date <= '2024-05-22'
  GROUP BY sender_id
  ORDER BY total_amount DESC
  LIMIT 1
) t ON u.user_id = t.sender_id;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 10. Problem Statement
Which currency had the highest transaction amount from 22 May 2023 to 22 May 2024? */

SELECT currency_code, SUM(transaction_amount) AS currency_sum
FROM transactions
WHERE transaction_date >= '2023-05-22'
  AND transaction_date < '2024-05-23'
GROUP BY currency_code
ORDER BY currency_sum DESC
LIMIT 1;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 11. Problem Statement
Which merchant is the most successful (highest total amount received) between Nov 2023 and Apr 2024? */

SELECT m.merchant_id, m.business_name,
       SUM(t.transaction_amount) AS total_amount,
       AVG(t.transaction_amount) AS avg_amount
FROM transactions t
JOIN merchants m ON m.merchant_id = t.recipient_id
WHERE transaction_date >= '2023-11-01'
  AND transaction_date < '2024-05-01'
GROUP BY m.merchant_id, m.business_name
ORDER BY total_amount DESC
LIMIT 1;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 12. Problem Statement
Categorize 2023 transactions into:
- High Value International
- High Value Domestic
- Regular International
- Regular Domestic 
Count number of transactions in each category. */

WITH cte AS (
  SELECT t.transaction_date, t.sender_id, u1.country_id AS sender_country,
         t.recipient_id, u2.country_id AS receiver_country, t.transaction_amount
  FROM transactions t
  JOIN users u1 ON t.sender_id = u1.user_id
  JOIN users u2 ON t.recipient_id = u2.user_id
  WHERE YEAR(t.transaction_date) = 2023
)
SELECT CASE 
         WHEN sender_country <> receiver_country AND transaction_amount > 10000 THEN 'High Value International'
         WHEN sender_country = receiver_country AND transaction_amount > 10000 THEN 'High Value Domestic'
         WHEN sender_country <> receiver_country AND transaction_amount <= 10000 THEN 'Regular International'
         ELSE 'Regular Domestic'
       END AS transaction_category,
       COUNT(*) AS transaction_count
FROM cte
GROUP BY transaction_category;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 13. Problem Statement
Provide a 2023 monthly report grouping by:
- High Value / Regular
- Domestic / International
Show total + average amount. */

WITH cte AS (
  SELECT t.transaction_date, t.sender_id, u1.country_id AS sender_country,
         t.recipient_id, u2.country_id AS receiver_country, t.transaction_amount
  FROM transactions t
  JOIN users u1 ON t.sender_id = u1.user_id
  JOIN users u2 ON t.recipient_id = u2.user_id
  WHERE YEAR(t.transaction_date) = 2023
)
SELECT YEAR(transaction_date) AS transaction_year,
       MONTH(transaction_date) AS transaction_month,
       CASE WHEN transaction_amount > 10000 THEN 'High Value' ELSE 'Regular' END AS value_category,
       CASE WHEN sender_country = receiver_country THEN 'Domestic' ELSE 'International' END AS location_category,
       SUM(transaction_amount) AS total_amount,
       AVG(transaction_amount) AS average_amount
FROM cte
GROUP BY transaction_year, transaction_month, value_category, location_category
ORDER BY transaction_month;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 14. Problem Statement
Assign performance score to merchants (Nov 2023–Apr 2024):
- Excellent > $50,000
- Good > $20,000 and <= $50,000
- Average > $10,000 and <= $20,000
- Below Average <= $10,000
Also calculate avg transaction per category. */

SELECT m.merchant_id, m.business_name,
       SUM(t.transaction_amount) AS total_received,
       CASE 
         WHEN SUM(t.transaction_amount) > 50000 THEN 'Excellent'
         WHEN SUM(t.transaction_amount) > 20000 THEN 'Good'
         WHEN SUM(t.transaction_amount) > 10000 THEN 'Average'
         ELSE 'Below Average'
       END AS performance_score,
       AVG(t.transaction_amount) AS average_transaction
FROM merchants m
JOIN transactions t ON m.merchant_id = t.recipient_id
WHERE t.transaction_date >= '2023-11-01'
  AND t.transaction_date < '2024-05-01'
GROUP BY m.merchant_id, m.business_name
ORDER BY performance_score DESC, total_received DESC;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 15. Problem Statement
Find users who made at least 1 transaction in 6 or more months 
between May 2023 and Apr 2024. */

WITH cte AS (
  SELECT u.user_id, u.email,
         DATE_FORMAT(t.transaction_date, '%Y-%m') AS transaction_month
  FROM transactions t
  JOIN users u ON t.sender_id = u.user_id
  WHERE t.transaction_date >= '2023-05-01'
    AND t.transaction_date < '2024-05-01'
  GROUP BY u.user_id, u.email, transaction_month
),
cte2 AS (
  SELECT user_id, email, COUNT(transaction_month) AS active_month_count
  FROM cte
  GROUP BY user_id, email
)
SELECT user_id, email
FROM cte2
WHERE active_month_count >= 6
ORDER BY user_id;

-------------------------------------------------------------------------------------------------------------------------------------------
/* 16. Problem Statement
Track merchants’ monthly totals (Nov 2023–Apr 2024).
Indicate whether they exceeded $50,000. */

WITH cte AS (
  SELECT m.merchant_id, m.business_name,
         YEAR(t.transaction_date) AS transaction_year,
         MONTH(t.transaction_date) AS transaction_month,
         SUM(t.transaction_amount) AS total_transaction_amount
  FROM transactions t
  JOIN merchants m ON m.merchant_id = t.recipient_id
  WHERE t.transaction_date >= '2023-11-01'
    AND t.transaction_date < '2024-05-01'
  GROUP BY m.merchant_id, m.business_name, transaction_year, transaction_month
)
SELECT merchant_id, business_name, transaction_year, transaction_month,
       total_transaction_amount,
       CASE 
         WHEN total_transaction_amount > 50000 THEN 'Exceeded $50,000'
         ELSE 'Did Not Exceed $50,000'
       END AS performance_status
FROM cte
ORDER BY merchant_id, transaction_year, transaction_month;

---------------------------------------------------------------------------
-- ** The End **
