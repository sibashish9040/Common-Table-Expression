/* Here we will break our whole query into small steps and then we will proceed 
by repeating the code and watching the extra thing we are adding in it*/

-- step1: Find the total sales per customer
-- step2: Find the last order date per customer
-- Step3: Rank our customers based on Total Sales per Customer
-- step4: Segment customers based on their total sales


-- step1: Find the total sales per customer
WITH CTE_Total_Sales AS
(	
	SELECT
		 CustomerID,
		 SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID)
--Main query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID


-- step2: Find the last order date per customer

WITH CTE_Total_Sales AS
(	
	SELECT
		 CustomerID,
		 SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID),
	--Here we'll add our 2nd step solution
	CTE_Last_Order AS 
(
	SELECT
		CustomerID,
		MAX(OrderDate) AS Last_order
		FROM Sales.Orders
		GROUP BY CustomerID
)
--Main query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_order
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID


-- Step3: Rank our customers based on Total Sales per 
WITH CTE_Total_Sales AS
(	
	SELECT
		 CustomerID,
		 SUM(Sales) AS TotalSales
	FROM Sales.Orders
	GROUP BY CustomerID),
	--Here we'll add our 2nd step solution
	CTE_Last_Order AS 
(
	SELECT
		CustomerID,
		MAX(OrderDate) AS Last_order
		FROM Sales.Orders
		GROUP BY CustomerID),
	--step3: included after this
	CTE_Rank_Cust AS
(
	SELECT
	CustomerID,
	TotalSales,
	RANK() OVER(ORDER BY TotalSales) CustomerRank
	FROM CTE_Total_Sales 
),
-- Lets add our step4 here
	CTE_Customer_segments AS 
	(
	SELECT
	CustomerID,
	TotalSales,
	CASE
		WHEN TotalSales > 100 THEN 'High'
		WHEN TotalSales > 50 THEN 'Medium'
		ELSE 'Low'
	END AS Customer_category
	FROM CTE_Total_Sales
	)

--Main query
SELECT
c.CustomerID,
c.FirstName,
c.LastName,
cts.TotalSales,
clo.Last_order,
crc.CustomerRank,
ccs.Customer_category
FROM Sales.Customers c
LEFT JOIN CTE_Total_Sales cts
ON cts.CustomerID = c.CustomerID
LEFT JOIN CTE_Last_Order clo
ON clo.CustomerID = c.CustomerID
LEFT JOIN CTE_Rank_Cust crc
ON crc.CustomerID= c.CustomerID
LEFT JOIN CTE_Customer_segments ccs
ON ccs.CustomerID = c.CustomerID



-- Lets do some practice for the recursive CTE
-- Task1: Generate a sequence of Number from 1 to 20

WITH Series AS(
--Anchor query
	SELECT 
	1 AS MyNumber
	UNION ALL
	--Recursive query
	SELECT
	MyNumber + 1
	FROM Series
	WHERE MyNumber < 50
)
SELECT
*
FROM Series
OPTION(MAXRECURSION 100)

-- Show the employee hierarchy by displaying each employee's level with the organization
WITH CTE_Emp_Hierarchy AS(
--Anchor query
SELECT
	EmployeeID,
	FirstName,
	ManagerID,
	1 AS Level
FROM Sales.Employees
WHERE ManagerID IS NULL
UNION ALL
--recursive
SELECT
	e.EmployeeID,
	e.FirstName,
	e.ManagerID,
	Level + 1
FROM Sales.Employees AS e
INNER JOIN CTE_Emp_Hierarchy ceh -- it ensures the break bcz when there will not more rows to join 
ON e.ManagerID = ceh.EmployeeID
)
SELECT
*
FROM CTE_Emp_Hierarchy