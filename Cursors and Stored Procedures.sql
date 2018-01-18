DECLARE StatusGenerator CURSOR
FOR SELECT RevisionNumber FROM Sales.SalesOrderHeader

OPEN StatusGenerator

--Moving through the cursor

FETCH NEXT FROM StatusGenerator

WHILE @@FETCH_STATUS = 0
	FETCH NEXT FROM StatusGenerator

CLOSE StatusGenerator
DEALLOCATE StatusGenerator

SELECT * FROM [Sales].[SalesOrderHeader]