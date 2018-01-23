-- 1) A function that uses the LIKE operator...

 USE AdventureWorks2012
 -- SELECT * FROM Production.Product
 -- Proof Statement --SELECT * FROM dbo.ProductLike ('%BB%')

CREATE FUNCTION  dbo.ProductLike 
(
	@prod varchar (MAX)
)
RETURNS TABLE 
AS
RETURN 
	 SELECT * 

	 FROM
     Production.Product

	 WHERE
	 [Name] LIKE '%' + @prod + '%'
	 
-- 2) Last (n) number of orders in descending order by order date.

-- SELECT * FROM [Sales].[SalesOrderHeader]
-- Proof -- Select * FROM OrderNumber (10)

CREATE FUNCTION OrderNumber 
(
@Orders INT
)
RETURNS TABLE 
AS
RETURN
	SELECT TOP (@Orders) OrderDate
	
	FROM  
		 [Sales].[SalesOrderHeader]

GO


