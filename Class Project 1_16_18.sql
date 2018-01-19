
--Exercise 1.1
--Use the SELECT ... INTO syntax to select from a table and output the records into a new table.

SELECT p.BusinessEntityID, CONCAT(p.LastName, ',', p.FirstName) AS [Employee Name], e.Gender,
	   e.JobTitle, e.HireDate
INTO TempTableEmployees
FROM Person.Person p 
INNER JOIN HumanResources.Employee e
ON p.BusinessEntityID 
  = e.BusinessEntityID
ORDER BY HireDate DESC


select * from TempTableEmployees

-- Exercise 1.2
-- Use the SELECT ... INTO syntax to select from a table and output the records into a new table.
-- select * from HumanResources.EmployeePayHistory

SELECT h.BusinessEntityID, h.RateChangeDate, h.Rate
--INTO TempTableEmployeePayHistory
FROM HumanResources.EmployeePayHistory h
INNER JOIN HumanResources.Employee e
ON h.BusinessEntityID
   = e.BusinessEntityID
WHERE e.CurrentFlag <> 0
GROU e.BusinessEntityID




