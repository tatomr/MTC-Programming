

-- 1. Credit Card: User-Defined Function
USE ADVENTUREWORKS2012 
GO
DROP FUNCTION sales.fnCardExpirationDate;
DROP FUNCTION dbo.fnProvinceTax
DROP FUNCTION dbo.InchesToCentimeters
GO

Create FUNCTION [sales].[fnCardExpirationDate]

(
@card nvarchar (25)
)

RETURNS VARCHAR(MAX)
AS
BEGIN

DECLARE @Expiration VARCHAR(MAX)

SET @Expiration = (

SELECT EOMONTH (CONVERT (DATE, CAST((expyear * 100 + expmonth) AS VARCHAR (6)) + '01'))
FROM sales.CreditCard CC
WHERE CardNumber = @card
)

Return

@Expiration

END
GO

SELECT sales.fnCardExpirationDate (33332664695310) [expiation]

-- 2. Tax Rate: User Defined Function

CREATE FUNCTION [dbo].[fnProvinceTax] (@StateProvince INT, @SalesTax INT)
RETURNS SMALLMONEY
AS
BEGIN
DECLARE @TaxRate DECIMAL (5,2)

SET @TaxRate = (SELECT TaxRate 
				FROM Sales.SalesTaxRate
				WHERE Taxtype = @SalesTax AND StateProvinceID = @StateProvince)

IF @TaxRate IS NULL
    SET @TaxRate = 0

RETURN @TaxRate
END

GO

-- 2. Tax Rate: TEST QUERY 

SELECT [dbo].[fnProvinceTax] (15,1) AS TAXMAN 

-- 3. Accept inches and return centimeters


CREATE FUNCTION dbo.InchesToCentimeters (@Input int)
RETURNS INT
AS
BEGIN
DECLARE @Output INT =(@input * 2.54)
RETURN @Output
END

GO