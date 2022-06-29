 /* 32. High-value customers We want to send all of our high-value customers a special VIP gift. We're defining high-value customers as those who've made at least 1 order with a total value (not including the discount) equal to $10,000 or more. We only want to consider orders made in the year 2016. Expected Result CustomerID CompanyName OrderID TotalOrd */  Select c.CustomerID, c.CompanyName, o.OrderID,  	TotalOrderAmount = sum(od.Quantity * od.UnitPrice)  From dbo.Orders o 	join dbo.OrderDetails od on o.OrderID = od.OrderID 	join dbo.Customers c on o.CustomerID = c.CustomerID WHERE year(o.OrderDate) = 2016 GROUP BY c.CustomerID, c.CompanyName, o.OrderID having sum(od.Quantity * od.UnitPrice) >= 10000  ORDER by TotalOrderAmount DESC  /* 33. High-value customers - total orders The manager has changed his mind. Instead of requiring that customers have at least one individual orders totaling $10,000 or more, he wants to define high-value customers as those who have orders totaling $15,000 or more in 2016. How would you change the answer to the problem above? */  select  	c.CustomerID,  	c.CompanyName, 	TotalOrderAmount = sum(od.Quantity * od.UnitPrice) From dbo.Orders o 	join dbo.OrderDetails od on o.OrderID = od.OrderID 	join dbo.Customers c on o.CustomerID = c.CustomerID WHERE year(o.OrderDate) =  2016 GROUP BY c.CustomerID, c.CompanyName having sum(od.Quantity * od.UnitPrice) > 15000 ORDER by TotalOrderAmount DESC  /* 34: High-value customers _ with discount  Change the above query to use the discount when calculating  high-value customers. Order by the total amount which includes the discount. */ select  	c.CustomerID,  	c.CompanyName, 	TotalOrderAmount = sum(od.Quantity * od.UnitPrice*(1-od.Discount)) From dbo.Orders o 	join dbo.OrderDetails od on o.OrderID = od.OrderID 	join dbo.Customers c on o.CustomerID = c.CustomerID WHERE year(o.OrderDate) =  2016 GROUP BY c.CustomerID, c.CompanyName, od.Discount having sum(od.Quantity * od.UnitPrice *(1-od.Discount)) >= 15000 ORDER by TotalOrderAmount DESC  /* 35. Month-end orders At the end of the month, salespeople are likely to try much harder to get orders, to meet their month-end quotas. Show all orders made on the last day of the month. Order by EmployeeID and OrderID */   Select EmployeeID, OrderID, OrderDate From Orders WHERE OrderDate = EOMONTH(OrderDate) Order By EmployeeID  /* 36. Orders with many line items The Northwind mobile app developers are testing an app that customers will use to show orders. In order to make sure that even the largest orders will show up correctly on the app, they'd like some samples of orders that have lots of individual line items. Show the 10 orders with the most line items, in order of total line items. */   Select Top (10) o.OrderID, TotalOrderDetails = count(od.[OrderID])  From Orders o  	join dbo.OrderDetails od on o.OrderID = od.OrderID Group by(o.OrderID) Order By count(od.OrderID) DESC  /* 37. Orders - random assortment The Northwind mobile app developers would now like to just get a random assortment of orders for beta testing on their app. Show a random set of 2% of all orders.  */ Select top 2 percent OrderID From Orders Order By NewID()  /* 37. Orders - random assortment The Northwind mobile app developers would now like to just get a random assortment of orders for beta testing on their app. Show a random set of 2% of all orders.  */ Select top 2 percent OrderID From Orders Order By NewID()  /* 38. Orders - accidental double-entry Janet Leverling, one of the salespeople, has come to you with a request. She thinks that she accidentally doubleentered a line item on an order, with a different ProductID, but the same quantity. She remembers that the quantity was 60 or more. Show all the OrderIDs with line items that match this, in order of OrderID */  select  OrderID, Quantity,count_order=count(*) From dbo.OrderDetails Where Quantity >= 60 Group by OrderID, Quantity Having count(*) >1 ORDER BY OrderID  /* 39. Orders - accidental double-entry details Based on the previous question, we now want to show details of the order, for orders that match the above criteria.  */  With double_entry as(  	Select OrderID, Quantity 	From dbo.OrderDetails 	Where Quantity >= 60 	Group by OrderID, Quantity 	Having count(*) >1 	) select * From dbo.OrderDetails  Where OrderID in (Select OrderID from double_entry)  /* 40. Orders - accidental double-entry details, derived table Here's another way of getting the same results as in the previous problem, using a derived table instead of a CTE. However, there's a bug in this SQL. It returns 20 rows instead of 16. Correct the SQL.  Problem SQL: Select OrderDetails.OrderID ,ProductID ,UnitPrice ,Quantity ,Discount From OrderDetails Join ( Select OrderID From OrderDetails Where Quantity >= 60 Group By OrderID, Quantity Having Count(*) > 1 ) PotentialProblemOrders on PotentialProblemOrders.OrderID = OrderDetails.OrderID Order by OrderID, ProductID */ -- Error is have duplicate OrderID 10263 ->> add distinct Select distinct OrderDetails.OrderID,ProductID ,UnitPrice ,Quantity ,Discount  From OrderDetails Join ( 	Select OrderID 	From OrderDetails  	Where Quantity >= 60 	Group By OrderID, Quantity  	Having Count(*) > 1 	)  PotentialProblemOrders on PotentialProblemOrders.OrderID = OrderDetails.OrderID Order by OrderID, ProductID  /* 41. Late orders Some customers are complaining about their orders arriving late. Which orders are late? */  SELECT OrderID, cast(OrderDate as date),cast(RequiredDate as date), cast(ShippedDate as date) FROM dbo.Orders  WHERE ShippedDate >= RequiredDate order by ShippedDate  /* 42. Late orders - which employees? Some salespeople have more orders arriving late than others. Maybe they're not following up on the order process, and need more training. Which salespeople have the most orders arriving late? */ With Late_orders as( 	SELECT OrderID 	FROM dbo.Orders  	WHERE ShippedDate >= RequiredDate ) SELECT e.EmployeeID, e.LastName, TotalLateOrders = count(o.EmployeeID) FROM dbo.Orders o  	join dbo.Employees e on o.EmployeeID = e.EmployeeID Where o.OrderID in (Select OrderID from Late_orders) Group by e.EmployeeID, LastName order by TotalLateOrders DESC  /* 43. Late orders vs. total orders Andrew, the VP of sales, has been doing some more thinking some more about the problem of late orders. He realizes that just looking at the number of orders arriving late for each salesperson isn't a good idea. It needs to be compared against the total number of orders per salesperson. Return results like the following:  */ With Lateorder as( 	Select EmployeeID, Total_late = Count(*)  	From Orders Where RequiredDate <= ShippedDate 	Group By EmployeeID ), Allorder as( 	Select EmployeeID, TotalOrders = Count(*)  	From Orders  	Group By EmployeeID ) SELECT e.EmployeeID, e.LastName, Allorder.TotalOrders, Lateorder.Total_late FROM dbo.Employees e 	join Allorder on Allorder.EmployeeID = e.EmployeeID 	join Lateorder on Lateorder.EmployeeID = e.EmployeeID Order by Allorder.TotalOrders DESC    /* 45. Late orders vs. total orders - fix null Continuing on the answer for above query, let's fix the results for row 5 - Buchanan. He should have a 0 instead of a Null in LateOrders */ With Lateorder as( 	Select EmployeeID, Total_late = Count(*)  	From Orders Where RequiredDate <= ShippedDate 	Group By EmployeeID ), Allorder as( 	Select EmployeeID, TotalOrders = Count(*)  	From Orders  	Group By EmployeeID ) SELECT e.EmployeeID, e.LastName, Allorder.TotalOrders,  LateOrders =IsNull(Lateorder.Total_late, 0) FROM dbo.Employees e 	left join Lateorder on Lateorder.EmployeeID = e.EmployeeID 	left join Allorder on Allorder.EmployeeID = e.EmployeeID  /* 46. Late orders vs. total orders - percentage Now we want to get the percentage of late orders over total orders. */   With Lateorder as( 	Select EmployeeID, Total_late = Count(*)  	From Orders Where RequiredDate <= ShippedDate 	Group By EmployeeID ), Allorder as( 	Select EmployeeID, TotalOrders = Count(*)  	From Orders  	Group By EmployeeID ) SELECT e.EmployeeID, e.LastName, Allorder.TotalOrders,  LateOrders =IsNull(Lateorder.Total_late, 0),  IsNull(Lateorder.Total_late, 0)*1.00 / Allorder.TotalOrders   PercentLateOrders FROM dbo.Employees e 	left join Lateorder on Lateorder.EmployeeID = e.EmployeeID 	left join Allorder on Allorder.EmployeeID = e.EmployeeID  /* 47. Late orders vs. total orders - fix decimal */ With Lateorder as( 	Select EmployeeID, Total_late = Count(*)  	From Orders Where RequiredDate <= ShippedDate 	Group By EmployeeID ), Allorder as( 	Select EmployeeID, TotalOrders = Count(*)  	From Orders  	Group By EmployeeID ) SELECT e.EmployeeID, e.LastName, Allorder.TotalOrders,  LateOrders= IsNull(Lateorder.Total_late, 0), cast(IsNull(Lateorder.Total_late, 0)*1.00 / Allorder.TotalOrders as Decimal(2,2)) PercentLateOrders FROM dbo.Employees e 	left join Lateorder on Lateorder.EmployeeID = e.EmployeeID 	left join Allorder on Allorder.EmployeeID = e.EmployeeID  /* 48. Customer grouping
Andrew Fuller, the VP of sales at Northwind, would like
to do a sales campaign for existing customers. 
He'd like to categorize customers into groups, based on how much
they ordered in 2016. Then, depending on which group
the customer is in, he will target the customer with
different sales materials.

customer grouping 0 to 1,000 -> low 1,000 to 5,00 -> medium 5,000 to 10,000 -> High  over 10,000. -> Veryhigh

A good starting point for this query is the answer from
the problem “High-value customers - total orders. We
don’t want to show customers who don’t have any orders
in 2016.
Order the results by CustomerID.

 */ ;With AllOrders2016 as( 	SELECT c.CustomerID, c.CompanyName, 		TotalOrderAmount = SUM(od.Quantity *od.UnitPrice) 	FROM dbo.Customers c  		join dbo.Orders o on o.CustomerID = c.CustomerID 		join dbo.OrderDetails od on od.OrderID = o.OrderID 	WHERE year(OrderDate) = '2016' 	Group by c.CustomerID, c.CompanyName ) Select CustomerID, CompanyName, TotalOrderAmount,
CustomerGroup =
CASE
    WHEN a.TotalOrderAmount >0 and a.TotalOrderAmount <=1000 THEN 'Low'
	WHEN a.TotalOrderAmount >1000 and a.TotalOrderAmount <=5000 THEN 'Medium'
    WHEN a.TotalOrderAmount >5000 and a.TotalOrderAmount <=10000 THEN 'High'
    WHEN a.TotalOrderAmount >10000 THEN 'Very High'
END From AllOrders2016 a Order by CustomerID
/*
49. Customer grouping - fix null
There's a bug with the answer for the previous question.
The CustomerGroup value for one of the rows is null.
Fix the SQL so that there are no nulls in the
CustomerGroup field
*/
SELECT  	c.CustomerID, c.CompanyName, 	TotalOrderAmount = SUM(od.Quantity *od.UnitPrice),
	CustomerGroup=
	CASE
		WHEN SUM(od.Quantity *od.UnitPrice) Between 0 and 1000 THEN 'Low'
		WHEN SUM(od.Quantity *od.UnitPrice) Between 1000 and 5000 THEN 'Medium'
		WHEN SUM(od.Quantity *od.UnitPrice) Between 5000 and 10000 THEN 'High'
		WHEN SUM(od.Quantity *od.UnitPrice) > 10000 THEN 'Very High'
	END
FROM dbo.Customers c  	join dbo.Orders o on o.CustomerID = c.CustomerID 	join dbo.OrderDetails od on od.OrderID = o.OrderID WHERE year(OrderDate) = '2016' Group by c.CustomerID, c.CompanyName ORDER BY CustomerID  /* 50. Customer grouping with percentage
Based on the above query, show all the defined
CustomerGroups, and the percentage in each. Sort by the
total in each group, in descending order */

With Group_customer as(
SELECT CustomerID,
	CustomerGroup=
	CASE
		WHEN SUM(od.Quantity *od.UnitPrice) Between 0 and 1000 THEN 'Low'
		WHEN SUM(od.Quantity *od.UnitPrice) Between 1000 and 5000 THEN 'Medium'
		WHEN SUM(od.Quantity *od.UnitPrice) Between 5000 and 10000 THEN 'High'
		WHEN SUM(od.Quantity *od.UnitPrice) > 10000 THEN 'Very High'
	END
FROM dbo.Orders o 	join dbo.OrderDetails od on od.OrderID = o.OrderID WHERE year(OrderDate) = '2016' Group by CustomerID ), Total as( 	SELECT CustomerGroup, TotalInGroup = count(*)
	FROM Group_customer 	group by CustomerGroup  ) Select CustomerGroup, TotalInGroup, PercentageInGroup = TotalInGroup*1.00 / (SELECT SUM(TotalInGroup) FROM Total) FROM Total
Group by CustomerGroup,TotalInGroup
order by TotalInGroup desc

/* 51. Customer grouping - flexible

Andrew, the VP of Sales is still thinking about how best to group customers, 
and define low, medium, high, andvery high value customers. 
He now wants completeflexibility in grouping the customers,
based on the dollar amount they've ordered. He doesn’t want to have to edit
SQL in order to change the boundaries of the customer groups.

How would you write the SQL?
There's a table called CustomerGroupThreshold that you
will need to use. Use only orders from 2016 */ With Order2016 as(
	Select c.CustomerID, c.CompanyName, 		TotalOrderAmount = SUM(Quantity * UnitPrice) 	From dbo.customers c  		join dbo.orders o on c.CustomerID = o.CustomerID 		join dbo.orderDetails od on od.OrderID = o.OrderID 	Where 		year(OrderDate) = 2016 		Group by c.CustomerID,c.CompanyName ) SELECT CustomerID, CompanyName, TotalOrderAmount, CustomerGroupName FROM Order2016 	Join dbo.CustomerGroupThresholds cgt on Order2016.TotalOrderAmount  		Between cgt.RangeBottom and cgt.RangeTop Order by TotalOrderAmount  /* 52. Countries with suppliers or customers

Some Northwind employees are planning a business trip,
and would like to visit as many suppliers and customers
as possible. For their planning, they’d like to see a list of
all countries where suppliers and/or customers are based. */ Select Country  FROM dbo.Suppliers union Select Country  FROM dbo.Customers  /* 53. Countries with suppliers or customers,
version 2
The employees going on the business trip don’t want just
a raw list of countries, they want more details. We’d like
to see output like the below, in the Expected Results */ With sc as( 	Select distinct Country  	FROM dbo.Suppliers ), cc as( 	Select distinct Country  	FROM dbo.Customers ) Select SupplierCountry = sc .Country, CustomerCountry = cc .Country From sc  	full outer join cc on sc .Country = cc .Country  /*sc .Country = cc .Country 54. Countries with suppliers or customers - version 3
The output of the above is improved, but it’s still not
ideal
What we’d really like to see is the country name, the total
suppliers, and the total customers. */ With sc as( 	Select Country, total = count(*)  	FROM dbo.Suppliers 	group by Country ), cc as( 	Select Country, total = count(*)  	FROM dbo.Customers 	group by Country ), group_c as( 	Select Country  	FROM dbo.Suppliers 	union 	Select Country  	FROM dbo.Customers ) Select gc.Country,  	TotalSuppliers = isnull(sc.total,0),  	TotalCustomers=isnull(cc.total,0) from group_c gc 	full outer join  sc on sc.Country = gc.Country 	full outer join cc on cc.Country = gc.Country Group by gc.Country,sc.total,cc.total  /* 55. First order in each country
Looking at the Orders table—we’d like to show details
for each order that was the first in that particular country,
ordered by OrderID.
So, we need one row per ShipCountry, and CustomerID,
OrderID, and OrderDate should be of the first order from
that country */ With OrderByCountry as( SELECT ShipCountry, CustomerID, OrderID,  	OrderDate = convert(date,OrderDate), 	row_num = Row_Number()
		over(Partition by ShipCountry Order by ShipCountry, OrderID) From dbo.Orders ) Select ShipCountry, CustomerID, OrderID, OrderDate  as 'First order date' From OrderByCountry Where row_num = 1 Order by ShipCountry  /* 56. First order in each country
Looking at the Orders table—we’d like to show details
for each order that was the first in that particular country,
ordered by OrderID.
So, we need one row per ShipCountry, and CustomerID,
OrderID, and OrderDate should be of the first order from
that country */ With OrderByCountry as( SELECT ShipCountry, CustomerID, OrderID,  	OrderDate = convert(date,OrderDate), 	row_num = Row_Number()
		over(Partition by ShipCountry Order by ShipCountry, OrderID) From dbo.Orders ) Select ShipCountry, CustomerID, OrderID, OrderDate  as 'First order date' From OrderByCountry Where row_num = 1 Order by ShipCountry   /* 56. Customers with multiple orders in 5 day
period

There are some customers for whom freight is a major
expense when ordering from Northwind.

However, by batching up their orders, and making one
larger order instead of multiple smaller orders in a short
period of time, they could reduce their freight costs
significantly.

Show those customers who have made more than 1 order
in a 5 day period. The sales people will use this to help
customers reduce their costs.

Note: There are more than one way of solving this kind
of problem. For this problem, we will not be using
Window functions.
 */  SELECT 
	ord1.CustomerID, 
	InitialOrderID = ord1.OrderID, 
	InitialOrderDate = convert(date,ord1.OrderDate),
	NextOrderID = ord2.OrderID, 
	NextOrderDate = convert(date,ord2.OrderDate),
	DaysBetween = datediff(dd,ord1.OrderDate, ord2.OrderDate) From Orders ord1  	join Orders ord2 on ord1.CustomerID = ord2.CustomerID Where   	ord1.OrderDate < ord2.OrderDate 	and datediff(dd,ord1.OrderDate,ord2.OrderDate) <=5 Order by ord1.CustomerID, ord1.OrderID  /* 57. Customers with multiple orders in 5 day
period, version 2
There’s another way of solving the problem above, using
Window functions. We would like to see the following
results
 */ With NextDate as( 	SELECT 
		CustomerID, 
		OrderDate = convert(date,OrderDate), 		NextOrderDate =convert(date, Lead(OrderDate,1) 
			OVER (Partition by CustomerID order by CustomerID, OrderDate)  		) 	From Orders ) SELECT *, DaysBetweenOrders = DateDiff (dd, OrderDate, NextOrderDate) From NextDate
Where DateDiff (dd, OrderDate,NextOrderDate) <= 5
Order by CustomerID,OrderDate -----Finally, It's Doneeeeeeeeeeeeeeeee!!!