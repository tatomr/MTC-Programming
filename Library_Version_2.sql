USE MASTER;
if (select count(*) 
    from sys.databases where name = 'Library') > 0
BEGIN
    DROP DATABASE Library;
	ALTER ROLE db_datareader DROP MEMBER [rtatom];
GO
END

CREATE LOGIN rtatom 
WITH PASSWORD = 'ABC123';
GO

CREATE USER rtatom
FOR LOGIN rtatom;
GO

ALTER ROLE db_datareader ADD MEMBER [rtatom];
GO

CREATE DATABASE Library
GO
USE LIBRARY 
CREATE TABLE LIBRARIES 
	(
	LibraryID INT NOT NULL IDENTITY(1,1),
	LibraryName VARCHAR (255) NOT NULL,

	PRIMARY KEY (LibraryID)
	)
GO
CREATE TABLE VENDORS
	(
	VendorID INT NOT NULL IDENTITY(1,1),
	VendorName VARCHAR (255) Null,

	PRIMARY KEY (VendorID)
	)
GO
CREATE TABLE LIBRARY_ASSETS
	(
	AssetID INT NOT NULL IDENTITY(1,1),
	BookTitleID INT  NULL,
	PeriodicalID INT  NULL,
	NewspaperID INT  NULL, 
	VideoID INT  NULL, 
	VendorID INT NULL,

	PRIMARY KEY (AssetID)
	)
GO
CREATE TABLE LOST_ASSETS
	(
	Lost_AssetID INT NOT NULL IDENTITY(1,1),
	AssetID INT NOT NULL,
	LossReason VARCHAR(255) NOT NULL,
	RemovedBy INT NOT NULL,
	DateOfLoss DATE NOT NULL,

	PRIMARY KEY (Lost_AssetID)
	)
GO
CREATE TABLE PERIODICALS
	(
	PeriodicalID INT NOT NULL IDENTITY(1,1),
	PeriodicalName VARCHAR(255),

	PRIMARY KEY (PeriodicalID)
	)
GO
CREATE TABLE MEMBERS
	(
	MemberID INT NOT NULL IDENTITY(1,1),
	AddressID INT NOT NULL,
	First_Name varchar(255) NOT NULL,
	Middle_Name varchar(255) NULL,
	Last_Name varchar(255) NOT NULL,
	Gender varchar(3) NOT NULL,
	CellPhone varchar(15) NULL,
	Email_Address varchar(35) NULL,
	Limit INT NOT NULL,
	JoinedDate DATE NOT NULL,
	DOB DATE NOT NULL,
	CurrentFlag varchar(3) NOT NULL,
	CardNumber INT NOT NULL,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()
	PRIMARY KEY (MemberID),
	)

GO
-- trigger
CREATE trigger [trgMEMBERSCHANGE]
on [MEMBERS]
after insert,update,delete
AS
BEGIN
 UPDATE MEMBERS
 SET ModifiedDate = GETDATE()
 
END


GO
 CREATE TABLE ASSETS_IN_CIRCULATION
	(
	CirculationID int not null identity(1,1),
	MemberID int not null,
	LibraryID int  not null, 
	AssetID int not null,
	CheckOutDate date not null, 
	CheckInDate date null,
	DueDate date not null,
	OverdueDays int null,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()

	PRIMARY KEY (CirculationID),

	CONSTRAINT fk_ASSETS_IN_CIRCULATION_MEMBERS FOREIGN KEY (MEMBERID) REFERENCES MEMBERS(MEMBERID)
	)

GO
/****** Object:  Trigger [dbo].[trgASSETSCHANGE]    Script Date: 11/30/2017 7:51:32 PM ******/

GO

CREATE trigger [trgASSETSCHANGE]
on [ASSETS_IN_CIRCULATION]
after insert,update,delete
AS
BEGIN
 UPDATE ASSETS_IN_CIRCULATION
 SET ModifiedDate = GETDATE()
 
END

GO
 CREATE TABLE BOOK_TITLES 
	(
	BookTitleID INT NOT NULL IDENTITY(1,1),
	ISBN varchar(255) NOT NULL,
	Title varchar(255) NOT NULL,
	AssetID INT NOT NULL,
	Location_ID INT NOT NULL,
	ConditionID INT NOT NULL,
	GenreID INT NOT NULL,
	AuthorID INT NOT NULL,
	CategoryID INT NOT NULL,
	SubTitle varchar(255)  NULL,
	Price MONEY NOT NULL,
	Removed DATE  NULL,
	Recieved DATE NOT NULL,
	Published DATE NOT NULL,
	PublisherID INT NOT NULL,
	Availability INT NOT NULL,

	PRIMARY KEY (BookTitleID)
	)
GO
CREATE TABLE STAFF
	(
	StaffID int NOT NULL identity(1,1),
	AddressID int NOT NULL,
	First_Name varchar(255) NOT NULL,
	Middle_Name varchar(255) NULL,
	Last_Name varchar(255) NOT NULL,
	EmailAddress varchar(255)  NULL,
	JobTitle varchar(255) NOT NULL,
	CurrentFlag INT NOT NULL,
	Pay_rate MONEY NOT NULL,
	Fired_date DATE  NULL,
	Hire_Date DATE NOT NULL,
	Fired_Discription VARCHAR (255) NULL,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()

	PRIMARY KEY (StaffID)
	)
GO

/****** Trigger [dbo].[trgSTAFFCHANGE] ******/

GO
CREATE trigger [trgSTAFFCHANGE]
on STAFF
after insert,update,delete
AS
BEGIN
 UPDATE STAFF
 SET ModifiedDate = GETDATE()
 
END

GO
CREATE TABLE FINES 
	(
	FinesID INT NOT NULL IDENTITY(1,1),
	MemberID INT NOT NULL,
	FineAmt MONEY NOT NULL,
	PaidDate date NULL,
	Paid int NOT NULL,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()

	PRIMARY KEY (FinesID),

	CONSTRAINT fk_FINES_MEMBERS FOREIGN KEY (MemberID) REFERENCES Members(MemberID)
)

GO
/******  Trigger [dbo].[trgFINESCHANGE] ******/

GO
CREATE trigger [trgFINESCHANGE]
on [FINES]
after insert,update,delete
AS
BEGIN
 UPDATE FINES
 SET ModifiedDate = GETDATE()
 
END

GO
CREATE TABLE CONDITION
	(
	ConditionID INT  NOT NULL IDENTITY(1,1),
	ConditionDiscription varchar(255) NOT NULL,

	PRIMARY KEY (ConditionID),
	)
GO
CREATE TABLE LOCATION 
	(
	LocationID INT NOT NULL IDENTITY(1,1),
	ShelfNumber INT  NULL,
	FloorNumber INT  NULL,

	PRIMARY KEY (LocationID)
	)
GO
CREATE TABLE GENRES
 (
	GenreID INT NOT NULL IDENTITY (1,1),
	GenreDiscription varchar(255) NOT NULL,

	PRIMARY KEY (GenreID)
	)
GO
CREATE TABLE CATEGORIES 
	(
	CategoryID INT NOT NULL IDENTITY (1,1),
	CategoryDIscription varchar(255) NOT NULL,

	PRIMARY KEY (CategoryID)
    )
GO
CREATE TABLE ADDRESS
	(
	AddressID INT NOT NULL IDENTITY(1,1),
	Addressline1 varchar(100) NOT NULL,
	Addressline2 varchar(100) NULL,
	City varchar(50) NOT NULL,
	State varchar(50) NOT NULL,
	Postalcode varchar(30) NOT NULL,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()
	PRIMARY KEY (AddressID)
	)
GO
CREATE TABLE PUBLISHERS
	 (
	PublisherID INT NOT NULL IDENTITY(1,1),
	PublishersName varchar(255) NOT NULL,
	AuthorID varchar(255)  NULL,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()
	PRIMARY KEY (PublisherID)
	)
GO
CREATE TABLE AUTHOR
	(
	AuthorID INT NOT NULL IDENTITY(1,1),
	First_Name varchar(255) NOT NULL,
	Middle_Name varchar(255)  NULL,
	Last_Name varchar(255) NOT NULL,
	AddressID int  NULL,
	ModifiedDate datetime NULL DEFAULT GETDATE(),
    ModifiedBy VARCHAR(50) NULL DEFAULT ORIGINAL_LOGIN()

	PRIMARY KEY (AuthorID)
	)
GO
CREATE TABLE NEWSPAPERS
	(
	NewspaperID int NOT NULL IDENTITY(1,1) ,
	NewspaperName varchar(255) NOT NULL,
	PRIMARY KEY (NewspaperID)
	)
GO
CREATE TABLE VIDEOS
	(
	VideoID INT NOT NULL  IDENTITY(1,1),
	VideoTitle varchar(255) NOT NULL,
	PRIMARY KEY (VideoID)
	)

	ALTER TABLE BOOK_TITLES ADD CONSTRAINT Location_fk FOREIGN KEY (Location_ID) REFERENCES LOCATION(LocationID);

	ALTER TABLE BOOK_TITLES ADD CONSTRAINT Condition_fk FOREIGN KEY (ConditionID) REFERENCES CONDITION(ConditionID);

	ALTER TABLE BOOK_TITLES ADD CONSTRAINT Genres_fk FOREIGN KEY (GenreID) REFERENCES GENRES(GenreID);

	ALTER TABLE BOOK_TITLES ADD CONSTRAINT Categories_fk FOREIGN KEY (CategoryID) REFERENCES CATEGORIES(CategoryID);

	ALTER TABLE BOOK_TITLES ADD CONSTRAINT Publishers_fk FOREIGN KEY (PublisherID) REFERENCES PUBLISHERS(PublisherID);


	INSERT INTO VENDORS (VendorName) VALUES ('World Almanac')
	INSERT INTO VENDORS (VendorName) VALUES ('Capstone Press')
	INSERT INTO VENDORS (VendorName) VALUES ('Macmillan/McGraw-Hill')
	INSERT INTO VENDORS (VendorName) VALUES ('Houghton Mifflin Harcourt')
	INSERT INTO VENDORS (VendorName) VALUES ('The Education Place')
	INSERT INTO VENDORS (VendorName) VALUES ('Alexander Street')
	INSERT INTO VENDORS (VendorName) VALUES ('Demco')
	INSERT INTO VENDORS (VendorName) VALUES ('W.T. Cox')
	INSERT INTO VENDORS (VendorName) VALUES ('Barnes and Noble')
	INSERT INTO VENDORS (VendorName) VALUES ('Baker and Taylor')

	INSERT INTO VIDEOS (VideoTitle) VALUES ('Spectre')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Creed')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Ironman')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('13 Hours')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Jack Reacher')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Ben-Hur')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Oceans Twelve')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Timecop')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Caddyshack')
	INSERT INTO VIDEOS (VideoTitle) VALUES ('Fargo')

	INSERT INTO NEWSPAPERS(NewspaperName) VALUES ('The Washington Post')
	INSERT INTO NEWSPAPERS(NewspaperName) VALUES ('The New York Times')
	INSERT INTO NEWSPAPERS(NewspaperName) VALUES ('Tampa Tribune')
	INSERT INTO NEWSPAPERS(NewspaperName) VALUES ('The Wall Street Journal')
	INSERT INTO NEWSPAPERS(NewspaperName) VALUES ('Chicago Tribune')

	INSERT INTO PERIODICALS(PeriodicalName) VALUES ('GQ')
	INSERT INTO PERIODICALS(PeriodicalName) VALUES ('Playboy')
	INSERT INTO PERIODICALS(PeriodicalName) VALUES ('Fourtune')
	INSERT INTO PERIODICALS(PeriodicalName) VALUES ('Golf Digest')
	INSERT INTO PERIODICALS(PeriodicalName) VALUES ('Car and Driver')

	INSERT INTO LIBRARIES(LibraryName) VALUES ('Ammirati Public Library')

	INSERT INTO GENRES(GenreDiscription) VALUES ('ACTION')
	INSERT INTO GENRES(GenreDiscription) VALUES ('ADVENTURE')
	INSERT INTO GENRES(GenreDiscription) VALUES ('COMEDY')
	INSERT INTO GENRES(GenreDiscription) VALUES ('CRIME')
	INSERT INTO GENRES(GenreDiscription) VALUES ('DRAMA')
	INSERT INTO GENRES(GenreDiscription) VALUES ('FANTASY')
	INSERT INTO GENRES(GenreDiscription) VALUES ('HISTORICAL FICTION')
	INSERT INTO GENRES(GenreDiscription) VALUES ('HORROR')
	INSERT INTO GENRES(GenreDiscription) VALUES ('MYSTERY')
	INSERT INTO GENRES(GenreDiscription) VALUES ('ROMANCE')
	INSERT INTO GENRES(GenreDiscription) VALUES ('SAGA')
	INSERT INTO GENRES(GenreDiscription) VALUES ('SCIENCE FICTION')
	INSERT INTO GENRES(GenreDiscription) VALUES ('THRILLER')
	INSERT INTO GENRES(GenreDiscription) VALUES ('WESTERN')
	
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (1,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (2,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (3,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (4,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (5,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (6,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (7,1)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (1,2)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (2,2)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (3,2)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (4,2)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (5,2)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (6,2)
	INSERT INTO LOCATION(ShelfNumber, FloorNumber) VALUES (7,2)
	
	insert into address (addressline1, City, State, Postalcode) values ('97908 Sundown Point', 'Orlando', 'Florida', '32885');
	insert into address (addressline1, City, State, Postalcode) values ('08 Donald Way', 'Jacksonville', 'Florida', '32215');
	insert into address (addressline1, City, State, Postalcode) values ('7706 Michigan Avenue', 'Miami Beach', 'Florida', '33141');
	insert into address (addressline1, City, State, Postalcode) values ('233 Oak Avenue', 'Panama City', 'Florida', '32412');
	insert into address (addressline1, City, State, Postalcode) values ('13 Fordem Park', 'Fort Myers', 'Florida', '33913');
	insert into address (addressline1, City, State, Postalcode) values ('61 Lunder Hill', 'Miami', 'Florida', '33283');
	insert into address (addressline1, City, State, Postalcode) values ('47 Dexter Center', 'Clearwater', 'Florida', '34620');
	insert into address (addressline1, City, State, Postalcode) values ('70458 Montana Terrace', 'Port Saint Lucie', 'Florida', '34985');
	insert into address (addressline1, City, State, Postalcode) values ('60 Debs Circle', 'Hollywood', 'Florida', '33028');
	insert into address (addressline1, City, State, Postalcode) values ('01 Bunting Way', 'Boca Raton', 'Florida', '33432');
	insert into address (addressline1, City, State, Postalcode) values ('1 Red Cloud Trail', 'Pompano Beach', 'Florida', '33069');
	insert into address (addressline1, City, State, Postalcode) values ('199 Nobel Street', 'Jacksonville', 'Florida', '32244');
	insert into address (addressline1, City, State, Postalcode) values ('717 Briar Crest Street', 'West Palm Beach', 'Florida', '33411');
	insert into address (addressline1, City, State, Postalcode) values ('517 Mifflin Center', 'Clearwater', 'Florida', '34615');
	insert into address (addressline1, City, State, Postalcode) values ('89 Pine View Alley', 'Fort Myers', 'Florida', '33994');
	insert into address (addressline1, City, State, Postalcode) values ('4895 Hovde Way', 'Saint Petersburg', 'Florida', '33710');
	insert into address (addressline1, City, State, Postalcode) values ('176 Killdeer Lane', 'Miami', 'Florida', '33129');
	insert into address (addressline1, City, State, Postalcode) values ('67 Hoard Road', 'Kissimmee', 'Florida', '34745');
	insert into address (addressline1, City, State, Postalcode) values ('5983 Messerschmidt Crossing', 'Sarasota', 'Florida', '34276');
	insert into address (addressline1, City, State, Postalcode) values ('56935 North Way', 'Fort Lauderdale', 'Florida', '33355');
	insert into address (addressline1, City, State, Postalcode) values ('6531 Chive Circle', 'Bradenton', 'Florida', '34282');
	insert into address (addressline1, City, State, Postalcode) values ('2 Vernon Lane', 'Orlando', 'Florida', '32891');
	insert into address (addressline1, City, State, Postalcode) values ('0044 Anzinger Park', 'Miami', 'Florida', '33147');
	insert into address (addressline1, City, State, Postalcode) values ('36982 Eliot Plaza', 'Largo', 'Florida', '33777');
	insert into address (addressline1, City, State, Postalcode) values ('8814 Waubesa Circle', 'Pensacola', 'Florida', '32520');
	insert into address (addressline1, City, State, Postalcode) values ('0 Macpherson Junction', 'Bradenton', 'Florida', '34205');
	insert into address (addressline1, City, State, Postalcode) values ('8909 Dakota Circle', 'Orlando', 'Florida', '32830');
	insert into address (addressline1, City, State, Postalcode) values ('00 Spohn Pass', 'Pompano Beach', 'Florida', '33069');
	insert into address (addressline1, City, State, Postalcode) values ('127 Chive Hill', 'Fort Lauderdale', 'Florida', '33330');
	insert into address (addressline1, City, State, Postalcode) values ('55 Homewood Center', 'Tampa', 'Florida', '33647');

	insert into author (First_Name, Middle_Name, Last_Name, AddressID) values ('Lenci', 'Randene', 'Galiford',1);
	insert into author (First_Name, Middle_Name, Last_Name, AddressID) values ('Caril', 'Floria', 'Stonhewer',2);
	insert into author (First_Name, Middle_Name, Last_Name, AddressID) values ('Angil', 'Hart', 'McIlraith',3);
	insert into author (First_Name, Middle_Name, Last_Name, AddressID) values ('Beth', 'Bron', 'Sibbson',4);
	insert into author (First_Name, Middle_Name, Last_Name, AddressID) values ('Lelia', 'Reiko', 'Coppin',5);

	insert into PUBLISHERS (PublishersName, AuthorID) values ('Harper Collins', '1');
	insert into PUBLISHERS (PublishersName, AuthorID) values ('Houghton Mifflin Harcourt', '2');
	insert into PUBLISHERS (PublishersName, AuthorID) values ('Simon & Schuster', '3');
	insert into PUBLISHERS (PublishersName, AuthorID) values ('Perseus', '4');
	insert into PUBLISHERS (PublishersName, AuthorID) values ('Harlequin', '5');
	insert into PUBLISHERS (PublishersName) values ('Reed Elsevier');
	insert into PUBLISHERS (PublishersName) values ('McGraw-Hill Education');
	insert into PUBLISHERS (PublishersName) values ('Cengage');
	insert into PUBLISHERS (PublishersName) values ('Wiley');
	insert into PUBLISHERS (PublishersName) values ('ThomsonReuters');

	insert into CONDITION(ConditionDiscription) values ('NEW');
	insert into CONDITION(ConditionDiscription) values ('FINE');
	insert into CONDITION(ConditionDiscription) values ('VERY GOOD');
	insert into CONDITION(ConditionDiscription) values ('GOOD');
	insert into CONDITION(ConditionDiscription) values ('FAIR');
	insert into CONDITION(ConditionDiscription) values ('POOR');
	insert into CONDITION(ConditionDiscription) values ('REMOVED');

	INSERT INTO CATEGORIES(CategoryDIscription)VALUES('LITERATURE AND FICTION')
	INSERT INTO CATEGORIES(CategoryDIscription)VALUES('MYSTERIES')
	INSERT INTO CATEGORIES(CategoryDIscription)VALUES('SCI-FI AND FANTASY')
	INSERT INTO CATEGORIES(CategoryDIscription)VALUES('ROMANCE')
	INSERT INTO CATEGORIES(CategoryDIscription)VALUES('SCIENCE AND MATH')


	insert into BOOK_TITLES (ISBN, TITLE, ASSETID, LOCATION_ID, CONDITIONID, GENREID, AUTHORID, CATEGORYID, PRICE, RECIEVED, PUBLISHED, PUBLISHERID, AVAILABILITY) values ('513508875-X', 'Savior Without Hate', 1, 1, 1, 1, 5, 1, 5, '10/23/2017', '7/16/2017', 2, 1);
insert into BOOK_TITLES (ISBN, TITLE, ASSETID, LOCATION_ID, CONDITIONID, GENREID, AUTHORID, CATEGORYID, PRICE, RECIEVED, PUBLISHED, PUBLISHERID, AVAILABILITY) values ('330491476-5', 'Foes Without Shame', 2, 1, 1, 6, 4, 5, 5, '5/24/2017', '1/12/2017', 5, 1);
insert into BOOK_TITLES (ISBN, TITLE, ASSETID, LOCATION_ID, CONDITIONID, GENREID, AUTHORID, CATEGORYID, PRICE, RECIEVED, PUBLISHED, PUBLISHERID, AVAILABILITY) values ('901897619-9', 'Pirates Of Water', 3, 1, 1, 7, 3, 2, 5, '1/1/2017', '5/28/2017', 4, 1);
insert into BOOK_TITLES (ISBN, TITLE, ASSETID, LOCATION_ID, CONDITIONID, GENREID, AUTHORID, CATEGORYID, PRICE, RECIEVED, PUBLISHED, PUBLISHERID, AVAILABILITY) values ('265369545-6', 'Descendants And Heroes', 4, 1, 1, 6, 3, 3, 5, '7/12/2017', '11/1/2017', 5, 1);
insert into BOOK_TITLES (ISBN, TITLE, ASSETID, LOCATION_ID, CONDITIONID, GENREID, AUTHORID, CATEGORYID, PRICE, RECIEVED, PUBLISHED, PUBLISHERID, AVAILABILITY) values ('960203331-2', 'Lions And Kings', 5, 1, 1, 1, 1, 1, 5, '1/13/2017', '5/8/2017', 4, 1);

INSERT INTO STAFF (AddressID,[First_Name],[Last_Name],[JobTitle],[CurrentFlag],[Pay_rate],[EmailAddress],[Hire_Date]) VALUES (6,'Lowell','Deerness','Librarian',1,12,'ldeerness2@indiegogo.com', '2017-11-29')
INSERT INTO STAFF (AddressID,[First_Name],[Last_Name],[JobTitle],[CurrentFlag],[Pay_rate],[EmailAddress],[Hire_Date]) VALUES 
(7,'Arley','Boullen','Librarian',1,12,'aboullen5@google.com','2017-11-29')
INSERT INTO STAFF (AddressID,[First_Name],[Last_Name],[JobTitle],[CurrentFlag],[Pay_rate],[EmailAddress],[Hire_Date]) VALUES 
(8,'Ellis','Dandison','Janitor',1,5,'edandison8@google.com','2017-11-29')
INSERT INTO STAFF (AddressID,[First_Name],[Last_Name],[JobTitle],[CurrentFlag],[Pay_rate],[EmailAddress],[Hire_Date]) VALUES 
(9,'Norina','Grimsditch','Volunteer',1,0,'ngrimsditch9@lycos.com','2017-11-29')
INSERT INTO STAFF (AddressID,[First_Name],[Last_Name],[JobTitle],[CurrentFlag],[Pay_rate],[EmailAddress],[Hire_Date]) VALUES 
(10,'Jordon','Perse','Volunteer',1,0,'jperse6@yahoo.com','2017-11-29')