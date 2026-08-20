# 🛒 Grocery Store Management SQL Analysis

## 📌 Project Overview

The *Grocery Store Management SQL Analysis* project is a SQL-based data analysis project designed to analyze customer purchases, product sales, supplier performance, employee activities, and revenue trends.

The project uses a relational Grocery Store database and SQL queries to transform raw transactional data into meaningful business insights.

---

## 🎯 Business Problem

A grocery store generates a large amount of customer, product, supplier, employee, and sales data.

The business needs to understand:

* Who are the most valuable customers?
* Which products generate the highest revenue?
* Which product categories generate the highest revenue?
* Which suppliers contribute the most to sales?
* Which employees process the highest-value orders?
* What are the monthly sales trends?
* How does weekday revenue compare with weekend revenue?

Using SQL analysis, these questions can be answered and converted into actionable business insights.

---

## 🎯 Project Objectives

The main objectives of this project are:

* Analyze the Grocery Store database using SQL.
* Understand customer purchasing behavior.
* Identify high-value customers.
* Analyze product and category sales performance.
* Evaluate supplier contribution to sales.
* Analyze employee performance.
* Identify monthly sales trends.
* Compare weekday and weekend revenue.
* Identify opportunities and strategies to increase monthly revenue.

---

## 🗄️ Database Schema

The project contains the following tables:

1. Customers
2. Store_Employees
3. Suppliers
4. Categories
5. Products
6. Orders
7. OrderDetails

---

# 🔍 Key Analysis Questions & Insights

### 1. Who are the most valuable customers?

**Insight:** High-value customers generate the highest revenue and should be prioritized for customer retention and loyalty programs.

---

### 2. Which products generate the highest revenue?

**Insight:** High-revenue products contribute significantly to total sales and should be prioritized for inventory and promotional planning.

---

### 3. Which product categories generate the highest revenue?

**Insight:** High-revenue categories drive a major portion of sales and should be given more focus in inventory and marketing strategies.

---

### 4. Which suppliers contribute the most to sales?

**Insight:** Top-performing suppliers contribute the highest sales revenue and are important partners for business growth.

---

### 5. Which employees process the highest-value orders?

**Insight:** Top-performing employees process high-value orders and play an important role in increasing store revenue.

---

### 6. What are the monthly sales trends?

**Insight:** Monthly sales trends help identify peak and low-performing months, supporting better business planning and demand forecasting.

---

### 7. How does weekday revenue compare with weekend revenue?

**Insight:** Weekday vs. weekend revenue analysis helps identify when customers spend the most and supports better operational planning.

---

## 📊 Business Insights

### 1. Customer Insights

High-value customers may contribute a significant share of total sales, making them important for customer retention strategies.

### 2. Product Insights

High-revenue products are major contributors to store sales and should be kept sufficiently stocked.

### 3. Sales & Revenue Insights

Monthly sales analysis helps identify peak and low-sales periods, supporting better demand forecasting and inventory planning.

---

## 🔗 Table Relationships

```text
Customers
    │
    └── Orders
           │
           └── OrderDetails
                  │
                  └── Products
                         │
                         ├── Categories
                         └── Suppliers

Store_Employees
    │
    └── Orders
```

---

## 🛠️ Technologies Used

* **MySQL**
* **MySQL Workbench**
* **SQL**
* Relational Database Management
* Data Analysis

---

## 💻 SQL Concepts Used

* SELECT
* WHERE
* ORDER BY
* GROUP BY
* HAVING
* Aggregate Functions
* JOINs
* Subqueries
* Date Functions
* Primary Keys
* Foreign Keys

---

## 📚 Learning Outcomes

Through this project, I gained hands-on experience with MySQL Workbench and relational databases.

I strengthened my SQL skills in:

* Joins
* Aggregations
* Subqueries
* GROUP BY and HAVING
* Complex SQL queries
* Database relationships

I also learned how to transform raw transactional data into actionable business insights and worked with data validation and foreign-key constraint issues.

---

## ✅ Conclusion

The Grocery Store Management Analysis project transformed raw sales data into actionable business insights.

By understanding customer preferences, product performance, supplier contribution, employee activities, and sales trends, the business can make data-driven decisions to:

* Increase revenue
* Optimize inventory
* Improve customer satisfaction
* Improve operational efficiency
* Support future business growth

This project demonstrates how **SQL-based data analysis can help businesses identify sales opportunities and make better strategic decisions.**
