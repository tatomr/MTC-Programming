--Roderick Tatom
--Homework 1/17/2018

USE AdventureWorks2012


SELECT *
FROM Sales.SalesOrderHeader

--PART 1: a cursor that will cycle through the first 1000 records and assign a random status of 1 through 3

DECLARE StatusGenerator CURSOR FOR 
SELECT TOP 1000 [Status]
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID;

OPEN StatusGenerator

--Moving through the cursor

FETCH NEXT FROM StatusGenerator
DECLARE @State INT
WHILE @@FETCH_STATUS = 0

BEGIN

	
	UPDATE Sales.SalesOrderHeader
	SET [Status] = CAST((RAND()*3) + 1 AS INT)
	WHERE CURRENT OF StatusGenerator

	FETCH NEXT FROM StatusGenerator

	END

CLOSE StatusGenerator
DEALLOCATE StatusGenerator

GO


-- PART 1.2: assign these random statuses to ALL records in the table that are still showing status 5.--

--Assingns random values to remainding numbers

UPDATE Sales.SalesOrderHeader
SET [Status] = ABS(CHECKSUM(NEWID() )% 3) + 1
WHERE [Status] = 5

-- Reset all status numbers back to 5 

UPDATE sales.salesorderheader
SET [status] = 5
USE [AdventureWorks2012]
GO


--PART 2: Write two functions to determine the quantity on hand for a specific product.
--SELECT * FROM [Production].[Product]
--SELECT * FROM [Production].[ProductInventory]

 -- USES THE PRODUCT ID
 --proof -- SELECT dbo.fn_ProductID(3)

CREATE FUNCTION FN_ProductID
(
@ProductID INT
)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @Quantity SMALLINT 
	= (SELECT SUM(Quantity)
	   FROM Production.ProductInventory I 
	   INNER JOIN Production.Product P 
	   ON P.ProductID = I.ProductID 
	   WHERE P.ProductID = @ProductID)

	RETURN @Quantity
END
GO


 -- USES THE PRODUCT NUMBER
--proof-- Select dbo.FN_ProductNumber ('BE-2349')

CREATE FUNCTION FN_ProductNumber

(
@ProductNumber NVARCHAR(35)
)
RETURNS SMALLINT
AS
BEGIN
	DECLARE @Quantity SMALLINT 
	=   (SELECT SUM(Quantity)
	    FROM Production.ProductInventory I 
		INNER JOIN Production.Product P 
		ON P.ProductID = I.ProductID 
		WHERE P.ProductNumber = @ProductNumber)


	RETURN @Quantity
END
GO
  
 