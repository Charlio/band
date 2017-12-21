/* Customer Analysis: connected to Region(EWNS), Orders */


/* 1. total number of orders for each type(ContactTitle) of customers
        Customers, Orders */
        
SELECT c.ContactTitle customer_title, COUNT(*) num_orders
FROM Customers c
JOIN Orders o
ON o.CustomerID = c.CustomerID
GROUP BY 1
ORDER BY 2 DESC;
        
        
/* 2. top customers with number of orders in 2015 larger than 6
        Customers, Orders */
        
SELECT c.CustomerID, c.CompanyName, COUNT(*) num_orders
FROM Customers c
JOIN Orders o
ON o.CustomerID = c.CustomerID
WHERE o.OrderDate BETWEEN '2015-01-01' AND '2015-12-31'
GROUP BY 1, 2
HAVING COUNT(*) > 6
ORDER BY 3 DESC;        
        
        
/* 3. top 10 customers with top sales
        Customers, Orders, OrderDetails */

WITH t1 as (
            SELECT o.OrderId, d.UnitPrice*d.Quantity*(1-d.Discount) order_sale
            FROM Orders o
            JOIN Orderdetails d
            ON d.OrderID = o.OrderId)        
SELECT c.CustomerID, c.CompanyName, SUM(t1.order_sale) total_sale
FROM Customers c
JOIN Orders o
ON o.CustomerID = c.CustomerID
JOIN t1
ON t1.OrderId = o.OrderId
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;
        
        
/* 4. the customer with the highest sale in each category of products
        Customers, Orders, OrderDetails, Products, Categories */ 

WITH t1 as (
         SELECT o.OrderId, d.ProductID, d.UnitPrice*d.Quantity*(1-d.Discount) order_sale
         FROM Orders o
         JOIN Orderdetails d
         ON d.OrderID = o.OrderId),
     t2 as (
         SELECT c.CustomerID, c.CompanyName, a.CategoryID, a.CategoryName, SUM(t1.order_sale) total_sale
         FROM Customers c
         JOIN Orders o
         ON o.CustomerID = c.CustomerID
         JOIN t1
         ON t1.OrderId = o.OrderId
         JOIN Products p
         ON p.ProductID = t1.ProductID
         JOIN Categories a
         ON a.CategoryID = p.CategoryID
         GROUP BY 1, 2, 3, 4),
     t3 as (
         SELECT CategoryID, CategoryName, MAX(total_sale) max_total_sale
         FROM t2
         GROUP BY 1, 2)
SELECT t2.CompanyName, t2.CategoryName, t3.max_total_sale
FROM t2
JOIN t3
ON t2.CategoryID = t3.CategoryID and t2.CategoryName = t3.CategoryName
WHERE t2.total_sale = t3.max_total_sale;



        
        
        
        
        
        
        
        
        
        
        
        
 