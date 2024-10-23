Use AdventureWorks2012


-- Display any Product with a Name starting with the letter B
SELECT *
FROM Production.Product
WHERE Name LIKE 'B%';


-- Write a query that displays any Product description with underscore value in its description.
UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%_%';



-- Calculate sum of TotalDue for each OrderDate in Sales.SalesOrderHeader table for the period between  '7/1/2001' and '7/31/2014'
SELECT OrderDate, SUM(TotalDue) AS TotalDue
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '20010701' AND '20140731'
GROUP BY OrderDate;



-- Calculate the average of the unique ListPrices in the Product table
SELECT AVG(DISTINCT ListPrice) AS AverageListPrice
FROM Production.Product;



-- Display the Product Name and its ListPrice within the values of 100 and 120 the list should has the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
SELECT 'The ' + Name + ' is only! ' + CAST(ListPrice AS VARCHAR) AS ProductInfo
FROM Production.Product
WHERE ListPrice BETWEEN 100 AND 120
ORDER BY ListPrice;



-- Using union statement, retrieve the today’s date in different styles using convert or format funtion.
SELECT GETDATE() AS TodayDate
UNION
SELECT CONVERT(VARCHAR, GETDATE(), 101) AS TodayDate
UNION
SELECT CONVERT(VARCHAR, GETDATE(), 103) AS TodayDate
UNION
SELECT CONVERT(VARCHAR, GETDATE(), 107) AS TodayDate
UNION
SELECT FORMAT(GETDATE(), 'dd-MM-yyyy') AS TodayDate
UNION
SELECT FORMAT(GETDATE(), 'MM/dd/yyyy') AS TodayDate
UNION
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') AS TodayDate;