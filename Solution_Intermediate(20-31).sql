|/*
20. Categories, and the total products in each category
For this problem, we’d like to see the total number of
products in each category. Sort the results by the total
number of products, in descending order
*/

SELECT c.CategoryName, count(p.QuantityPerUnit) TotalProducts
FROM Categories as c join Products as p 
on c.CategoryID = p.CategoryID
Group by (c.CategoryName)
Order by TotalProducts DESC

|/*
21. Total customers per country/city
In the Customers table, show the total number of
customers per Country and City.
*/

SELECT Country, City, count(*) TotalCustomer
FROM Customers 
GROUP BY Country,City
Order by TotalCustomer DESC

|/*
22. Products that need reordering
What products do we have in our inventory that should be
reordered? For now, just use the fields UnitsInStock and
ReorderLevel, where UnitsInStock is less than the
ReorderLevel, ignoring the fields UnitsOnOrder and
Discontinued.
Order the results by ProductID.

*/

SELECT ProductID, ProductName, UnitsInStock, ReorderLevel
FROM  Products
WHERE UnitsInStock < ReorderLevel
Order by ProductID

/*
23. Products that need reordering, continued
Now we need to incorporate these fields—UnitsInStock,
UnitsOnOrder, ReorderLevel, Discontinued—into our
calculation. We’ll define “products that need reordering”
with the following:

UnitsInStock plus UnitsOnOrder are less than or
equal to ReorderLevel

The Discontinued flag is false (0).
*/

SELECT ProductID, ProductName, UnitsInStock, UnitsOnOrder, ReorderLevel, Discontinued
FROM  Products
WHERE UnitsInStock + UnitsOnOrder <=  ReorderLevel
AND Discontinued = 0
Order by ProductID

/*
24. Customer list by region
A salesperson for Northwind is going on a business trip
to visit customers, and would like to see a list of all
customers, sorted by region, alphabetically.
However, he wants the customers with no region (null in
the Region field) to be at the end, instead of at the top,
where you’d normally find the null values. Within the
same region, companies should be sorted by CustomerID.
*/

SELECT CustomerID, CompanyName, Region
FROM dbo.Customers 
ORDER BY
  CASE WHEN Region IS NULL THEN 1 ELSE 0 END,
Region, CustomerID ASC

/*
25. High freight charges
Some of the countries we ship to have very high freight
charges. We'd like to investigate some more shipping
options for our customers, to be able to offer them lower
freight charges. Return the three ship countries with the
highest average freight overall, in descending order by
average freight.
*/

SELECT TOP(3) ShipCountry, AVG(Freight) AverageFreight
FROM dbo.Orders 
GROUP BY (ShipCountry)
ORDER BY AverageFreight DESC

/*
26. High freight charges - 2015
We're continuing on the question above on high freight
charges. Now, instead of using all the orders we have, we
only want to see orders from the year 2015.
*/

SELECT TOP(3) ShipCountry, AVG(Freight) AverageFreight
FROM dbo.Orders
WHERE year(OrderDate) = 2015
GROUP BY (ShipCountry)
ORDER BY AverageFreight DESC

/*
27. High freight charges with between
Another (incorrect) answer to the problem above is this:
Select Top 3
ShipCountry ,AverageFreight = avg(freight) 
From Orders Where OrderDate
between '1/1/2015' and '12/31/2015'
Group By ShipCountry Order By AverageFreight desc; Notice when you run
this, it gives Sweden as the ShipCountry with the third highest freight charges.
However, this is wrong - it should be France.
What is the OrderID of the order that the (incorrect)
answer above is missing?
*/

-- Follow this code, so name Sweden (incorrect), it must be france. 
-- because the result not include 31/12/2015
Select Top (3) ShipCountry ,AverageFreight = avg(freight) 
From Orders 
Where OrderDate between '1/1/2015' and '1/1/2016'
Group By ShipCountry
Order By AverageFreight DESC

/*
28. High freight charges - last year
We're continuing to work on high freight charges. We
now want to get the three ship countries with the highest
average freight charges. But instead of filtering for a
particular year, we want to use the last 12 months of
order data, using as the end date the last OrderDate in
Orders
*/
-- Lay ngay cuoi cung  giam xuong 1 nam = dateadd
Select Top (3) ShipCountry, AverageFreight = avg(freight) 
From Orders 
where OrderDate between  
    Dateadd(yy, -1, (Select Max(OrderDate) from Orders))
    and 
    (Select Max(OrderDate) from Orders)
Group By ShipCountry
Order By AverageFreight DESC

/*
29. Inventory list
We're doing inventory, and need to show information like
the below, for all orders. Sort by OrderID and Product
ID
-----------------------------------------------
*/
SELECT E.EmployeeID, E.LastName, O.OrderID, P.ProductName, OD.Quantity
From dbo.Employees as E 
join dbo.Orders as O On E.EmployeeID = O.EmployeeID 
join dbo.OrderDetails as OD On O.OrderID = OD.OrderID
join dbo.Products as P On OD.ProductID = P.ProductID
Order By OD.OrderID, OD.ProductID

/*
30. Customers with no orders
There are some customers who have never actually
placed an order. Show these customers
*/
Select Customers_CustomerID = c.CustomerID
,Orders_CustomerID = o.CustomerID
FROM dbo.Customers c 
LEFT JOIN dbo.Orders o ON o.CustomerId = c.CustomerId
WHERE OrderId IS NULL

/*
31. Customers with no orders for EmployeeID 4

One employee (Margaret Peacock, EmployeeID 4) has
placed the most orders. However, there are some
customers who've never placed an order with her. Show
only those customers who have never placed an order
with her.
Expected
*/
Select c.CustomerID, o.CustomerID
From dbo.Customers c
Left JOIN dbo.Orders o ON c.CustomerID = o.CustomerID and o.EmployeeID = 4
WHERE o.CustomerID is null 

