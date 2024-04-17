-- Nivell_1
-- Ecercici_1
SELECT *
FROM transaction
WHERE company_id IN (SELECT id FROM company WHERE country = 'Germany');
-- Exercici_2
SELECT c.*, 
       (SELECT SUM(amount) 
        FROM transaction t
        WHERE t.company_id = c.id 
          AND t.declined != 1) AS total_amount
FROM company c
WHERE c.id IN (
    SELECT company_id
    FROM transaction
    WHERE declined != 1
    GROUP BY company_id
    HAVING SUM(amount) > (
        SELECT AVG(amount)
        FROM transaction
    )
)
ORDER BY total_amount DESC;
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
SELECT company_name, country, id
FROM company c
WHERE company_name= 'Non Institute';
--
SELECT 
    t.*,
    (
        SELECT company_name
        FROM company
        WHERE id = t.company_id
    ) AS company_name,
    (
        SELECT country
        FROM company
        WHERE id = t.company_id
    ) AS country
FROM 
    transaction t
WHERE 
    t.company_id IN (
        SELECT id
        FROM company
        WHERE country = 'United Kingdom' AND id != 'b-2618'
    )
ORDER BY company_name;
-- Exercici_2
SELECT 
    company_name,
    (
        SELECT 
            MAX(amount)
        FROM 
            transaction
        WHERE 
            declined != 1
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
SELECT
    c.country,
    (
        SELECT AVG(t.amount)
        FROM transaction t
        WHERE t.company_id IN (
            SELECT id
            FROM company
            WHERE country = c.country
        ) AND t.declined != 1
    ) AS average_transactions
FROM
    company c
GROUP BY
    c.country
HAVING
    (
        SELECT AVG(t.amount)
        FROM transaction t
        WHERE t.company_id IN (
            SELECT id
            FROM company
            WHERE country = c.country
        ) AND t.declined != 1
    ) > (
        SELECT AVG(amount)
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