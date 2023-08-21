/*# Challenge 08

You have three tables in your database: customers, orders and order_items.
The customers table contains information about customers such as their CustomerID, employee_name, CustomerName, and RegistrationDate.
The orders table contains information about orders including OrderID, CustomerID, OrderDate, OrderStatus.
and order_items contains information about which product they ordered including OrderItemID, OrderID, ProductID, Quantity, UnitPrice.

Now write a SQL query to find top 5 customers with the highest potential Customer Lifetime Value (CLV), 
representing the projected total revenue each customer is expected to generate for the company over their entire engagement?
To estimate CLV, use the formula: Potential CLV = Total Spending * 1.5, where Total Spending is the sum of a customer's spending across completed orders.
Additionally, explore how the frequency of customer orders, indicated by the number of completed orders, reflects their loyalty to the business.

So finally your query will show CustomerName, RegistrationDate, ordercount and PotentialCLV.
*/

create database challenge8;

use challenge8;

create table customers(
CustomerID	int,
CustomerName varchar(200),
RegistrationDate varchar(200)
);

select * from customers;

ALTER TABLE customers ADD Column New_RegistrationDate date;

set sql_safe_updates=0;

Update customers
SET New_RegistrationDate = Str_To_Date(RegistrationDate, "%d-%m-%Y");

create table orders(
OrderID	int,
CustomerID int,
OrderDate varchar(200),	
OrderStatus varchar(200)
);

select * from orders limit 10;

create table order_items(
OrderItemID	int,
OrderID	int,
ProductID int,
Quantity int,
UnitPrice double
);

select * from order_items limit 10;

/*--------------------------------------------Query--------------------------------------------*/

SELECT
    c.CustomerName,
    c.New_RegistrationDate as `RegistrationDate`,
    COUNT(DISTINCT o.OrderID) AS ordercount,
    ROUND(SUM(oi.Quantity * oi.UnitPrice) * 1.5,2) AS PotentialCLV
FROM
    customers c
INNER JOIN
    orders o ON c.CustomerID = o.CustomerID
INNER JOIN
    order_items oi ON o.OrderID = oi.OrderID
WHERE
    o.OrderStatus = "Completed"
GROUP BY
    c.CustomerID, c.CustomerName
ORDER BY
    PotentialCLV DESC
LIMIT 5;


