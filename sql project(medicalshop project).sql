
USE medicalshop;


-- Drop tables if they already exist
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS medicineInfo;


CREATE TABLE medicineInfo (
    med_id INT PRIMARY KEY,
    med_name VARCHAR(50),
    category VARCHAR(30),
    price DECIMAL(10,2),
    cur_date DATE,
    expiry_date DATE,
    stock INT
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    med_id INT,
    customer_id INT,
    quantity INT,
    sale_date DATE,
    FOREIGN KEY (med_id) REFERENCES medicineInfo(med_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);




INSERT INTO medicineInfo VALUES
(1,'Paracetamol','Tablet',20.00,'2026-06-24','2027-05-01',50),

(2,'Cough Syrup','Syrup',85.00,'2026-06-24','2026-06-29',5),

(3,'Antibiotic','Capsule',120.00,'2026-06-24','2027-02-15',30),

(4,'Vitamin C','Tablet',50.00,'2026-06-24','2026-06-20',8),

(5,'Pain Relief Gel','Gel',95.00,'2026-06-24','2026-07-01',15);

INSERT INTO Customers VALUES
(101, 'Shiva'),
(102, 'Ravi'),
(103, 'Kiran');

INSERT INTO Sales VALUES
(1, 1, 101, 2, '2026-06-21'),
(2, 2, 102, 1, '2026-06-22'),
(3, 1, 102, 3, '2026-06-23'),
(4, 2, 103, 2, '2026-06-24');


SELECT * FROM medicineInfo;
SELECT * FROM Customers;
SELECT * FROM Sales;

-- Expired Medicines
SELECT *
FROM medicineInfo
WHERE expiry_date < CAST(GETDATE() AS DATE);

-- Medicines Expiring in Next 7 Days
SELECT med_name, expiry_date
FROM medicineInfo
WHERE expiry_date BETWEEN CAST(GETDATE() AS DATE)
AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

-- Low Stock Medicines
SELECT *
FROM medicineInfo
WHERE stock < 10;


-- Best Selling Medicine
SELECT TOP 1
    m.med_name,
    SUM(s.quantity) AS total_sold
FROM Sales s
JOIN medicineInfo m
ON s.med_id = m.med_id
GROUP BY m.med_name
ORDER BY total_sold DESC;


-- Unsold Medicines
SELECT *
FROM medicineInfo
WHERE med_id NOT IN
(
    SELECT med_id
    FROM Sales
);


-- Sales Details
SELECT
    c.name,
    m.med_name,
    s.quantity,
    s.sale_date
FROM Sales s
JOIN Customers c
ON s.customer_id = c.customer_id
JOIN medicineInfo m
ON s.med_id = m.med_id;


-- Total Sales Transactions
SELECT COUNT(*) AS total_sales
FROM Sales;

-- Total Quantity Sold
SELECT SUM(quantity) AS total_quantity_sold
FROM Sales;

-- Update Stock
UPDATE medicineInfo
SET stock = stock - 2
WHERE med_id = 1;

-- Verify Updated Stock

SELECT med_id, med_name, stock
FROM medicineInfo
WHERE med_id = 1;
