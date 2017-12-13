USE MASTER
IF (SELECT count(*)
	FROM sys.databases WHERE name = 'JobSearch') >0
BEGIN
	DROP DATABASE JobSearch;
END

CREATE DATABASE JobSearch;
GO

USE JobSearch;  
GO

EXEC sp_changedbowner 'sa'

CREATE TABLE BusinessTypes
( 
	BusinessType CHAR (255) NOT NULL,
	ModifiedDate DATETIME,
	PRIMARY KEY (BusinessType),
	CONSTRAINT  ModifiedDate CHECK (ModifiedDate <=  getdate())
); 

PRINT 'BusinessTypes Table Added'


CREATE TABLE Companies
( 
CompanyID INT NOT NULL IDENTITY (1,1),
CompanyName CHAR (75) NOT NULL,
Address1 CHAR (75),
Address2 CHAR (75), 
City CHAR (50),
[State] CHAR (2),
ZIP CHAR (10), 
Phone CHAR (14),
Fax CHAR (14),
EMail CHAR (50),
Website CHAR (50),
[Description] CHAR (255),
BusinessType CHAR (255) NOT NULL,
Agency BIT DEFAULT (0), 
PRIMARY KEY (CompanyID),
CONSTRAINT  fk_Companies_BusinessTypes FOREIGN KEY (BusinessType) REFERENCES BusinessTypes(BusinessType)
);

PRINT 'Companies Table Added'

-- Trigger Catches New References "Records" To Primary Key 

GO
Create Trigger BusinessTypeCheck
On Companies
After Insert, Update
As
IF EXISTS
(
	SELECT *
	FROM inserted I
	WHERE NOT EXISTS
	(
		SELECT *
		FROM BusinessTypes BT
		WHERE BT.BusinessType = I.BusinessType
	)
)
BEGIN
	RAISERROR ('The Business Type entered does not exist. Please enter a valid Business Type.', 16, 1);
	Rollback Transaction
END;

--Trigger Catches When Primary Key Are Deleted  

GO
CREATE TRIGGER TRG_Business_CompaniesDelete
ON BusinessTypes
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.BusinessType IN (select distinct BusinessType FROM Companies))
    BEGIN
        RAISERROR('Specified BusinessType referenced by Activity records. Record not deleted.',16,1)
        ROLLBACK TRANSACTION 
    END
END

GO
CREATE TRIGGER TRG_Company_ContactsDelete
ON Companies
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
	FROM deleted i 
	WHERE i.CompanyID IN (select distinct CompanyID FROM Contacts ))
	BEGIN
		RAISERROR('Specified CompanyID referenced by Activity records. Record not deleted.',16,1)
		ROLLBACK TRANSACTION 
	END
END

GO

CREATE TRIGGER TRG_Company_LeadsDelete
ON Companies
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.CompanyID IN (select distinct CompanyID FROM Leads))
    BEGIN
        RAISERROR('Specified CompanyID referenced by Activity records. Record not deleted.',16,1)
        ROLLBACK TRANSACTION 
    END
END


GO

CREATE TABLE Sources
(
SourceID INT NOT NULL IDENTITY (1,1),
SourceName CHAR (75) NOT NULL, 
SourceType CHAR (35),
SourceLink CHAR (355) null,
[Description] CHAR (255),	
PRIMARY KEY (SourceID),
);
GO

PRINT 'Souces Table Added'


CREATE TABLE Contacts
(
	ContactID INT NOT NULL IDENTITY (1,1),
	CompanyID INT NOT NULL,
	CourtesyTitle CHAR (25), 
	ContactFirstName CHAR (50),
	ContactLastName CHAR (50),
	Title CHAR (50) DEFAULT NULL,
	Phone CHAR (14) DEFAULT NULL,
	Extension CHAR (10) DEFAULT NULL, 
	Fax CHAR (14) DEFAULT NULL,
	Email CHAR (50) DEFAULT NULL,
	Comments CHAR (255) DEFAULT NULL,
	Activity BIT CONSTRAINT  DF_Active DEFAULT (1), 
	PRIMARY KEY (ContactID),
	CONSTRAINT  fk_Contacts_Companies FOREIGN KEY (CompanyID) REFERENCES Companies (CompanyID)
);
GO
	PRINT 'Contact Table Added'



--Trigger Catches When Primary Key Are Deleted  

GO
	CREATE TRIGGER TRG_Contacts_LeadsDelete
ON Contacts
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
	FROM deleted i 
	WHERE i.ContactID IN (select distinct ContactID FROM Leads))
	BEGIN
		RAISERROR('Specified ContactID referenced by Activity records. Record not deleted.',16,1)
		ROLLBACK TRANSACTION 
	END
END
GO

GO
	CREATE TABLE Leads
(
	LeadID INT NOT NULL IDENTITY (1,1),
	RecordDate	DATETIME NOT NULL DEFAULT (GETDATE()),
	JobTitle CHAR (75) NOT NULL,
	[Description] INT,
	EmploymentType CHAR (25), CONSTRAINT  EmploymentType CHECK (EmploymentType IN ('Full time', 'Part time', 'Seasonal')),
	Location CHAR (50),
	Active BIT DEFAULT (-1),
	CompanyID INT,
	AgencyID INT,
	ContactID INT,
	SourceID INT,
	Selected BIT DEFAULT (0),
	PRIMARY KEY (LeadID),
	
	CONSTRAINT  fk_Lead_Contacts FOREIGN KEY (ContactID) REFERENCES Contacts(ContactID),
	CONSTRAINT  fk_Lead_Companies FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID),
	CONSTRAINT  fk_Lead_Sources FOREIGN KEY (SourceID) REFERENCES Sources(SourceID),
	CONSTRAINT  Selected CHECK (Selected IN ('1','0')),
);


--Trigger Catches When Primary Key Are Deleted  
GO
CREATE TRIGGER TRG_Leads_ActivityDelete
ON Leads
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.LeadID IN (select distinct LeadID FROM Activities))
    BEGIN
        RAISERROR('Specified LeadID referenced by Activity records. Record not deleted.',16,1)
        ROLLBACK TRANSACTION 
    END
END

GO

CREATE TRIGGER TRG_Leads_SourcesDelete
ON Leads
AFTER DELETE
AS
BEGIN

IF EXISTS(SELECT * 
    FROM deleted i 
    WHERE i.SourceID IN (select distinct SourceID FROM Sources))
    BEGIN
        RAISERROR('Specified LeadID referenced by Activity records. Record not deleted.',16,1)
        ROLLBACK TRANSACTION 
    END
END
GO

PRINT 'Leads Table Added'

CREATE TABLE Activities
(
ActivityID INT NOT NULL IDENTITY (1,1),
LeadID INT NOT NULL,
ActivityDate DATETIME NOT NULL DEFAULT getdate(),
ActivityType CHAR (25) NOT NULL,
ActivityDetails CHAR (255),
Complete BIT NOT NULL DEFAULT (0), CONSTRAINT  Complete CHECK (Complete IN ('Yes','No')),
ReferenceLink CHAR (255), 
ModifiedBY CHAR (75) NOT NULL CONSTRAINT  DF_ModifiedBY DEFAULT (original_login()),
ModifiedDate DATETIME NOT NULL CONSTRAINT  DF_ModifiedDate DEFAULT (getdate ()),
PRIMARY KEY (ActivityID), 
CONSTRAINT  fk_Activities_Leads FOREIGN KEY (LeadID) REFERENCES Leads (LeadID)
);

PRINT 'Activites Table Added'

	GO
	CREATE TRIGGER TrgActivityModified ON Activities  AFTER INSERT, UPDATE 
	AS
	BEGIN
	UPDATE		a
	SET			a.ModifiedDate = getdate()
	FROM		Activities a
	END
	
	PRINT 'Trigger ActivityModified CREATEd';


	
--INDEX

CREATE INDEX Companies_CompanyName_BusinessType
ON Companies (CompanyName ASC, BusinessType ASC)


CREATE INDEX Activities_ActivityType
ON Activities (ActivityType ASC)

CREATE INDEX Contacts_ContactFirstName_ContactLastName
ON Contacts (ContactFirstName ASC, ContactLastName ASC)

CREATE INDEX Sources_SourceName
ON Sources (SourceName ASC)


--INSERTS

INSERT INTO BusinessTypes (BusinessType)
VALUES 

('Accounting'),
('Advertising/Marketing'),
('Agriculture'),
('Architecture'),
('Arts/Entertainment'),
('Aviation'),
('Beauty/Fitness'),
('Business Services'),
('Communications'),
('Computer/Hardware'),
('Computer/Services'),
('Computer/Software'),
('Computer/Training'),
('Construction'),
('Consulting'),
('Crafts/Hobbies'),
('Education'),
('Electrical'),
('Electronics'),
('Employment'),
('Engineering'),
('Environmental'),
('Fashion'),
('Financial'),
('Food/Beverage'),
('Government'),
('Health/Medicine'),
('Home & Garden'),
('Immigration'),
('Import/Export'),
('Industrial'),
('Industrial Medicine'),
('Information Services'),
('Insurance'),
('Internet'),
('Legal & Law'),
('Logistics'),
('Manufacturing'),
('Mapping/Surveying'),
('Marine/Maritime'),
('Motor Vehicle'),
('Multimedia'),
('Network Marketing'),
('News & Weather'),
('Non-Profit'),
('Petrochemical'),
('Pharmaceutical'),
('Printing/Publishing'),
('Real Estate'),
('Restaurants'),
('Restaurants Services'),
('Service Clubs'),
('Service Industry'),
('Shopping/Retail'),
('Spiritual/Religious'),
('Sports/Recreation'),
('Storage/Warehousing'),
('Technologies'),
('Transportation'),
('Travel'),
('Utilities'),
('Venture Capital'),
('Wholesale')


INSERT INTO Companies (CompanyName, Address1, Address2, City, [State], Zip, Phone, Fax, Email, Website)
VALUES ('University of Florida', null, null,'Univeristy Ave','Fl', 32601, null, null, null, null)


INSERT INTO Lead (JobTitle, [Description], Location, Active, DocAttatchments, Selected)

VALUES ('Jr. DATA BASE ANALYST', 'Database creation, deployment, and configuration, database backup and restore', 'Saint Augustine, Florida', 1, null, 1),
       ('SENIOR DATA BASE ANALYST', 'Senior Data Base Analyst (SQL) will be responsible for the design, implementation and ongoing maintenance of all database ', 'Tallahasse, Florida',1,null,1),
	   (' SYSTEMS ANALYST I', 'Analysis, design, development, and implementation of business solutions', 1, null,1),
	   (' APPLICATION SYSTEMS PROGRAMMER II', 'Performing new development and maintaining our current systems', 'Tallahassee',1,null,1)

INSERT INTO Sources (SourceName, SourceType, SourceLink, [Description])

VALUES  ('My Florida','Online','https://jobs.myflorida.com/',null)


INSERT INTO Contacts (CourtesyTitle, ContactFirstName, ContactLastName, Activity)
	   
VALUES   ('Mr', 'Bill', 'Ginger',1),
         ('Ms','Hope', 'Faith',1),
	     ('Mr', 'Charles', 'Limberg',1),
		 ('Ms', 'Betty', 'Davis',1),
		 ('Ms', 'Kim', 'Flower',1)
	   

--TRIGGER
go
 CREATE TRIGGER trgRecordUpdate
 ON Leads
 AFTER INSERT 
 AS
 BEGIN
     INSERT INTO LEADS(RecordDate)
	 VALUES (GETDATE ())
 END
 GO
 
 CREATE TRIGGER trgActivityUpdate
ON Activities
after update
as
begin
update Activities
set ActivityDate= (getdate())
	end
	go

CREATE TRIGGER trgActivityDateUpdate
 ON Activities
 after update
 as 
 begin
 update Activities 
 set ActivityDate = getdate()
 from Activities 
 inner join inserted i
 ON i.ActivityID= Activities.ActivityID
 end
 GO




