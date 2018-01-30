--Roderick Tatom
--HomeWork 1/24/2018
--VeterinaryDB

USE MASTER;

--Database Checked, if true Drop VetDB

IF (SELECT COUNT(*) 
	FROM sys.databases WHERE name = 'VeterinaryDB') > 0
	
BEGIN
DROP DATABASE VeterinaryDB
PRINT 'VeterinaryDB Dropped'
END

--System logins checked if true dropped

IF (SELECT COUNT(*) 
	FROM master.dbo.syslogins WHERE Name = 'VetManager') > 0
BEGIN

DROP LOGIN VetManager
PRINT 'VetManager Login Dropped'

END

IF (SELECT COUNT(*) 
	FROM master.dbo.syslogins WHERE Name = 'VetClerk') > 0
BEGIN

DROP LOGIN VetClerk
PRINT 'VetClerk Login Dropped'
END

-- Create new database VeterinaryDB

CREATE DATABASE VeterinaryDB
PRINT 'VeterinaryDB Created'

-- VET Manager and VET Clerk Login Created 

CREATE LOGIN VetManager 
	WITH PASSWORD = 'clastost08'

CREATE LOGIN VetClerk
	 WITH PASSWORD = 'flounder55'

ALTER LOGIN VetManager
	 WITH DEFAULT_DATABASE = VeterinaryDB

ALTER LOGIN VetClerk 
	WITH DEFAULT_DATABASE = VeterinaryDB
	
PRINT 'VetManager & VetClerk Login Created'
GO

USE VeterinaryDB

-- VET Manager and VET Clerk Users Created
CREATE USER VetManager
	 FOR LOGIN VetManager

CREATE USER VetClerk
	 FOR LOGIN VetClerk

ALTER ROLE db_datareader ADD MEMBER VetManager;

ALTER ROLE db_datawriter ADD MEMBER VetManager;

ALTER ROLE db_datareader ADD MEMBER VetClerk

PRINT 'VetManager & VetClerk Users Created'
;
GO

GO
;

CREATE TABLE Clients
(	ClientID INT NOT NULL IDENTITY (1,1),
	Firstname VARCHAR (25) NOT NULL,
	Lastname VARCHAR (25) NOT NULL,
	Middlename VARCHAR (25),
	CreateDate DATE NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Clients_ClinetID PRIMARY KEY (ClientID)
)

PRINT 'Clients Table Created'

CREATE TABLE ClientContacts
(	AddressID INT NOT NULL IDENTITY (1,1),
	ClientID INT NOT NULL,
	AddressType	INT NOT NULL,
	AddressLine1 VARCHAR (50) NOT NULL,
	AddressLine2 VARCHAR (50) NULL,
	City VARCHAR (35) NOT NULL,
	StateProvince VARCHAR (25) NOT NULL,
	PostalCode VARCHAR (15) NOT NULL,
	Phone VARCHAR (15) NOT NULL,
	AltPhone VARCHAR (15) NULL,
	Email VARCHAR (35) NOT NULL
	CONSTRAINT PK_ClientsContacts_AddressID PRIMARY KEY (AddressID)
	CONSTRAINT FK_ClientContacts_Clients FOREIGN KEY (ClientID) REFERENCES Clients (ClientID),
	CONSTRAINT CHK_AddressTypes CHECK (AddressType IN (1,2))

)
PRINT 'ClientContact Table Created'

CREATE TABLE AnimalTypeReference
(	AnimalTypeID INT NOT NULL IDENTITY (1,1),
	Species VARCHAR (35) NOT NULL,
	Breed VARCHAR (35) NOT NULL
	CONSTRAINT PK__AnimalTypeReference_AnimalTypeID PRIMARY KEY (AnimalTypeID)
)

PRINT 'AnimalTypeReference Table Created'

CREATE TABLE Patients 
(	PatientID INT NOT NULL IDENTITY (1,1),
	ClientID INT NOT NULL,
	PatName VARCHAR (35) NOT NULL,
	AnimalType INT NOT NULL,
	Color VARCHAR (25),
	Gender VARCHAR (2) NOT NULL,
	BirthYear VARCHAR (4),
	[Weight] DECIMAL (3) NOT NULL,
	Description VARCHAR (1024),
	GeneralNotes VARCHAR (2048) NOT NULL,
	Chipped BIT NOT NULL,
	RabiesVacc DATETIME
	CONSTRAINT PK_Patients_PatientID PRIMARY KEY (PatientID)
	CONSTRAINT FK_Patients_AnimalType FOREIGN KEY (AnimalType) REFERENCES AnimalTypeReference (AnimalTypeID)
)

PRINT 'Patients Table Created'

CREATE TABLE Employees
(	EmployeeID INT NOT NULL IDENTITY (1,1),
	LastName VARCHAR (25) NOT NULL,
	FirstName VARCHAR (25) NOT NULL,
	MiddleName VARCHAR (25) NOT NULL,
	HireDate DATE NOT NULL,
	Title VARCHAR (50) NOT NULL
	CONSTRAINT PK_Employees_EmployeeID PRIMARY KEY (EmployeeID)
)

PRINT 'Employees Table Created'

CREATE TABLE EmployeeContactInfo
(	AddressID INT NOT NULL IDENTITY (1,1),
	EmployeeID INT NOT NULL,
	AddressType INT NOT NULL,
	AddressLine1 VARCHAR (50) NOT NULL,
	AddressLine2 VARCHAR (50) NULL,
	City VARCHAR (35) NOT NULL,
	StateProvince VARCHAR (25) NOT NULL,
	PostalCode VARCHAR (15) NOT NULL,
	Phone VARCHAR (15) NOT NULL,
	AltPhone VARCHAR (15) NULL,
	Email VARCHAR (50) NULL
	
	CONSTRAINT PK_EmployeeContactInfo_AddressID PRIMARY KEY (AddressID)
	CONSTRAINT FK_EmployeeContactInfo_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)

PRINT 'EmployeeContactInfo'

CREATE TABLE Visits
(	VisitID INT NOT NULL IDENTITY (1,1),
	StartTime DATETIME NOT NULL,
	EndTime DATETIME NOT NULL,
	Appointment BIT NOT NULL,
	DiagnosisCode VARCHAR (12) NOT NULL,
	ProcedureCode VARCHAR (12) NOT NULL,
	VisitNotes VARCHAR(2048) NOT NULL,
	PatientID INT NOT NULL,
	EmployeeID INT NOT NULL
	CONSTRAINT PK_Visits_VisitID PRIMARY KEY (VisitID),
	CONSTRAINT FK_Visits_Patients FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
	CONSTRAINT FK_Visits_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
	CONSTRAINT CK_CHECK_EndBeforeStart CHECK (EndTime > StartTime)
)

PRINT 'Visits Table Created'

CREATE TABLE Billing 
(	BillID INT NOT NULL IDENTITY (1,1),
	BillDate DATE NOT NULL, 
	ClientID INT NOT NULL,
	VisitID	 INT NOT NULL,
	Amount DEC NOT NULL
	CONSTRAINT PK_Billing_BillID PRIMARY KEY (BillID)
	CONSTRAINT FK_Billing_Clients FOREIGN KEY (ClientID) REFERENCES Clients(ClientID),
	CONSTRAINT FK_Billing_Visits FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
)

PRINT 'Billing Table Created'

CREATE TABLE Payments
(	PaymentID INT NOT NULL IDENTITY (1,1),
	PaymentDate DATE NOT NULL CHECK (PaymentDate < DATEADD(DAY, 1, GETDATE())),
	BillID INTEGER,
	Notes VARCHAR (2048),
	Amount DEC NOT NULL
	CONSTRAINT PK_Payments_PaymentID PRIMARY KEY (PaymentID),
	CONSTRAINT FK_Payments_Billing FOREIGN KEY (BillID) REFERENCES Billing(BillID)
)

PRINT 'Payment Table Created'
GO


	DENY SELECT ON VeterinaryDB.dbo.ClientContacts TO VetClerk
	DENY SELECT ON VeterinaryDB.dbo.EmployeeContactInfo TO VetClerk
	PRINT 'VET Clerk deneied client contacts and Employee Contact Info' 
GO


INSERT Clients (FirstName, LastName, MiddleName)
VALUES ('Bill', 'Jinkens', 'Johns'), ('Jazmin', 'Fifield', 'Sally'), ('Staci', 'Normavill', 'Clémentine'),
       ('Elnora', 'Dickenson', 'Maïté'), ('Tobey', 'Yallop', 'Zoé')


INSERT ClientContacts (ClientID, AddressType, AddressLine1, AddressLine2, City, StateProvince, 
						PostalCode, Phone, AltPhone, Email)
VALUES (1, 1, '333 Penny Lane', NULL, 'Orlando', 'Florida', '32789', '904-234-6566', NULL, 'cperrigo0@ucoz.com'),
	   (2, 1, '4343 Cross Road', NULL, 'Belleview', 'Florida', '34420', '352-456-76455', NULL, 'pkeaton1@nhs.com'),
       (3, 2, '2827 36th Avenue', NULL, 'Ocala', 'Florida', '34471', '352-111-6543', NULL, 'bdominique2@craigslist.org'),
       (4, 1, '999 Temple Terrace', NULL, 'Tampa', 'Florida', '33617', '813-112-2213', NULL, 'sleil3@mediafire.com'),
       (5, 2, '777 Freedom Drive', NULL, 'Ocala', 'Florida', '34470', '352-5998-3264', NULL, 'akrook4@loc.com')

INSERT AnimalTypeReference (Species, Breed)
VALUES ('Dog', 'Bull Dog'), ('Dog', 'Golden Retriever'), ('Dog', 'Beagle'), 
		('Cat', 'Persian'), ('Cat', 'Siamese'), ('Cat', 'Siberian')

INSERT Patients (ClientID, PatName, AnimalType, Color, Gender, BirthYear, [Weight], 
				[Description], GeneralNotes, Chipped, RabiesVacc)
VALUES  (1, 'Blue Eyes', 1, 'White', 'F', '2009', '72.4', NULL, 'Friendly, playful easy to handel.', 0, '3-10-2014'),
		(2, 'Long-Fellow', 2, 'Golden Yellow', 'M', '2006', '78.7', NULL, 'Independent, headstrong somewhat protective.', 0, '2-28-2012'),
		(3, 'Catcher', 3, 'Brown', 'M', '2003', '68.5', NULL, 'Trustworthy but sometimes stubborn yet fairly easy to treat.', 0, '1-22-2011'),
		(4, 'Comrade', 4, 'White', 'M', '2000', '77.52', NULL, 'Calm and proud, afraid of topical treatments.', 1, '5-13-2013'),
		(5, 'Fluffy', 5, 'Grey', 'F', '2010', '11.5', NULL, 'Peaceful and likes solitude, procastinates when handeling but eventually gives. ', 0, '11-14-2015'),
		(1, 'Mr.Suggles', 6, 'White & Black Spotted', 'M', '2007', '10.5', NULL, 'Seeks attention and willing to coperates with the Vet and the Techs .', 0, '7-6-2013'),
		(2, 'Garfield', 6, 'Orange', 'M', '2004', '12', NULL, 'Unpredictable, prefers to be handled by females.', 1, '11-11-2011')

INSERT Employees (LastName, FirstName, MiddleName, HireDate, Title)
VALUES ('David', 'King', 'Jim', '3-2-2012', 'Veterinarian'),
       ('Angela', 'Clair', 'Walker', '1-11-2012', 'Vetenarian'),
	   ('Sandra', 'Joy', 'Simpson', '5-16-2013', 'Veterinarian Assistant'),
	   ('Gerald', 'Vince', 'Michaels', '5-13-2013', 'Office Manager'),
	   ('Bill', 'Johns', 'Sailor', '4-24-2014', 'Kennel Manager'),
	   ('April', 'Newberry', 'Jones', '2-12-2013', 'Desk Receptionist'),
	   ('John', 'Tanner', 'Smith', '2-9-2015', 'Cusodian')

INSERT EmployeeContactInfo (EmployeeID, AddressType, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, AltPhone, Email)
VALUES (1, 1, '88653 Mesta Parkway', NULL, 'Ocala', 'Florida', '34472', '352-291-9876', NULL, 'david0@netlog.com'),
	   (2, 1, '19301 Airport Ridge Lane', NULL, 'Ocala', 'Florida', '34473', '352-311-7070', NULL, 'angela1@netlog.com'),
       (3, 1, '19 Buhler Park', NULL, 'Belleview', 'Florida', '34432', '352-564-1234', NULL, 'sandra@comcast.net'),
       (4, 1, '9 Briar Crest Plaza', NULL, 'Ocala', 'Florida', '34470', '352-939-7856', NULL, 'gerald@ehow.com'),
       (5, 1, '2252 Gina Park', NULL, 'Ocala', 'Florida', '34474', '352-890-0000', '352-999-8876', 'bill4@tmall.com'),
       (6, 1, '45646 Morrow Lane', 'Apt. 33', 'Dunellon', 'Florida', '34421', '352-234-4321', NULL, 'april5@timesonline.com'),
       (7, 1, '2016 Melody Plaza', 'Apt. 24', 'Alachua',  'Florida', '34475', '352-534-3546', NULL, 'johns6@4shared.com')


INSERT Visits (StartTime, EndTime, Appointment, DiagnosisCode, ProcedureCode, VisitNotes, PatientID, EmployeeID)
VALUES ('04-12-2015 14:30:00.000', '04-12-2015 15:45:00.000', 1, '5633566443', '254R67', 'BLUE EYES, SWALLOWED A DOG TOY AND NEEDED TO HAVE HIS STOMACH PUMPED.', 1, 1), 
	   ('02-28-2015 12:30:00.000', '02-28-2015 13:46:00.000', 1, '7463524367', '85G356', 'Came in with diarrhea and needed to have medicine to help prevent water loss.', 2, 1), 
	   ('08-11-2016 8:30:00.000', '08-11-2016 9:30:00.000', 1, '4356273876', '6Y4326', 'Catcher, had a splinter in his foot and needed to have it removed.', 3, 2),
       ('05-24-2016 14:00:00.000', '05-24-2016 15:30:00.000', 1, '7576453345', '3K9IHT', 'Fluffy needed to get spayed.', 4, 3), 
	   ('09-27-2015 6:16:00.000', '09-27-2015 7:20:00.000', 0, '0982345769', '7UR453', 'Mr. snuggles needed to get neutered.', 5, 3)

INSERT Billing (BillDate, ClientID, VisitID, Amount)
VALUES ('04-12-2015', 1, 1, 300.00), ('02-28-2015', 2, 2, 150.33), 
       ('08-11-2016', 3, 3, 100.00), ('05-24-2016', 4, 4, 100.10), ('09-27-2015', 5, 5, 100.75)


GO

CREATE PROC sp_SpeciesByOwner
(
@species VARCHAR(35)
)

AS
BEGIN
	SELECT		AT.Species [Species], P.PatName [Patient Name], CONCAT (C.FirstName, '', C.LastName) [Full Name], CC.AddressLine1, 
			CC.AddressLine2, CC.City, CC.StateProvince, CC.PostalCode, CC.Phone, CC.AltPhone, CC.Email
	FROM		AnimalTypeReference AT
	INNER JOIN	Patients P
	ON			P.AnimalType = AT.AnimalTypeID
	INNER JOIN	Clients C
	ON			C.ClientID = P.ClientID
	INNER JOIN	ClientContacts CC
	ON			CC.ClientID = C.ClientID
	WHERE		AT.Species = @species

	END

PRINT 'SP_SpeciesByOwner Created'

GO

CREATE PROC sp_SearchByBreed
(
@breed VARCHAR(35)

)
AS
BEGIN
	SELECT		AT.Breed [Species], P.PatName [Patient Name], CONCAT (C.FirstName, '', C.LastName) [Full Name], CC.AddressLine1, 
			CC.AddressLine2, CC.City, CC.StateProvince, CC.PostalCode, CC.Phone, CC.AltPhone, CC.Email
	FROM		AnimalTypeReference AT
	INNER JOIN	Patients P
	ON			P.AnimalType = AT.AnimalTypeID
	INNER JOIN	Clients C
	ON			C.ClientID = P.ClientID
	INNER JOIN	ClientContacts CC
	ON			CC.ClientID = C.ClientID
	WHERE		AT.Breed = @breed

	END


PRINT 'SP_SpeciesByBreed Created'

GO

CREATE PROC sp_BillingInfo
(
@client INT
)
AS
BEGIN
	SELECT B.ClientID,CAST(V.StartTime AS DATE) [Date of Visit], BillDate [Date Billed], B.Amount [Amount Billed], P.Amount [Amount Paid], 
	PaymentDate [Date of Payment] 
	FROM Billing B
	JOIN Payments P
	ON P.BillID = B.BillID
	JOIN Visits V
	ON V.VisitID = B.VisitID
	WHERE @Client = ClientID

END

PRINT 'SP_SpeciesByBreed Created'

GO

GO
CREATE PROC sp_EmployeeMailList

AS
BEGIN
	SELECT CONCAT (E.FirstName, '', E.LastName) [Full Name], AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone
	FROM Employees E
	JOIN EmployeeContactInfo CI
	ON CI.EmployeeID = E.EmployeeID

END

PRINT 'sp_EmployeeMailList'

GO


CREATE PROC sp_CreateClient
(
@FirstName VARCHAR(25),
@MiddleName VARCHAR (25),
@LastName VARCHAR(25),
@AddressType INT,
@AddLine1 VARCHAR(50),
@Address2 VARCHAR (50),
@City VARCHAR(25),
@StateProvince VARCHAR(25),
@ZIPCode VARCHAR(15),
@Phone VARCHAR(15),
@Email VARCHAR (25),
@ClientID INT OUTPUT
)
AS
BEGIN
	INSERT Clients (FirstName, Middlename, LastName)
	VALUES (@FirstName, @MiddleName, @LastName)

	SET @ClientID = (SELECT TOP 1 SCOPE_IDENTITY() FROM Clients)

	INSERT ClientContacts (ClientID, AddressType, AddressLine1, AddressLine2, City, StateProvince, PostalCode, Phone, Email)
	VALUES (@ClientID, @AddressType, @AddLine1, @Address2, @City, @StateProvince, @ZIPCode, @Phone, @Email)

	SELECT @ClientID [New ClientID] FROM Clients

END

--EXEC sp_CreateClient 'Joe', 'J', 'Michales', '2', '3389 Silk Road', NULL, 'Ocala', 'FL', '34471', '797-9874-234', 'tatomr@icloud.com', ''

PRINT 'sp_CreateClient Created'
GO

CREATE PROC sp_CreateEmployee
(
@FirstName VARCHAR(25),
@LastName VARCHAR(25),
@MiddleName VARCHAR(25),
@HireDate DATE,
@JobTitle VARCHAR(50),
@AddressType INT,
@AddLine1 VARCHAR(50),
@City VARCHAR(35),
@StateProvince VARCHAR(25),
@ZIPCode VARCHAR(15),
@Phone VARCHAR(15),
@EmployeeID INT OUTPUT
)
AS
BEGIN
	
	INSERT Employees(FirstName, MiddleName, LastName, HireDate, Title)
	VALUES (@FirstName, @LastName, @MiddleName, @HireDate, @JobTitle)

	SET @EmployeeID = (SELECT TOP 1 SCOPE_IDENTITY() FROM Employees)
	
	INSERT EmployeeContactInfo(EmployeeID, AddressType, AddressLine1, City, StateProvince, PostalCode, Phone)
	VALUES (@EmployeeID, @AddressType, @AddLine1, @City, @StateProvince, @ZIPCode, @Phone)

	SELECT @EmployeeID [New Employee ID]


END
GO

-- EXEC sp_CreateEmployee 'Roderick', 'C', 'Tatom', '2012-7-4', 'IT Tech Support', '1', '610 SE 9TH Ave', 'Ocala', 'FL', '34471', '352-208-5088', ''
 --SELECT * From [dbo].[Employees]

PRINT 'sp_CreateEmployee'

-- Permissions to Vet Clerk & Manager to Access Stored Procedures

USE VeterinaryDB

GRANT EXECUTE ON sp_SpeciesByOwner
	 TO VetClerk
GRANT EXECUTE ON sp_SearchByBreed 
	 TO VetClerk
GRANT EXECUTE ON sp_BillingInfo 
	TO VetClerk
GRANT EXECUTE ON sp_EmployeeMailList 
	TO VetClerk
GRANT EXECUTE ON sp_CreateClient
	TO VetClerk
GRANT EXECUTE ON sp_CreateEmployee
	TO VetClerk

GRANT EXECUTE ON sp_SpeciesByOwner
	 TO VetManager
GRANT EXECUTE ON sp_SearchByBreed 
	 TO VetManager
GRANT EXECUTE ON sp_BillingInfo 
	TO VetManager
GRANT EXECUTE ON sp_EmployeeMailList 
	TO VetManager
GRANT EXECUTE ON sp_CreateClient
	TO VetManager
GRANT EXECUTE ON sp_CreateEmployee
	TO VetManager


PRINT 'Grant Permissions For VetClerk'

GO