-- Nivell_1
-- Exercici_1
CREATE DATABASE bdtransactions;
--
USE bdtransactions;
CREATE TABLE companies (
	company_id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
	phone VARCHAR(15),
	email VARCHAR(100),
	country VARCHAR(100),
	website VARCHAR(255)
);
CREATE TABLE users (
	id INT PRIMARY KEY,
    name VARCHAR(255),
    surname VARCHAR(255),
    phone VARCHAR(20),
    email VARCHAR(255),
    birth_date VARCHAR(20),
    country VARCHAR(255),
    city VARCHAR(255),
    postal_code VARCHAR(50),
    address VARCHAR(255)
);
CREATE TABLE credit_cards (
	id VARCHAR(15) PRIMARY KEY,
    user_id INT,
    iban VARCHAR(100),
    pan VARCHAR(100),
    pin VARCHAR(100),
    cvv VARCHAR(15),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(25),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE products (
	id INT auto_increment PRIMARY KEY,
    product_name VARCHAR(100),
	price DECIMAL(10,2),
    colour VARCHAR(50),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR(10)
);
CREATE TABLE transactions (
	id VARCHAR(255) PRIMARY KEY,
    card_id VARCHAR(15),
    business_id VARCHAR(15),
    timestamp TIMESTAMP,
	amount DECIMAL(10, 2),
    declined BOOLEAN,
    product_ids INT,
    user_id INT,
    lat FLOAT,
    longitude FLOAT,
    FOREIGN KEY (card_id) REFERENCES credit_cards(id),
    FOREIGN KEY (business_id) REFERENCES companies(company_id),
    FOREIGN KEY (product_ids) REFERENCES products(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
-- Insertem les dades
SELECT * FROM bdtransactions.companies;
SELECT * FROM bdtransactions.users;
SELECT * FROM bdtransactions.credit_cards;
SELECT * FROM bdtransactions.products;
-- Modifiquem el tipus de dades de la columna 'products_ids"
START TRANSACTION;
ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_3;
ALTER TABLE products 
MODIFY COLUMN id VARCHAR(255);
ALTER TABLE transactions
MODIFY COLUMN product_ids VARCHAR(255);
ALTER TABLE transactions ADD CONSTRAINT FOREIGN KEY (product_ids) REFERENCES products(id);
-- Insertem les dades del csv transactions
SELECT * FROM bdtransactions.transactions;
--
-- Creem la taula de relació
CREATE TABLE transactions_products (
	transaction_product_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(255),
    product_id VARCHAR(255),
    FOREIGN KEY (transaction_id) REFERENCES transactions(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);
-- Eliminem la restricció de clau i la columna product_ids de la taula transactions
ALTER TABLE transactions DROP FOREIGN KEY transactions_ibfk_3;
ALTER TABLE transactions DROP COLUMN product_ids;
-- Insertem les dades
ALTER TABLE transactions_products DROP FOREIGN KEY transactions_products_ibfk_1;
SELECT * FROM bdtransactions.transactions;
SELECT * FROM bdtransactions.transactions_products;
-- 
COMMIT;
-- Mostrem tots els usuaris amb més de 30 transaccions
SELECT DISTINCT t.*, counts.user_id AS user_id, counts.num_transactions AS total_transactions  
FROM transactions t  
INNER JOIN (
    SELECT user_id, COUNT(*) AS num_transactions
    FROM transactions
    GROUP BY user_id
    HAVING COUNT(*) > 30
) AS counts ON t.user_id = counts.user_id
INNER JOIN users u ON t.user_id = u.id;
-- Consulta amb JOIN a la taula transactions_products
SELECT t.*, counts.user_id AS user_id, counts.total_transactions
FROM transactions t
INNER JOIN (
    SELECT user_id, COUNT(*) AS total_transactions
    FROM transactions
    GROUP BY user_id
    HAVING COUNT(*) > 30
) AS counts ON t.user_id = counts.user_id
INNER JOIN users u ON t.user_id = u.id
INNER JOIN transactions_products tp ON t.id = tp.transaction_id;
-- Identifiquem l'id dels usuaris amb més de 30 transaccions
SELECT DISTINCT user_id
FROM (
    SELECT DISTINCT t.*, counts.num_transactions AS total_transactions  
    FROM transactions t  
    INNER JOIN (
        SELECT user_id, COUNT(*) AS num_transactions
        FROM transactions
        GROUP BY user_id
        HAVING COUNT(*) > 30
    ) AS counts ON t.user_id = counts.user_id
    INNER JOIN users u ON t.user_id = u.id
) AS distinct_users;
-- Exercici_2
-- Mostrem la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd
SELECT cc.iban, AVG(t.amount) AS average_amount
FROM transactions t  
JOIN credit_cards cc ON t.card_id = cc.id  
WHERE t.business_id IN (SELECT companies.company_id FROM companies WHERE company_name = 'Donec Ltd') 
GROUP BY cc.iban;
-- Nivell_2
-- Creem la nova taula amb l'estat de les targetes de crèdit 
CREATE TABLE credit_card_status (
    card_id VARCHAR(15) PRIMARY KEY,
    status VARCHAR(25),
    FOREIGN KEY (card_id) REFERENCES credit_cards(id)
);
-- Calculem l'estat de les targetes de crèdit
INSERT INTO credit_card_status (card_id, status)
SELECT card_id,
       CASE 
           WHEN COUNT(*) = 3 AND SUM(declined) = 3 THEN 'inactive'
           ELSE 'active'
       END AS status
FROM (
    SELECT card_id, declined
    FROM transactions
    ORDER BY card_id, timestamp DESC
) AS sorted_transactions
GROUP BY card_id;
-- Mostrem la taula credit_card_status
SELECT * FROM bdtransactions.credit_card_status;
-- Exercici_1
SELECT COUNT(*) AS active_cards_count
FROM credit_card_status
WHERE status = 'active';
-- Nivell_3
SELECT * FROM bdtransactions.transactions_products;
-- Exercici_1
SELECT product_id, COUNT(*) AS total_sales
FROM transactions_products
GROUP BY product_id
ORDER BY total_sales DESC;