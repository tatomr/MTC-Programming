CREATE TABLE Clients
(	ClientID INT NOT NULL IDENTITY (1,1),
	Firstname VARCHAR (25) NOT NULL,
	Lastname VARCHAR (25) NOT NULL,
	Middlename VARCHAR (25),
	CreateDate DATE NOT NULL DEFAULT GETDATE(),
	CONSTRAINT PK_Clients_ClinetID PRIMARY KEY (ClientID)
)

CREATE TABLE ClientContacts
(	AddressID INT NOT NULL IDENTITY (1,1),
	ClientID INT NOT NULL,
	AddressType	INT NOT NULL,
	AddressLine1 VARCHAR (50) NOT NULL,
	AddressLine2 VARCHAR (50) NOT NULL,
	City VARCHAR (35) NOT NULL,
	StateProvince VARCHAR (25) NOT NULL,
	PostalCode VARCHAR (15) NOT NULL,
	Phone VARCHAR (15) NOT NULL,
	AltPhone VARCHAR (15) NOT NULL,
	Email VARCHAR (35) NOT NULL
	CONSTRAINT PK_ClientsContacts_AddressID PRIMARY KEY (AddressID)
	CONSTRAINT FK_ClientContacts_Clients FOREIGN KEY (ClientID) REFERENCES Clients (ClientID)
	CONSTRAINT CHK_AddressCheck CHECK (AddressType = 1 OR AddressType = 2)

)

CREATE TABLE AnimalTypeReference
(	AnimalTypeID INT NOT NULL IDENTITY (1,1),
	Species VARCHAR (35) NOT NULL,
	Breed VARCHAR (35) NOT NULL
	CONSTRAINT PK__AnimalTypeReference_AnimalTypeID PRIMARY KEY (AnimalTypeID)
)


CREATE TABLE Patients 
(	PatientID INT NOT NULL IDENTITY (1,1),
	ClientID INT NOT NULL,
	PatName VARCHAR (35) NOT NULL,
	AnimalTypeID INT NOT NULL,
	Color VARCHAR (25),
	Gender VARCHAR (2) NOT NULL,
	BirthYear VARCHAR (4),
	[Weight] DECIMAL (3) NOT NULL,
	Description VARCHAR (1024),
	GeneralNotes VARCHAR (2048) NOT NULL,
	Chipped BIT NOT NULL,
	RabiesVacc DATETIME
	CONSTRAINT PK_Patients_PatientID PRIMARY KEY (PatientID)
	CONSTRAINT FK_Patients_AnimalTypeReference FOREIGN KEY (AnimalTypeID) REFERENCES AnimalTypeReference (AnimalTypeID)
)

CREATE TABLE Employees
(	EmployeeID INT NOT NULL IDENTITY (1,1),
	LastName VARCHAR (25) NOT NULL,
	FirstName VARCHAR (25) NOT NULL,
	MiddleName VARCHAR (25) NOT NULL,
	HireDate DATE NOT NULL,
	Title VARCHAR (50) NOT NULL
	CONSTRAINT PK_Employees_EmployeeID PRIMARY KEY (EmployeeID)
)

CREATE TABLE EmployeeContactInfo
(	AddressID INT NOT NULL IDENTITY (1,1),
	AddressType INT NOT NULL,
	AddressLine1 VARCHAR (50) NOT NULL,
	AddressLine2 VARCHAR (50) NOT NULL,
	City VARCHAR (35) NOT NULL,
	StateProvince VARCHAR (25) NOT NULL,
	PostalCode VARCHAR (15) NOT NULL,
	AltPhone VARCHAR (15) NOT NULL,
	EmployeeID INT NOT NULL
	CONSTRAINT PK_EmployeeContactInfo_AddressID PRIMARY KEY (AddressID)
	CONSTRAINT FK_EmployeeContactInfo_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)

CREATE TABLE Visits
(	VisitID INT NOT NULL IDENTITY (1,1),
	StartTime DATETIME NOT NULL,
	EndTime DATETIME NOT NULL CHECK (EndTime > StartTime),
	Appointment BIT NOT NULL,
	DiagnosisCode VARCHAR (12) NOT NULL,
	ProcedureCode VARCHAR (12) NOT NULL,
	VisitNotes VARCHAR(2048) NOT NULL,
	PatientID INT NOT NULL,
	EmployeeID INT NOT NULL
	CONSTRAINT PK_Visits_VisitID PRIMARY KEY (VisitID)
	CONSTRAINT FK_Visits_Patients FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
	CONSTRAINT FK_Visits_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
)

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

CREATE TABLE Payments
(	PaymentID INT NOT NULL IDENTITY (1,1),
	PaymentDate DATE NOT NULL CHECK (PaymentDate < DATEADD(DAY, 1, GETDATE())),
	BillID INTEGER,
	Notes VARCHAR (2048),
	Amount DEC NOT NULL
	CONSTRAINT PK_Payments_PaymentID PRIMARY KEY (PaymentID),
	CONSTRAINT FK_Payments_Billing FOREIGN KEY (BillID) REFERENCES Billing(BillID)
)

