-- Nivell_1
-- Ecercici_1
SELECT *
FROM transaction 
WHERE company_id IN (SELECT  id 
	FROM company 
	WHERE country ='Germany');
-- Exercici_2
SELECT *
FROM company
WHERE id IN (SELECT company_id
	FROM transaction
    WHERE amount > (SELECT avg(amount)
    FROM transaction))
ORDER BY company_name;
-- Exercici_3
SELECT 
    t.*,
    (
        SELECT company_name
        FROM company
        WHERE id = t.company_id
    ) AS company_name
FROM 
    transaction t
WHERE 
    t.company_id IN (
        SELECT id
        FROM company
        WHERE company_name LIKE 'C%'
    );
-- Exercici_4
SELECT *
FROM company
WHERE id NOT IN (
    SELECT DISTINCT company_id
    FROM transaction
);
--
SELECT *
FROM company c
WHERE NOT EXISTS (
    SELECT 1
    FROM transaction t
    WHERE t.company_id = c.id);
-- Nivell_2
-- Exercici_1
SELECT *
FROM transaction
WHERE company_id IN ( 
	SELECT id
    FROM company 
    WHERE country = (
		SELECT country
		FROM company
        WHERE company_name = 'Non Institute'));
-- Exercici_2
SELECT 
    company_name,
    (
        SELECT 
            MAX(amount)
        FROM 
            transaction
    ) AS amount
FROM 
    company
WHERE 
    id = (
        SELECT 
            company_id
        FROM 
            transaction
        WHERE 
            amount = (
                SELECT 
                    MAX(amount)
                FROM 
                    transaction
            )
    );
-- Nivell_3
-- Exercici_1
SELECT country, AVG(amount) AS average
FROM (
    SELECT company.country, transaction.amount
    FROM transaction, company
    WHERE transaction.company_id = company.id AND transaction.declined != 1
) AS country_transactions
GROUP BY country
HAVING AVG(amount) > (
    SELECT AVG(amount) AS general_average
    FROM transaction
    WHERE declined != 1
);
-- Exercici_2
SELECT
    c.company_name,
    (
        SELECT 
            CASE 
				WHEN COUNT(*) > 4 THEN 'More than 4 transactions' 
                ELSE 'Less than 4 transactions'
            END
        FROM 
            transaction t 
        WHERE 
            t.company_id = c.id
    ) AS transaction_count_status,
    (
        SELECT 
            COUNT(*)
        FROM 
            transaction t 
        WHERE 
            t.company_id = c.id
    ) AS total_transactions
FROM 
    company c
ORDER BY
    total_transactions DESC;