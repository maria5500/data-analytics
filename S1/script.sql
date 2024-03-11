--Nivell_1
Exercici_1 
DESCRIBE company
DESCRIBE transaction
--Exercici_2
SELECT company_name, email, country FROM transactions.company	
ORDER BY company_name
--Exercici_3
SELECT DISTINCT company.country
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
ORDER BY country
--Exercici_4
SELECT COUNT(DISTINCT company.country) AS total_country
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
--Exercici_5
SELECT company_id, company.country, company.company_name
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
WHERE transaction.company_id = 'b-2354'
--Exercici_6
SELECT company.company_name, AVG(transaction.amount) AS average_sales
FROM company
INNER JOIN transaction ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY average_sales DESC
LIMIT 1
--Nivell_2
Exercici_1
