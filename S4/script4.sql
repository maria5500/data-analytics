-- Nivell_1
CREATE TABLE companies (
	company_id VARCHAR(15) PRIMARY KEY NOT NULL,
    company_name VARCHAR(255),
	phone VARCHAR(15),
	email VARCHAR(100),
	country VARCHAR(100),
	website VARCHAR(255)
);
CREATE TABLE users (
	id INT PRIMARY KEY NOT NULL,
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
	id VARCHAR(15) PRIMARY KEY NOT NULL,
    user_id INT,
    iban VARCHAR(100),
    pan VARCHAR(100),
    pin VARCHAR(100),
    cvv VARCHAR(15),
    track1 VARCHAR(255),
    track2 VARCHAR(255),
    expiring_date VARCHAR(25)
);
CREATE TABLE products (
	id INT auto_increment PRIMARY KEY NOT NULL,
    product_name VARCHAR(100),
	price DECIMAL(10,2),
    colour VARCHAR(50),
    weight DECIMAL(10,2),
    warehouse_id VARCHAR(10)
);
CREATE TABLE transactions (
	id VARCHAR(255) PRIMARY KEY NOT NULL,
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
-- Exercici_1
-- Mostrem tots els usuaris amb més de 30 transaccions
SELECT u.id, u.name AS user_name, COUNT(*) AS total_transactions 
FROM users u 
JOIN transactions t ON t.user_id = u.id 
GROUP BY u.id, u.name 
HAVING total_transactions > 30 
ORDER BY total_transactions DESC;
-- Exercici_2
-- Mostrem la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd
SELECT cc.iban, ROUND(AVG(t.amount), 2) AS average_amount
FROM transactions t  
JOIN credit_cards cc ON t.card_id = cc.id  
WHERE t.business_id IN (SELECT companies.company_id FROM companies WHERE company_name = 'Donec Ltd') 
GROUP BY cc.iban;
-- Nivell_2
-- Creem la nova taula amb l'estat de les targetes de crèdit 
CREATE TABLE credit_card_status (
WITH classified_transactions AS (
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num,
        COUNT(*) OVER (PARTITION BY card_id) AS total_transactions
    FROM
        transactions
)
SELECT
    card_id,
    CASE
        WHEN total_transactions >= 3 AND SUM(declined) = 3 THEN 'Inactive'
        ELSE 'Active'
    END AS card_status
FROM
    classified_transactions
WHERE
    row_num <= 3
GROUP BY
    card_id, total_transactions
ORDER BY
    card_id);
-- Mostrem la taula credit_card_status
SELECT *
FROM credit_card_status; 
-- Veiem que no hi ha cap targeta inactiva amb la següent consulta
SELECT COUNT(*) AS active_cards_count
FROM credit_card_status
WHERE card_status = 'Inactive';
-- Nivell_3
SELECT * FROM bdtransactions.transactions_products;
-- Exercici_1
SELECT product_id, COUNT(*) AS total_sales
FROM transactions_products
GROUP BY product_id
ORDER BY total_sales DESC;