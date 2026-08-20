CREATE DATABASE IF NOT EXISTS SALES;
USE SALES;

-- 1. Categories.csv → CategoryID, CategoryName
CREATE TABLE IF NOT EXISTS Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(100) NOT NULL
);
select * from categories;

-- 2. Customers__1_.csv → CustomerID, Name, Address
CREATE TABLE IF NOT EXISTS Customers (
    CustomerID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);
select * from customers;


-- 3. Suppliers.csv → SupplierID, SupplierName, Address
CREATE TABLE IF NOT EXISTS Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100) NOT NULL,
    Address VARCHAR(255)
);
select * from suppliers;

-- 4. Store_Employees.csv → EmployeeID, Name, HireDate
CREATE TABLE IF NOT EXISTS Store_Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    HireDate DATE
);
select * from store_employees;


USE SALES;

ALTER TABLE Suppliers
    MODIFY SupplierID INT NOT NULL,
    MODIFY SupplierName VARCHAR(100) NOT NULL,
    MODIFY Address VARCHAR(255),
    ADD PRIMARY KEY (SupplierID);
    
ALTER TABLE Categories
    MODIFY CategoryID INT NOT NULL,
    MODIFY CategoryName VARCHAR(100) NOT NULL,
    ADD PRIMARY KEY (CategoryID);
-- 5. Products.csv → ProductID, Name, SupplierID, CategoryID, Price
CREATE TABLE IF NOT EXISTS Products (
    ProductID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    SupplierID INT,
    CategoryID INT,
    Price DECIMAL(10,2),
    CONSTRAINT fk_products_supplier FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    CONSTRAINT fk_products_category FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
select * from products;


ALTER TABLE Customers
    MODIFY CustomerID INT NOT NULL,
    MODIFY Name VARCHAR(100) NOT NULL,
    MODIFY Address VARCHAR(255),
    ADD PRIMARY KEY (CustomerID);
    
USE SALES;

ALTER TABLE Store_Employees
    MODIFY EmployeeID INT NOT NULL,
    MODIFY Name VARCHAR(100) NOT NULL,
    MODIFY HireDate DATE,
    ADD PRIMARY KEY (EmployeeID);
UPDATE Store_Employees
SET HireDate = STR_TO_DATE(HireDate, '%m/%d/%Y');
-- 6. Orders.csv → OrderID, CustomerID, EmployeeID, OrderDate  (no TotalAmount column in your file)
CREATE TABLE IF NOT EXISTS Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    EmployeeID INT,
    OrderDate DATE NOT NULL,
    CONSTRAINT fk_orders_customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT fk_orders_employee FOREIGN KEY (EmployeeID) REFERENCES Store_Employees(EmployeeID)
);
select * from orders;

UPDATE Orders
SET OrderDate = STR_TO_DATE(OrderDate, '%m/%d/%Y');

ALTER TABLE Orders
    MODIFY OrderID INT NOT NULL,
    MODIFY CustomerID INT NOT NULL,
    MODIFY EmployeeID INT,
    MODIFY OrderDate DATE NOT NULL,
    ADD PRIMARY KEY (OrderID);
ALTER TABLE Products
    MODIFY ProductID INT NOT NULL,
    MODIFY Name VARCHAR(100) NOT NULL,
    MODIFY SupplierID INT,
    MODIFY CategoryID INT,
    MODIFY Price DECIMAL(10,2),
    ADD PRIMARY KEY (ProductID);
SELECT COUNT(*) FROM Products WHERE ProductID IS NULL;

SELECT ProductID, COUNT(*) 
FROM Products 
GROUP BY ProductID 
HAVING COUNT(*) > 1;
-- 7. OrderDetails.csv → OrderDetailID, OrderID, ProductID, Quantity, PriceEach, TotalPrice
CREATE TABLE IF NOT EXISTS OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    PriceEach DECIMAL(12,4),
    TotalPrice DECIMAL(12,4),
    CONSTRAINT fk_orderdetails_order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT fk_orderdetails_product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
select * from orderdetails;


-- question
-- 1. How many unique customers have placed orders?
SELECT COUNT(DISTINCT CustomerID) AS Unique_Customers
FROM Orders;

-- 2. Which customers have placed the highest number of orders?
SELECT
    c.CustomerID,
    c.Name,
    COUNT(o.OrderID) AS Total_Orders
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Orders DESC;

-- 3. Total and average purchase value per customer
SELECT
    c.CustomerID,
    c.Name,
    SUM(od.TotalPrice) AS Total_Purchase,
    AVG(od.TotalPrice) AS Average_Purchase
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name;

-- 4. Top 5 customers by total purchase amount
SELECT
    c.CustomerID,
    c.Name,
    SUM(od.TotalPrice) AS Total_Purchase
FROM Customers c
JOIN Orders o
ON c.CustomerID=o.CustomerID
JOIN OrderDetails od
ON o.OrderID=od.OrderID
GROUP BY c.CustomerID,c.Name
ORDER BY Total_Purchase DESC
LIMIT 5;

-- 2. Product Performance
-- 1. Number of products in each category
SELECT
    c.CategoryName,
    COUNT(p.ProductID) AS Product_Count
FROM Categories c
LEFT JOIN Products p
ON c.CategoryID=p.CategoryID
GROUP BY c.CategoryName;

-- 2. Average price by category
SELECT
    c.CategoryName,
    AVG(p.Price) AS Average_Price
FROM Categories c
JOIN Products p
ON c.CategoryID=p.CategoryID
GROUP BY c.CategoryName;

-- 3. Highest selling products by quantity
SELECT
    p.ProductID,
    p.Name,
    SUM(od.Quantity) AS Total_Quantity
FROM Products p
JOIN OrderDetails od
ON p.ProductID=od.ProductID
GROUP BY p.ProductID,p.Name
ORDER BY Total_Quantity DESC;

-- 4. Revenue generated by each product
SELECT
    p.ProductID,
    p.Name,
    SUM(od.TotalPrice) AS Revenue
FROM Products p
JOIN OrderDetails od
ON p.ProductID=od.ProductID
GROUP BY p.ProductID,p.Name
ORDER BY Revenue DESC;

-- 5. Product sales by category and supplier
SELECT
    c.CategoryName,
    s.SupplierName,
    SUM(od.TotalPrice) AS Revenue
FROM Products p
JOIN Categories c
ON p.CategoryID=c.CategoryID
JOIN Suppliers s
ON p.SupplierID=s.SupplierID
JOIN OrderDetails od
ON p.ProductID=od.ProductID
GROUP BY c.CategoryName,s.SupplierName
ORDER BY Revenue DESC;

-- 3. Sales & Order Trends
-- 1. Total number of orders
SELECT COUNT(*) AS Total_Orders
FROM Orders;

-- 2. Average value per order
SELECT
    AVG(Order_Total) AS Average_Order_Value
FROM
(
SELECT
    OrderID,
    SUM(TotalPrice) AS Order_Total
FROM OrderDetails
GROUP BY OrderID
) t;

-- 3. Dates with most orders
SELECT
    OrderDate,
    COUNT(OrderID) AS Orders
FROM Orders
GROUP BY OrderDate
ORDER BY Orders DESC;

-- 4. Monthly order volume and revenue
SELECT
    YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
    COUNT(DISTINCT o.OrderID) AS Total_Orders,
    SUM(od.TotalPrice) AS Revenue
FROM Orders o
JOIN OrderDetails od
ON o.OrderID=od.OrderID
GROUP BY YEAR(o.OrderDate),MONTH(o.OrderDate)
ORDER BY Year,Month;

-- 5. Weekday vs Weekend orders
SELECT
CASE
WHEN DAYOFWEEK(OrderDate) IN (1,7)
THEN 'Weekend'
ELSE 'Weekday'
END AS Day_Type,
COUNT(*) AS Orders
FROM Orders
GROUP BY Day_Type;

-- 4. Supplier Contribution
-- 1. Number of suppliers
SELECT COUNT(*) AS Total_Suppliers
FROM Suppliers;

-- 2. Supplier providing most products
SELECT
    s.SupplierName,
    COUNT(p.ProductID) AS Product_Count
FROM Suppliers s
JOIN Products p
ON s.SupplierID=p.SupplierID
GROUP BY s.SupplierName
ORDER BY Product_Count DESC;

-- 3. Average product price by supplier
SELECT
    s.SupplierName,
    AVG(p.Price) AS Average_Price
FROM Suppliers s
JOIN Products p
ON s.SupplierID=p.SupplierID
GROUP BY s.SupplierName;

-- 4. Supplier contribution by revenue
SELECT
    s.SupplierName,
    SUM(od.TotalPrice) AS Revenue
FROM Suppliers s
JOIN Products p
ON s.SupplierID=p.SupplierID
JOIN OrderDetails od
ON p.ProductID=od.ProductID
GROUP BY s.SupplierName
ORDER BY Revenue DESC;

-- 5. Employee Performance
-- 1. Employees who processed orders
SELECT
COUNT(DISTINCT EmployeeID) AS Active_Employees
FROM Orders;

-- 2. Employees handling most orders
SELECT
    e.EmployeeID,
    e.Name,
    COUNT(o.OrderID) AS Orders_Handled
FROM Store_Employees e
JOIN Orders o
ON e.EmployeeID=o.EmployeeID
GROUP BY e.EmployeeID,e.Name
ORDER BY Orders_Handled DESC;

-- 3. Sales processed by employee
SELECT
    e.EmployeeID,
    e.Name,
    SUM(od.TotalPrice) AS Total_Sales_price
FROM Store_Employees e
JOIN Orders o
ON e.EmployeeID=o.EmployeeID
JOIN OrderDetails od
ON o.OrderID=od.OrderID
GROUP BY e.EmployeeID,e.Name
ORDER BY Total_Sales_price DESC;

-- 4. Average order value handled by employee
SELECT
    e.EmployeeID,
    e.Name,
    AVG(Order_Total) AS Average_Order_Value
FROM
(
SELECT
    o.OrderID,
    o.EmployeeID,
    SUM(od.TotalPrice) AS Order_Total
FROM Orders o
JOIN OrderDetails od
ON o.OrderID=od.OrderID
GROUP BY o.OrderID,o.EmployeeID
) t
JOIN Store_Employees e
ON t.EmployeeID=e.EmployeeID
GROUP BY e.EmployeeID,e.Name;

-- 6. Order Details Deep Dive
-- 1. Quantity vs Total Price
SELECT
    Quantity,
    TotalPrice
FROM OrderDetails;

-- 2. Average quantity ordered per product
SELECT
    p.ProductID,
    p.Name,
    AVG(od.Quantity) AS Average_Quantity
FROM Products p
JOIN OrderDetails od
ON p.ProductID=od.ProductID
GROUP BY p.ProductID,p.Name;

-- 3. Unit price variation
SELECT
    p.Name,
    od.OrderID,
    od.PriceEach
FROM Products p
JOIN OrderDetails od
ON p.ProductID=od.ProductID
ORDER BY p.Name,od.OrderID;

-- my analysis
-- bussiness problem is to increase revenu

-- 1. Who are the most valuable customers?
SELECT
    c.CustomerID,
    c.Name,
    ROUND(SUM(od.TotalPrice),2) AS Total_Spending
FROM Customers c
JOIN Orders o
    ON c.CustomerID = o.CustomerID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.Name
ORDER BY Total_Spending DESC;

-- 2. Which products generate the highest revenue?
SELECT
    p.ProductID,
    p.Name,
    ROUND(SUM(od.TotalPrice),2) AS Revenue
FROM Products p
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY Revenue DESC;

-- 3. Which product categories generate the highest revenue?
SELECT
    c.CategoryName,
    ROUND(SUM(od.TotalPrice),2) AS Revenue
FROM Categories c
JOIN Products p
    ON c.CategoryID = p.CategoryID
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY c.CategoryName
ORDER BY Revenue DESC;

-- 4. Which suppliers contribute the most to sales?
SELECT
    s.SupplierID,
    s.SupplierName,
    ROUND(SUM(od.TotalPrice),2) AS Revenue
FROM Suppliers s
JOIN Products p
    ON s.SupplierID = p.SupplierID
JOIN OrderDetails od
    ON p.ProductID = od.ProductID
GROUP BY s.SupplierID, s.SupplierName
ORDER BY Revenue DESC;

-- 5. Which employees process the highest-value orders?
SELECT
    e.EmployeeID,
    e.Name,
    ROUND(SUM(od.TotalPrice),2) AS Total_Sales
FROM Store_Employees e
JOIN Orders o
    ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.Name
ORDER BY Total_Sales DESC;

-- 6. What are the monthly sales trends?
SELECT
    YEAR(o.OrderDate) AS Year,
    MONTHNAME(o.OrderDate) AS Month,
    COUNT(DISTINCT o.OrderID) AS Total_Orders,
    ROUND(SUM(od.TotalPrice),2) AS Revenue
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate), MONTHNAME(o.OrderDate)
ORDER BY Year, MONTH(o.OrderDate);

-- 7. Compare weekday vs weekend revenue
SELECT
    CASE
        WHEN DAYOFWEEK(o.OrderDate) IN (1,7)
        THEN 'Weekend'
        ELSE 'Weekday'
    END AS Day_Type,
    ROUND(SUM(od.TotalPrice),2) AS Revenue,
    COUNT(DISTINCT o.OrderID) AS Orders
FROM Orders o
JOIN OrderDetails od
    ON o.OrderID = od.OrderID
GROUP BY Day_Type;











