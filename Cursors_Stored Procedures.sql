--Roderick Tatom
--Homework 1/17/2018

USE AdventureWorks2012

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

--Proof-- SELECT * FROM Sales.SalesOrderHeader



--PART 2: Write two functions to determine the quantity on hand for a specific product.
--SELECT * FROM [Production].[Product]
--SELECT * FROM [Production].[ProductInventory]

 -- USES THE PRODUCT ID
 --proof -- SELECT dbo.fn_ProductID(3)

 USE AdventureWorks2012
 GO

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

USE AdventureWorks2012 
GO

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
  
-- PART 3: examine all records in the table and set orders to status 5 (shipped) where conditions are met
USE AdventureWorks2012
GO
CREATE PROCEDURE sp_OrdersShipped
AS
BEGIN
		
  WITH Shipped AS
  (SELECT soh.*
   FROM Sales.SalesOrderHeader soh 
	INNER JOIN Sales.SalesOrderDetail sod 
	ON soh.SalesOrderID = sod.SalesOrderID 
	INNER JOIN Production.ProductInventory i 
	ON sod.ProductID = i.ProductID
	WHERE [Status] IN (1, 2, 3) OR 
	soh.BillToAddressID IS NOT NULL OR 
	soh.ShipToAddressID IS NOT NULL OR 
	soh.CreditCardID IS NOT NULL OR 
	soh.CreditCardApprovalCode IS NULL)
				
		UPDATE Sales.SalesOrderHeader
		SET [Status] = 5
	WHERE SalesOrderID IN (SELECT SalesOrderID FROM shipped)

END
GO

-- EXEC sp_OrdersShipped
-- proof --- select * from Sales.SalesOrderHeader
