-- Nivell 1
-- Exercici 1
SHOW COLUMNS FROM transaction;
SHOW CREATE TABLE transaction;
--
SHOW COLUMNS FROM company;
SHOW CREATE TABLE company;
--
CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(25) NOT NULL,
    iban VARCHAR(150),
    pan VARCHAR(25),
    pin VARCHAR(25),
    cvv VARCHAR(25),
    expiring_date VARCHAR(25),
    PRIMARY KEY (id)
);
SHOW COLUMNS FROM credit_card;
--
SELECT *
FROM credit_card;
-- 
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card_id
FOREIGN KEY (credit_card_id) REFERENCES credit_card (id);
--
SHOW COLUMNS FROM transaction;
-- Exercici_2
SELECT *
FROM credit_card
INNER JOIN transaction ON credit_card.id = transaction.credit_card_id
WHERE credit_card_id = 'CcU-2938';
--
UPDATE credit_card SET iban='R323456312213576817699999' WHERE id = 'CcU-2938';
--
SELECT *
FROM credit_card
INNER JOIN transaction ON credit_card.id = transaction.credit_card_id
WHERE credit_card_id = 'CcU-2938';
-- Exercici_3
SELECT id
FROM transactions.transaction
WHERE id='108B1D1D-5B23-A76C-55EF-C568E49A99DD';
--
INSERT INTO user (id) VALUES ('9999');
--
INSERT INTO company (id) VALUES ('B-9999');
--
INSERT INTO credit_card (id) VALUES ('CcU-9999');
--
INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');
--
SELECT *
FROM transactions.transaction
WHERE id='108B1D1D-5B23-A76C-55EF-C568E49A99DD';
-- Exercici_4
ALTER TABLE credit_card DROP pan;
--
SHOW COLUMNS FROM credit_card;
-- Nivell_2
-- Exercici_1
SELECT *
FROM transaction
WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';
--
DELETE FROM transaction WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';
--
SELECT *
FROM transaction
WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02';
-- Exercici_2
SELECT c.company_name, c.phone, c.country, AVG(t.amount) AS average_sale  
FROM company c  
INNER JOIN transaction t ON c.id = t.company_id  
WHERE t.declined != 1
GROUP BY c.company_name, c.phone, c.country  
ORDER BY average_sale DESC;
--
SELECT * FROM transactions.vistamarketing;
-- Exercici_3
SELECT * FROM transactions.vistamarketing
WHERE country = 'Germany';
-- Nivell_3
-- Exercici_1
SHOW COLUMNS FROM company;
--
ALTER TABLE company DROP website;
--
SHOW COLUMNS FROM company;
--
SHOW COLUMNS FROM user;
--
ALTER TABLE user
CHANGE COLUMN email personal_email VARCHAR(150);
--
SHOW COLUMNS FROM user;
--
SHOW COLUMNS FROM credit_card;
--
START TRANSACTION;
--
ALTER TABLE transaction
DROP FOREIGN KEY fk_credit_card_id;
--
ALTER TABLE credit_card 
MODIFY COLUMN id VARCHAR(20);
--
ALTER TABLE credit_card 
MODIFY COLUMN iban VARCHAR(50);
--
ALTER TABLE credit_card 
MODIFY COLUMN pin VARCHAR(25);
--
ALTER TABLE credit_card 
MODIFY COLUMN cvv INT;
--
ALTER TABLE credit_card 
MODIFY COLUMN expiring_date VARCHAR(10);
--
ALTER TABLE credit_card
ADD COLUMN fecha_actual DATE;
--
SHOW COLUMNS FROM credit_card;
--
ALTER TABLE transaction
ADD CONSTRAINT fk_credit_card_id
FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);
--
COMMIT;
-- Exercici_2
SELECT t.id AS id_transaction, u.name AS user_name, u.surname AS user_surname, cc.iban, c.company_name
FROM transaction t
JOIN user u ON t.user_id = u.id
JOIN credit_card cc ON t.credit_card_id = cc.id
JOIN company c ON t.company_id = c.id
ORDER BY id_transaction DESC;
-- 
SELECT * FROM transactions.InformeTecnico;