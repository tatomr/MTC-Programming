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
GO
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
GO

PRINT 'Companies Table Added'

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
	Create Trigger TrgActivityModified ON Activities  AFTER INSERT, UPDATE 
	AS
	BEGIN
	UPDATE		a
	SET			a.ModifiedDate = getdate()
	FROM		Activities a
	END
	
	PRINT 'Trigger ActivityModified Created';


	
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

VALUES ('SENIOR DATA BASE ANALYST', 'Database creation, deployment, and configuration, database backup and restore', 'Saint Augustine, Florida', 1, null, 1),
       (' Data Analysis/Database Development', 'Analyze & document business & data requirements', 'Tampa, Florida',1,null,1),
	   (' SQL Developer', 'Collaborating with a team of  Engineers on back-end solutions', 'Boca Raton Florida', 1, null,1),
	   (' Campus Solution Sysmtem Analyst', 'Provide ongoing support and improvement of the university student', 'Daytona Beach Campus',1,null,1)

INSERT INTO Sources (SourceName, SourceType, SourceLink, [Description])

VALUES  ('My Florida','Online','https://jobs.myflorida.com/',null)


INSERT INTO Contacts (CourtesyTitle, ContactFirstName, ContactLastName, Activity)
	   
VALUES   ('Mr', 'Hegg', 'Flss',1),
         ('Ms','Glede', 'Stevena',1),
	     ('Mr', 'Huckster', 'Charlie',1),
		 ('Ms', 'Blyden', 'Clareta',1),
		 ('Ms', 'Ozanne', 'Andreana',1)
	   

--TRIGGER
go
 Create trigger trgRecordUpdate
 ON Leads
 AFTER INSERT 
 AS
 BEGIN
     INSERT INTO LEADS(RecordDate)
	 VALUES (GETDATE ())
 END
 GO
 
 create trigger trgActivityUpdate
on Activities
after update
as
begin
update Activities
set ActivityDate= (getdate())
	end
	go

create trigger trgActivityDateUpdate
 on Activities
 after update
 as 
 begin
 update Activities 
 set ActivityDate = getdate()
 from Activities 
 inner join inserted i
 on i.ActivityID= Activities.ActivityID
 end
 GO




