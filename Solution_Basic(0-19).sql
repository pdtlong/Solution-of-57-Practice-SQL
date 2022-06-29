/*
1. Which shippers do we have?
We have a table called Shippers. Return all the fields
from all the shippers Expected Results ShipperID CompanyName Phone
----------- --------------------
*/

SELECT * FROM Shippers

/*
2. Certain fields from Categories
In the Categories table, selecting all the fields using this SQL:
CategoryName and Description
*/
SELECT CategoryName, Description FROM dbo.Categories

/*
3. Sales Representatives
We’d like to see just the FirstName, LastName, and
HireDate of all the employees with the Title of Sales
Representative. Write a SQL statement that returns only
those employees
*/
SELECT FirstName, LastName, HireDate FROM dbo.Employees
WHERE Title = 'Sales Representative' 

/*
4. Sales Representatives
We’d like to see just the FirstName, LastName, and
HireDate of all the employees with the Title of Sales
Representative. Write a SQL statement that returns only
those employees
*/
SELECT FirstName, LastName, HireDate FROM dbo.Employees
WHERE Title = 'Sales Representative' and Country = 'USA'

/*
5. Orders placed by specific EmployeeID
Show all the orders placed by a specific employee. The
EmployeeID for this Employee (Steven Buchanan) is 5.
Expected Results
OrderID OrderDate ----------- ----------------------
*/
SELECT o.OrderID, o.OrderDate 
FROM dbo.Orders as o join dbo.Employees as e on e.EmployeeID = o.EmployeeID
WHERE e.EmployeeID  = '5'

/*
6. Suppliers and ContactTitles In the Suppliers table, show the SupplierID,
ContactName, and ContactTitle for those Suppliers
whose ContactTitle is not Marketing Manager
*/
SELECT SupplierID, ContactName, ContactTitle
FROM dbo.Suppliers 
WHERE not ContactTitle  = 'Marketing Manager'

/*
7. Products with “queso” in ProductName In the products table, we’d like to see the ProductID and
ProductName for those products where the ProductName includes the string “queso”
*/
SELECT ProductID, ProductName
FROM dbo.Products
WHERE ProductName like '%queso%'

/*
8. Orders shipping to France or Belgium Looking at the Orders table, there’s a field called
ShipCountry. Write a query that shows the OrderID, CustomerID, and ShipCountry for the orders where the
ShipCountry is either France or Belgium
*/
SELECT OrderID, CustomerID, ShipCountry
FROM dbo.Orders
WHERE ShipCountry in ('France', 'Belgium')

/*
9. Orders shipping to any country in Latin America
Now, instead of just wanting to return all the orders from
France of Belgium, we want to show all the orders from
any Latin American country. But we don’t have a list of
Latin American countries in a table in the Northwind
database. So, we’re going to just use this list of Latin
American countries that happen to be in the Orders table:
Brazil Mexico Argentina Venezuela It doesn’t make
sense to use multiple Or statements anymore, it would get
too convoluted. Use the In statement.

*/
SELECT OrderID, CustomerID, ShipCountry
FROM dbo.Orders
WHERE ShipCountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela')

/*
10. Employees, in order of age For all the employees in the Employees table, 
show the FirstName, LastName, Title, and BirthDate. Order the
results by BirthDate, so we have the oldest employees
first
*/
SELECT FirstName, LastName, Title, BirthDate
FROM dbo.Employees Order by BirthDate ASC

/*
11. Showing only the Date with a DateTime
field In the output of the query above, showing the Employees
in order of BirthDate, we see the time of the BirthDate
field, which we don’t want. Show only the date portion of
the BirthDate field. 
*/
SELECT FirstName, LastName, Title, CAST(BirthDate As Date) DateOnlyBirthDate
FROM dbo.Employees Order by BirthDate ASC


/*
12. Employees full name
Show the FirstName and LastName columns from the
Employees table, and then create a new column called
FullName, showing FirstName and LastName joined
together in one column, with a space in-between.
Expected Results
FirstName LastName FullName
*/

SELECT FirstName,LastName, concat(FirstName,'', LastName) FullName
FROM dbo.Employees

/*
14. How many customers?
How many customers do we have in the Customers table?
Show one value only, and don’t rely on getting the
recordcount at the end of a resultset.
*/
SELECT count(*) TotalCustomers
FROM dbo.Customers

/*
15. When was the first order?
Show the date of the first order ever made in the Orders
table.
*/
SELECT Min(OrderDate) FirstOrder
FROM dbo.Orders

/*
16. Countries where there are customers
Show a list of countries where the Northwind company
has customers
----------
*/
SELECT Country FROM dbo.Customers
Group by (Country)

/*
17. Contact titles for customers
Show a list of all the different values in the Customers
table for ContactTitles. Also include a count for each
ContactTitle.
This is similar in concept to the previous question
“Countries where there are customers”
, except we now want a count for each ContactTitle.
*/
SELECT ContactTitle, count(ContactTitle) TotalContactTitl FROM dbo.Customers
GROUP by (ContactTitle) 
ORDER BY TotalContactTitl DESC

/*
18. Products with associated supplier names

We’d like to show, for each product, the associated
Supplier. Show the ProductID, ProductName, and the
CompanyName of the Supplier. Sort by ProductID.
This question will introduce what may be a new concept,
the Join clause in SQL. The Join clause is used to join
two or more relational database tables together in a
logical way. Here’s a data model of the relationship between Products
and Suppliers
*/
SELECT ProductID, ProductName, CompanyName as Supplier
FROM dbo.Suppliers as s join dbo.Products as p
on s.SupplierID = p.SupplierID
ORDER BY ProductID ASC


/*
19. Orders and the Shipper that was used
We’d like to show a list of the Orders that were made,
including the Shipper that was used. Show the OrderID,
OrderDate (date only), and CompanyName of the
Shipper, and sort by OrderID.

show only those rows with an OrderID of less than 10300
*/
SELECT OrderID, cast(OrderDate as date), CompanyName Shipper
FROM dbo.Orders as o join dbo.Shippers as s
on o.ShipVia = s.ShipperID 
Where OrderID < 10300
ORDER BY OrderID ASC


