-- 1 DROP tables (reset database)
DROP TABLE IF EXISTS Addresses CASCADE;
DROP TABLE IF EXISTS Customers CASCADE;
DROP TABLE IF EXISTS Drivers CASCADE;
DROP TABLE IF EXISTS Packages CASCADE;

-- 2 Table Creation & Data Insertion
-- 2.1 Table Creation
CREATE TABLE Addresses (
    DeliveryAddress_ID SERIAL PRIMARY KEY,
    StreetAddress TEXT NOT NULL,
    City TEXT NOT NULL,
    State TEXT NOT NULL,
    PostalCode TEXT NOT NULL
);
---------------------------------------------------
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    Email TEXT UNIQUE NOT NULL,
    Phone TEXT,
    DeliveryAddress_ID INT,
    CONSTRAINT fk_customer_address
        FOREIGN KEY (DeliveryAddress_ID)
        REFERENCES Addresses (DeliveryAddress_ID)
);
---------------------------------------------------
CREATE TABLE Drivers (
    LicenseNumber VARCHAR(20) PRIMARY KEY,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL
);
---------------------------------------------------
CREATE TABLE Packages (
    Package_ID SERIAL PRIMARY KEY,
    Description TEXT NOT NULL,
    Weight NUMERIC(6,2) NOT NULL,
    Status TEXT NOT NULL,
    StatusDate TIMESTAMP NOT NULL,

    LicenseNumber VARCHAR(20),
    Customer_ID INT,

    CONSTRAINT fk_package_driver
        FOREIGN KEY (LicenseNumber)
        REFERENCES Drivers (LicenseNumber),

    CONSTRAINT fk_package_customer
        FOREIGN KEY (Customer_ID)
        REFERENCES Customers (Customer_ID)
);
-- 2.2 Data Insertion
INSERT INTO Addresses (StreetAddress, City, State, PostalCode) VALUES
('123 Main St', 'Los Angeles', 'CA', '90001'),
('456 Elm St', 'New York', 'NY', '10001'),
('789 Oak St', 'Chicago', 'IL', '60601'),
('101 Pine St', 'San Francisco', 'CA', '94101');

SELECT * FROM Addresses;
---------------------------------------------------
INSERT INTO Customers (FirstName, LastName, Email, Phone, DeliveryAddress_ID) VALUES
('John', 'Doe', 'john@example.com', '123-456-7890', 1),
('Jane', 'Smith', 'jane@example.com', '987-654-3210', 2),
('Bob', 'Johnson', 'bob@example.com', '555-555-5555', 3),
('Alice', 'Williams', 'alice@example.com', '111-222-3333', 4);

SELECT * FROM Customers;
---------------------------------------------------
INSERT INTO Drivers (FirstName, LastName, LicenseNumber) VALUES
('David', 'Smith', 'DL12345'),
('Emily', 'Johnson', 'DL67890'),
('Michael', 'Brown', 'DL54321'),
('Olivia', 'Davis', 'DL98765'),
('Jane', 'Robert', 'TLM1289'),
('Mary', 'James', 'AO8526');

SELECT * FROM Drivers;
---------------------------------------------------
INSERT INTO Packages
(Description, Weight, Status, StatusDate, LicenseNumber, Customer_ID)
VALUES
('Electronics (fragile)', 5.2, 'pickup', '2024-01-05 09:15:00', 'DL12345', 1),
('Books', 2.0, 'delivered', '2024-01-08 14:30:00', 'DL67890', 2),
('Clothing', 3.5, 'on-transit', '2024-02-02 10:45:00', 'DL54321', 3),
('Furniture', 15.8, 'pickup', '2024-02-01 11:20:00', 'DL98765', 4),
('Artwork (fragile)', 5.0, 'delivered', '2024-01-05 13:10:00', 'TLM1289', 1),
('Home Appliance', 100.0, 'pickup', '2024-01-14 08:00:00', 'AO8526', 2);

SELECT * FROM Packages;

--3 SQL Query – Customer Packages
SELECT
    c.FirstName || ' ' || c.LastName AS FullName,
    COUNT(p.Package_ID) AS TotalPackages
FROM Customers c
LEFT JOIN Packages p
    ON c.Customer_ID = p.Customer_ID
GROUP BY c.Customer_ID, c.FirstName, c.LastName
ORDER BY TotalPackages DESC;

--4 SQL Query – Driver Workload
SELECT
    d.FirstName || ' ' || d.LastName AS FullName,
    COUNT(p.Package_ID) AS TotalPackages
FROM Drivers d
LEFT JOIN Packages p
    ON d.LicenseNumber = p.LicenseNumber
GROUP BY d.LicenseNumber, d.FirstName, d.LastName
ORDER BY TotalPackages DESC;

--5 SQL Query – Package Status Summary
SELECT
    Status,
    COUNT(*) AS TotalPackages
FROM Packages
GROUP BY Status
ORDER BY TotalPackages DESC;






