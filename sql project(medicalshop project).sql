-- Use database
USE medicalshop;

-- Drop tables if already exist (IMPORTANT)
DROP TABLE IF EXISTS Sales;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS medicineInfo;

-- Create tables
CREATE TABLE medicineInfo (
    med_id INT PRIMARY KEY,
    med_name VARCHAR(50),
    category VARCHAR(30),
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

-- Insert data
INSERT INTO medicineInfo VALUES
(1, 'Paracetamol', 'Tablet', '2025-07-10', '2026-05-01', 50),
(2, 'Cough Syrup', 'Syrup', '2025-07-11', '2025-03-01', 20),
(3, 'Antibiotic', 'Capsule', '2025-07-11', '2026-01-10', 30),
(4, 'Vitamin C', 'Tablet', '2025-07-12', '2024-12-01', 10);

INSERT INTO Customers VALUES
(101, 'Shiva'),
(102, 'Ravi');

INSERT INTO Sales VALUES
(1, 1, 101, 2, '2026-04-10'),
(2, 2, 102, 1, '2026-04-05'),
(3, 1, 102, 3, '2026-04-12');

-- View Data
SELECT * FROM medicineInfo;
SELECT * FROM Customers;
SELECT * FROM Sales;

-- Expired Medicines
SELECT * FROM medicineInfo
WHERE expiry_date < CAST(GETDATE() AS DATE);

-- Expiring in 7 Days
SELECT med_name, expiry_date
FROM medicineInfo
WHERE expiry_date BETWEEN CAST(GETDATE() AS DATE)
AND DATEADD(DAY, 7, CAST(GETDATE() AS DATE));

-- Low Stock
SELECT * FROM medicineInfo
WHERE stock < 10;

-- Best Selling Medicine
SELECT TOP 1 m.med_name, SUM(s.quantity) AS total_sold
FROM Sales s
JOIN medicineInfo m ON s.med_id = m.med_id
GROUP BY m.med_name
ORDER BY total_sold DESC;

-- Unsold Medicines
SELECT * FROM medicineInfo
WHERE med_id NOT IN (
    SELECT med_id FROM Sales
);

-- Sales Details
SELECT c.name, m.med_name, s.quantity, s.sale_date
FROM Sales s
JOIN Customers c ON s.customer_id = c.customer_id
JOIN medicineInfo m ON s.med_id = m.med_id;

-- Total Sales
SELECT COUNT(*) AS total_sales FROM Sales;

-- Total Quantity Sold
SELECT SUM(quantity) AS total_quantity FROM Sales;

-- Update Stock
UPDATE medicineInfo
SET stock = stock - 2
WHERE med_id = 1;