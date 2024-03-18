-- Nivell_1
-- Ecercici_1
SELECT company_name, country, t.*
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE c.country = 'Germany';
-- Exercici 2
SELECT company.company_name, SUM(transaction.amount) AS total_amount
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
GROUP BY company.company_name
HAVING SUM(transaction.amount) > (SELECT AVG(amount) 
FROM transaction 
WHERE declined != 1)
ORDER BY total_amount DESC;
-- Exercici_3
SELECT DISTINCT company.company_name, t.*
FROM company
LEFT JOIN transaction t ON company.id = t.company_id
WHERE company.company_name LIKE 'C%';
-- Exercici_4
SELECT *
FROM company c
WHERE NOT EXISTS (
    SELECT 1
    FROM transaction t
    WHERE t.company_id = c.id);
--
SELECT company.*
FROM company
LEFT JOIN transaction ON company.id = transaction.company_id
WHERE transaction.company_id IS NULL;
--
SELECT DISTINCT c.*, declined
FROM company c
INNER JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 1;
-- Nivell_2
-- Exercici_1
SELECT company_name, country
FROM company c
WHERE company_name= 'Non Institute';
--
SELECT company_name, country, t.*
FROM company c
INNER JOIN transaction t ON c.id = t.company_id
WHERE country= 'United Kingdom' AND company_name != 'Non Institute'
ORDER BY company_name;
-- Exercici_2
SELECT c.company_name, t.*
FROM company c
INNER JOIN (
    SELECT company_id, MAX(amount) AS max_amount
    FROM transaction t
    WHERE declined != 1
    GROUP BY company_id) t ON c.id = t.company_id
ORDER BY t.max_amount DESC
LIMIT 1;
-- Nivell_3
-- Exercici_1
SELECT company.country, AVG(transaction.amount) AS average_sales
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
WHERE 
	(SELECT AVG(amount) FROM transaction WHERE declined != 1) <
    (SELECT AVG(amount) FROM transaction t2 WHERE t2.company_id = company.id AND t2.declined != 1)
GROUP BY company.country
ORDER BY average_sales DESC;
-- Exercici_2
SELECT company.company_name, COUNT(transaction.id) AS total_transactions,
    IF(COUNT(transaction.id) > 4, 'More than 4 transactions', 'Less than 4 transactions') AS transaction_count_status
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY total_transactions DESC;