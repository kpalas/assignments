CREATE TABLE Customers(
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    birthday DATE,
    c_id INT,
    PRIMARY KEY (c_id)
);

CREATE TABLE Employees(
    first_name VARCHAR(20),
    last_name VARCHAR(20),
    birthday DATE,
    e_id INT,
    PRIMARY KEY (e_id)
);

CREATE TABLE Deals(
    value INT,
    d_id INT,
    PRIMARY KEY (d_id)
);

CREATE TABLE TypesInDeals(
    d_id INT,
    type VARCHAR(20),
    PRIMARY KEY (type),
    FOREIGN KEY (d_id) REFERENCES Deals(d_id)
);

CREATE TABLE Stock(
    amount INT,
    type VARCHAR(20),
    name VARCHAR(20),
    PRIMARY KEY (name),
    FOREIGN KEY (type) REFERENCES TypesInDeals(type)
);

CREATE TABLE Transactions(
    date DATE,
    challenge BOOL,
    c_id INT,
    e_id INT,
    t_id INT,
    PRIMARY KEY (t_id),
    FOREIGN KEY (c_id) REFERENCES Customers(c_id),
    FOREIGN KEY (e_id) REFERENCES Employees(e_id)
);

CREATE TABLE ItemsInTransactions(
    name VARCHAR(20),
    cost INT,
    t_id INT,
    FOREIGN KEY (name) REFERENCES Stock(name),
    FOREIGN KEY (t_id) REFERENCES Transactions(t_id)
);


INSERT INTO Customers (first_name, last_name, birthday, c_id)
VALUES ('Ben', 'Thompson', '1992-07-21', 6);

INSERT INTO Employees (first_name, last_name, birthday, e_id)
VALUES ('Rita', 'Davies', '2000-10-07', 5);

INSERT INTO Transactions (c_id, e_id, t_id, challenge, date)
VALUES (6, 5, 18, FALSE, '2025-09-07');

INSERT INTO Stock (amount, type, name)
VALUES 
(7, NULL, 'Newspaper'),
(4, NULL, 'Pen');

INSERT INTO ItemsInTransactions (name, cost, t_id)
VALUES 
('Newspaper', 149, 18),
('Pen', 99, 18);

CREATE VIEW August2025SalesByDavid AS
SELECT COUNT(*) AS number_of_sales
FROM Transactions
WHERE e_id = 4
  AND date >= '2025-08-01'
  AND date <= '2025-08-31';


CREATE VIEW Above25 AS
SELECT DISTINCT
    t.t_id,
    t.challenge,
    (DATEDIFF(t.date, c.birthday) >= 9132) AS above_25
FROM Transactions t
JOIN Customers c ON t.c_id = c.c_id
JOIN ItemsInTransactions i ON t.t_id = i.t_id
JOIN Stock stock ON i.name = stock.name
WHERE stock.type = 'Alcohol';


CREATE VIEW StockLeft AS
SELECT stock.name, (stock.amount - COUNT(i.t_id)) AS stock_left
FROM Stock stock
LEFT JOIN ItemsInTransactions i ON stock.name = i.name
GROUP BY stock.name, stock.amount;

CREATE VIEW PrizeDraw AS
SELECT
    c.c_id,
    COUNT(t.t_id) AS number_of_transactions,
    CASE WHEN COUNT(e.e_id) > 0 THEN 1 ELSE 0 END AS is_employee
FROM Customers c
JOIN Transactions t ON c.c_id = t.c_id
LEFT JOIN Employees e ON c.first_name = e.first_name
                      AND c.last_name = e.last_name
                      AND c.birthday = e.birthday
WHERE t.date >= '2025-08-01' AND t.date <= '2025-08-31'
GROUP BY c.c_id
ORDER BY is_employee ASC, number_of_transactions ASC, c_id ASC;



CREATE VIEW ItemDetails AS
SELECT i.t_id, s.type, i.name, i.cost
FROM ItemsInTransactions i
JOIN Stock s ON i.name = s.name
WHERE s.type IS NOT NULL;

CREATE VIEW NumberedItemsInTransactions AS
SELECT
    A.t_id,
    A.type,
    A.name,
    COUNT(B.name) AS cheapest
FROM ItemDetails A
JOIN ItemDetails B 
    ON A.t_id = B.t_id 
    AND A.type = B.type 
    AND B.cost <= A.cost
GROUP BY A.t_id, A.type, A.name;





