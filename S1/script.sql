-- Nivell_1
-- Exercici_1 
DESCRIBE company;
SELECT * FROM transactions.company;
DESCRIBE transaction;
SELECT * FROM transactions.transaction;
-- Exercici_2
SELECT company_name, email, country
FROM company	
ORDER BY company_name;
-- Exercici_3
SELECT DISTINCT country
FROM company
ORDER BY country;
-- Exercici_4
SELECT COUNT(DISTINCT country) AS total_country
FROM company;
-- Exercici_5
SELECT id AS company_id, country, company_name
FROM company
WHERE id = 'b-2354';
-- Exercici_6
SELECT company.company_name, AVG(transaction.amount) AS average_sales
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
WHERE transaction.declined != 1
GROUP BY company.company_name
ORDER BY average_sales DESC
LIMIT 1;
-- Nivell_2
-- Exercici_1
SELECT id, COUNT(*) AS quantity
FROM company
GROUP BY id
HAVING COUNT(*) > 1; 
-- 
SELECT id, COUNT(*) AS quantity
FROM transaction
GROUP BY id
HAVING COUNT(*) > 1;
-- Exercici_2
SELECT DATE(timestamp) AS day, SUM(amount) AS sum_amount
FROM transaction
WHERE declined != 1
GROUP BY DATE(timestamp)
ORDER BY sum_amount DESC
LIMIT 5;
-- Exercici_3
SELECT DATE(timestamp) AS day, SUM(amount) AS sum_amount
FROM transaction
WHERE declined != 1
GROUP BY DATE(timestamp)
ORDER BY sum_amount ASC
LIMIT 5;
-- Exercici_4
SELECT country, ROUND(AVG(amount), 2) AS average_sales
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
WHERE declined != 1
GROUP BY country
ORDER BY average_sales DESC;
-- Nivell_3
-- Exercici_1
SELECT c.company_name, c.phone, c.country, t.amount
FROM company c
INNER JOIN transaction t ON c.id = t.company_id
WHERE t.declined != 1 AND t.amount BETWEEN 100 AND 200
ORDER BY t.amount DESC;
-- Exercici_2
SELECT company_name, DATE(timestamp) AS day_transaction 
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
WHERE declined != 1 AND (DATE(timestamp) = '2022-03-16' OR DATE(timestamp) = '2022-02-28' OR DATE(timestamp) = '2022-02-13')
ORDER BY day_transaction DESC;