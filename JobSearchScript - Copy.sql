USE MASTER
IF (SELECT count(*)
	FROM sys.databases WHERE name = 'JobSearch') >0
BEGIN
	DROP DATABASE JobSearch;
END

CREATE DATABASE JobSearch;
GO

USE JobSearch;  

exec sp_changedbowner 'sa' a

CREATE TABLE Activities
(
ActivityID INT NOT NULL IDENTITY (1,1),
LeadID INT NOT NULL,
ActivityDate date NOT NULL DEFAULT getdate(),
ActivityType CHAR (25) NOT NULL,
ActivityDetails CHAR (255),
Complete BIT NOT NULL DEFAULT (0),
PRIMARY KEY (ActivityID), 
ReferenceLink CHAR (255) NULL, 
ModifiedDate datetime NULL DEFAULT getdate(),
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

CREATE TABLE BusinessTypes
( 
	BusinessType char (255)
	PRIMARY KEY (BusinessType)
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
Agency BIT DEFAULT (0) 
PRIMARY KEY (CompanyID)
);
	PRINT 'Companies Table Added'

	GO
	
CREATE TABLE Contacts
(
	ContactID INT NOT NULL IDENTITY (1,1),
	CompanyID INT NOT NULL,
	CourtesyTitle CHAR (25), 
	ContactFirstName CHAR (50),
	ContactLastName CHAR (50),
	Title CHAR (50),
	Phone CHAR (14),
	Extension CHAR (10), 
	Fax CHAR (14),
	Email CHAR (50),
	Comments CHAR (255),
	Activity BIT, 
	PRIMARY KEY (ContactID),
	CONSTRAINT Ck_CourtesyTitle CHECK (CourtesyTitle IN ('Mr.','Ms.','Miss','Mrs.','Dr.','Rev.'))
);

	PRINT 'Contact Table Added'

CREATE TABLE Leads
(
	LeadID INT NOT NULL IDENTITY (1,1),
	RecordDate	DATE NOT NULL DEFAULT GETDATE(),
	JobTitle CHAR (75) NOT NULL,
	[Description] INT,
	EmploymentType CHAR (25),
	Location CHAR (50),
	Active BIT DEFAULT (-1),
	CompanyID INT,
	AgencyID INT,
	ContactID INT,
	SourceID INT,
	Selected BIT DEFAULT (0),
	PRIMARY KEY (LeadID),
	CONSTRAINT CK_RecordedDate CHECK ([RecordDate] <= GETDATE()),
    CONSTRAINT CK_EmploymentType CHECK (EmploymentType In ('Full-time','Part-time','Contractor', 'Temporary', 'Seasonal', 'Intern', 'Freelance', 'Volunteer'))
);

PRINT 'Leads Table Added'

CREATE TABLE Sources
(
SourceID INT NOT NULL IDENTITY (1,1),
SourceName CHAR (75) NOT NULL, 
SourceType CHAR (35),
[Description] CHAR (255),	
PRIMARY KEY (SourceID),
);

PRINT 'Souces Table Created'


-- INDEXES
    CREATE INDEX idx_activities ON Activities (LeadID, ActivityDate, ActivityType);
	Print 'Index idx_activities created';

	CREATE Index idx_BusinessTypes ON BusinessTypes (BusinessType);
	Print 'Unique index idx_BusinesType created';

	CREATE  Index idx_Companies ON Companies (City,state,zip);
	Print 'Index idx_Companies created';

	CREATE  Index idx_Contacts ON Contacts (CompanyID,ContactLastName,Title);
	Print 'Index idx_Contacts created';

	CREATE  Index idx_Leads ON Leads (RecordDate,EmploymentType,Location,CompanyID,AgencyID,ContactID,SourceID);
	Print 'Index idx_Leads created';

	CREATE  Index idx_Sources ON Sources (SourceName,SourceType);
	Print 'Index idx_Sources created';

	--FOREIGN KEYS ADDED
	
	ALTER TABLE Companies ADD CONSTRAINT BusinessTypes_FK FOREIGN KEY (BusinessType) REFERENCES BusinessTypes (BusinessType); 
	ALTER TABLE Leads ADD CONSTRAINT Companies_FK FOREIGN KEY (CompanyID) REFERENCES Companies (CompanyID); 
	ALTER TABLE Leads ADD CONSTRAINT Contacts_FK FOREIGN KEY (ContactID) REFERENCES Contacts (ContactID);
	ALTER TABLE Leads ADD CONSTRAINT Sources_FK FOREIGN KEY (SourceID) REFERENCES Sources (SourceID);
	ALTER TABLE Activities ADD CONSTRAINT Leads_FK FOREIGN KEY (LeadID) REFERENCES Leads (LeadID);

	USE [JobSearch]




