--Roderick's Script for Library Database

USE MASTER
if (select count(*)
	FROM sys.databases WHERE name = 'Library') >0
BEGIN
	DROP DATABASE Library;
END

CREATE DATABASE Library;
GO

CREATE LOGIN rtatom WITH PASSWORD = '&123'
GO
CREATE USER rtatom FOR LOGIN rtatom
GO
ALTER ROLE db_datareader ADD MEMBER rtatom
GO
ALTER ROLE db_datawriter ADD MEMBER rtatom
GO


USE Library;  
		
CREATE TABLE Customers
(
	
	Membership_ID INT NOT NULL IDENTITY(1,1),
	First_Name varchar (35) NOT NULL,
	Last_Name varchar (35) NOT NULL, 
	Gender varchar(15) NOT NULL,
	address_1 varchar (60) NOT NULL,
	address_2 varchar (60) NULL,
	City varchar (60) NOT NULL,
	[State] varchar (60) NOT NULL,
	Zip varchar (15) NOT NULL, 
	Phone varchar(15) NOT NULL,
	Email varchar (35) NOT NULL,
	PRIMARY KEY (Membership_ID)

);

CREATE TABLE Employees
(
	Employee_ID INT NOT NULL IDENTITY (1,1),
	JobTitle varchar (35) NOT NULL,
	Salary money NOT NULL,
	First_Name varchar (35) NOT NULL, 
	Last_Name varchar (35) NOT NULL,
	Gender varchar (15) NOT NULL,
	DOB date NOT NULL, 
	address_1 varchar (60) NOT NULL,
	address_2 varchar (60) NULL,
	City varchar (60) NOT NULL,
	[State] varchar (60) NOT NULL,
	Zip varchar (15) NOT NULL, 
	Primary_Phone varchar(15) NOT NULL,
	Secondary_Phone varchar (15) NULL,
	Email varchar (35) NOT NULL,
	Hire_Date date NOT NULL,
	End_Date date NULL, 
	PRIMARY KEY (Employee_ID)
); 

CREATE TABLE Vendors
(
	Vendor_ID INT NOT NULL IDENTITY (1,1),
	Vendor_Name varchar (35) NOT NULL,
	Phone varchar (35) NOT NULL,
	Contact_Person varchar (35) NOT NULL,
	address_1 varchar (60) NOT NULL,
	address_2 varchar (60) NULL,
	City varchar (60) NOT NULL,
	[State] varchar (60) NOT NULL,
	Zip varchar (15) NOT NULL, 
	Vendor_Phone varchar(15) NOT NULL,
	Email varchar (35) NOT NULL,
	PRIMARY KEY (Vendor_ID)
);  

CREATE TABLE Product 
(
	Product_ID INT NOT NULL IDENTITY (1, 1),
	Topic_ID INT NOT NULL,
	Asset_Name varchar (250)NOT NULL,
	Genera varchar (30) NOT NULL,
	Author_ID int NOT NULL,
	ISBN varchar (35),
	Asset_Cost money NOT NULL,
	Vendor_ID int  NULL,
	PRIMARY KEY (Product_ID) 
);

CREATE TABLE Product_Topics
(
	Topic_ID INT NOT NULL IDENTITY (1, 1),
	Product_Description varchar (35) NOT NULL,	
	PRIMARY KEY (Topic_ID) 
);


CREATE TABLE Library_Inventory
	(   
	Inventory_ID int NOT NULL IDENTITY (1,1),
	Product_ID int NOT NULL, 
	CardNumber_ID int NOT NULL,
	Item_Availablity varchar (15) NOT NULL, 
	Checked_In date NOT NULL,
	Checked_Out date NOT NULL,
	location varchar(15) NOT NULL,
	Processed_ByEmployee varchar (15) NOT NULL,
	Processed_Date date NOT NULL,
	Condition varchar (15) NOT NULL,
	Notes varchar (255) NULL, 
	PRIMARY KEY (Inventory_ID)
	);

	CREATE TABLE ID_Cards
(
	CardNumber_ID int NOT NULL IDENTITY (0001,1),
	Membership_ID int NOT NULL,
	Joined_Date date NOT NULL,
	Retired_Date date NULL,
	PRIMARY KEY (CardNumber_ID)
);

CREATE TABLE Fees
(
	CardNumber_ID int NOT NULL,
	Items_CheckOut smallint NULL,
	Items_Overdue smallint NULL,
	Duedate date NOT NULL,
	Dues money NULL,
);

CREATE TABLE Authors 

(
Author_ID INT NOT NULL IDENTITY (1,1),
First_Name varchar (35) NOT NULL,
Middle_Initial varchar (35),
Last_Name varchar (35) NOT NULL,
PRIMARY KEY (Author_ID)
); 

-- FOREIGN KEYS 

ALTER TABLE Library_Inventory ADD CONSTRAINT Product_FK FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID); 

ALTER TABLE Library_Inventory ADD CONSTRAINT ID_Cards_FK FOREIGN KEY (CardNumber_ID) REFERENCES ID_Cards(CardNumber_ID); 

ALTER TABLE ID_Cards ADD CONSTRAINT Customers_FK FOREIGN KEY (Membership_ID) REFERENCES Customers(Membership_ID);

ALTER TABLE Product ADD CONSTRAINT Product_Topics_FK FOREIGN KEY (Topic_ID) REFERENCES Product_Topics(Topic_ID);

ALTER TABLE Product ADD CONSTRAINT Authors_Topics_FK FOREIGN KEY (Author_ID) REFERENCES Authors(Author_ID);

ALTER TABLE Product ADD CONSTRAINT Vendors_Topics_FK FOREIGN KEY (Vendor_ID) REFERENCES Vendors(Vendor_ID);

--INDEXES

CREATE INDEX idx_Product_ID ON Product (Product_ID);

CREATE INDEX idx_author_ID ON authors (author_ID);

CREATE INDEX idx_membership_ID ON Customers (membership_ID);

CREATE INDEX idx_employee_ID ON Employees (employee_ID);

CREATE INDEX idx_inventory_ID ON Library_Inventory (inventory_ID);

--Trigger

ALTER TABLE Authors
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyAuthors
ON Authors 
AFTER UPDATE
AS
BEGIN

	UPDATE		a
	SET			a.ModifiedDate = GETDATE(), 
				a.ModifiedBy = ORIGINAL_LOGIN()
	FROM		authors a


END
GO
ALTER TABLE Customers
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyCustomers
ON Customers 
AFTER UPDATE
AS
BEGIN

	UPDATE		c
	SET			c.ModifiedDate = GETDATE(), 
				c.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Customers c


END
GO
ALTER TABLE Employees
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyEmployees
ON Employees 
AFTER UPDATE
AS
BEGIN

	UPDATE		e
	SET			e.ModifiedDate = GETDATE(), 
				e.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Employees e


END
GO
ALTER TABLE Fees
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyFees
ON Fees 
AFTER UPDATE
AS
BEGIN

	UPDATE		f
	SET			f.ModifiedDate = GETDATE(), 
				f.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Fees f


END
GO
ALTER TABLE ID_Cards
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyID_Cards
ON ID_Cards 
AFTER UPDATE
AS
BEGIN

	UPDATE		id
	SET			id.ModifiedDate = GETDATE(), 
				id.ModifiedBy = ORIGINAL_LOGIN()
	FROM		ID_Cards id


END
GO
ALTER TABLE Library_Inventory
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyLibrary_Inventory
ON Library_Inventory 
AFTER UPDATE
AS
BEGIN

	UPDATE		inv
	SET			inv.ModifiedDate = GETDATE(), 
				inv.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Library_Inventory inv


END
GO

ALTER TABLE Product
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyProducts
ON Product
AFTER UPDATE
AS
BEGIN

	UPDATE		p
	SET			p.ModifiedDate = GETDATE(), 
				p.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Product p


END
GO
ALTER TABLE Product_Topics
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyProducts_Topics
ON Product_Topics
AFTER UPDATE
AS
BEGIN

	UPDATE		ptop
	SET			ptop.ModifiedDate = GETDATE(), 
				ptop.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Product_Topics ptop


END
GO
ALTER TABLE Vendors
ADD ModifiedDate datetime DEFAULT GETDATE(), 
ModifiedBy VARCHAR(50) DEFAULT ORIGINAL_LOGIN()

GO

CREATE TRIGGER trgRecordModifyVendors
ON Vendors
AFTER UPDATE
AS
BEGIN

	UPDATE		v
	SET			v.ModifiedDate = GETDATE(), 
				v.ModifiedBy = ORIGINAL_LOGIN()
	FROM		Vendors v


END

GO



--Insert Statements

--Authors Table

INSERT INTO dbo.Authors ([First_Name],[Middle_Initial] ,[Last_Name]) VALUES ('Mary','Baker','Eddy');
INSERT INTO dbo.Authors ([First_Name],[Last_Name]) VALUES ('Paramahansa', 'Yogananda');
INSERT INTO dbo.Authors ([First_Name],[Middle_Initial] ,[Last_Name]) VALUES ('GodFre','Ray','King');
INSERT INTO dbo.Authors ([First_Name],[Middle_Initial] ,[Last_Name]) VALUES ('Mark','L','Prophet');
INSERT INTO dbo.Authors ([First_Name],[Middle_Initial] ,[Last_Name]) VALUES ('Elizabeth','Clair','Prophet');
INSERT INTO dbo.Authors ([First_Name],[Last_Name]) VALUES ('Kim', 'Michaels');
INSERT INTO dbo.Authors ([First_Name],[Last_Name]) VALUES ('Saint', 'Germain');

-- Customers Table

INSERT INTO Customers (first_name, last_name, gender, address_1, address_2,  city, State, Zip, Phone, email) VALUES ('Georgianna', 'Tonsley', 'Female', '5346 Hanson Pass', null, 'Ocala', 'FL', '0268-6735', '512-751-0362', 'gtonsley0@omniture.com');
INSERT INTO Customers (first_name, last_name, gender, address_1, address_2, city, State, Zip, Phone, email) VALUES ('Rockie', 'Beer', 'Male', '0179 Lunder Alley', null, 'Ocala', 'FL', '68016-216', '501-282-0877', 'rbeer1@ihg.com');
INSERT INTO Customers (first_name, last_name, gender, address_1, address_2, city, State, Zip, Phone, email) VALUES ('Nikolia', 'Flipsen', 'Female', '5 Holy Cross Place', null, 'Ocala', 'FL', '55154-5821', '202-606-8466', 'nflipsen2@amazon.co.uk');
INSERT INTO Customers (first_name, last_name, gender, address_1, address_2, city, State, Zip, Phone, email) VALUES ('Loella', 'Chaplin', 'Female', '5 Commercial Park', null, 'Ocala', 'FL', '68084-244', '775-389-2583', 'lchaplin3@stanford.edu');
INSERT INTO Customers (first_name, last_name, gender, address_1, address_2, city, State, Zip, Phone, email) VALUES ('Willard', 'Cureton', 'Male', '0240 Truax Avenue', null, 'Ocala', 'FL', '11822-0350', '480-294-6876', 'wcureton4@intel.com');
INSERT INTO Customers (first_name, last_name, gender, address_1, address_2, city, State, Zip, Phone, email) VALUES ('Baily', 'Fronks', 'Male', '8109 Superior Trail', null, 'Ocala', 'FL', '63736-023', '360-106-0435', 'bfronks5@chicagotribune.com');
INSERT INTO Customers (first_name, last_name, gender, address_1, address_2, city, State, Zip, Phone, email) VALUES ('Faydra', 'Pierpoint', 'Female', '96 Kropf Junction', null, 'Ocala', 'FL', '0078-0518', '816-103-6340', 'fpierpoint6@i2i.jp');

-- Employee Table

INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Media Assistant', '$25,000', 'Shawn', 'Barkess', 'Female', '12/5/1955', '1 Hazelcrest Parkway', null, 'Ocala', 'FL', '11822-9020', '302-739-1862', null, 'sbarkess0@devhub.com', '10/7/2011', '1/18/2014');
INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Media Specialist', '$50,000', 'Peyter', 'Guillotin', 'Male', '3/16/1987', '86 Lunder Center', null, 'Ocala', 'FL', '42427-002', '202-568-8299', null, 'pguillotin1@indiatimes.com', '10/25/2012', '5/25/2016');
INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Director of Library', '$70,000', 'Roderick', 'Tatom', 'Male', '5/20/1989', '79439 Holy Cross Park', null, 'Ocala', 'FL', '41520-809', '775-261-9889', null, 'bharrema2@msn.com', '8/14/2016', '10/2/2014');
INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Media Assistant', '$25,000', 'Rubin', 'Bluschke', 'Male', '9/27/1961', '04205 Division Junction', null, 'Ocala', 'FL', '76485-1021', '806-242-8416', null,'rbluschke3@pinterest.com', '4/20/2014', null);
INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Computer Technician', '$36,000', 'Carlo', 'Sach', 'Male', '4/6/1983', '5 Fulton Plaza', null, 'Ocala', 'FL', '11994-121', '336-669-2564', null, 'csach4@squidoo.com', '6/28/2009', '5/19/2013');
INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Book Keeper', '$50,000', 'Raphaela', 'Brugemann', 'Female', '12/16/1976', '396 Springview Terrace', null, 'Ocala', 'FL', '0998-0315', '646-503-5998', null, 'rbrugemann5@answers.com', '2/8/2014', null);
INSERT INTO Employees (JobTitle, Salary, first_name, last_name, gender, DOB, address_1, address_2, city, State, Zip, Primary_Phone, Secondary_Phone, email, Hire_Date, End_Date) VALUES ('Teacher', '$36,000', 'Manny', 'Paydon', 'Male', '7/2/1980', '108 Aberg Terrace', null, 'Ocala', 'FL', '36987-1371', '732-967-0541', null, 'mpaydon6@newyorker.com', '6/29/2016', '10/23/2010');

-- Fees Table

INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (1, 4, 0, '5/29/2017', null);
INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (2, 6, 1, '11/23/2017', '3.55');
INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (3, 2, 1, '10/26/2017', '$2.96');
INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (4, 2, 0, '5/13/2017', null);
INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (5, 0, 0, '1/10/2017', null);
INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (6, 2, 0, '1/10/2017', null);
INSERT INTO Fees (CardNumber_ID, Items_CheckOut, Items_Overdue, Duedate, Dues) VALUES (7, 2, 1, '9/21/2017', '$4.87');

--ID_Cards

INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 1, '2/5/2016', null);
INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 2, '6/23/2015', null);
INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 3, '12/14/2014', null);
INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 4, '1/30/2017', null);
INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 5, '3/31/2015', null);
INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 6, '7/24/2014', null);
INSERT INTO ID_Cards ( Membership_ID, Joined_Date, Retired_Date) VALUES ( 7, '10/23/2017', null);

--Vendor 

INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Cartwright and Sons', '860-568-3274', 'Rustie Langer', '483 Anniversary Street', null, 'Hartford', 'CT', '06140', '615-777-3296', 'rlanger0@stanford.edu');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('VonRueden, Mayert and Treutel', '215-780-2369', 'Bessy Dungate', '552 Sunbrook Pass', null, 'Philadelphia', 'PA', '19141', '719-109-5366', 'bdungate1@dot.gov');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Gerlach Inc', '754-884-7031', 'Candace Purkiss', '77018 David Court', null, 'Fort Lauderdale', 'FL', '33336', '561-768-1124', 'cpurkiss2@sciencedaily.com');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Ryan, Halvorson and Funk', '952-491-6023', 'Averill Chiles', '01179 Carey Lane', null, 'Young America', 'MN', '55551', '213-928-6139', 'achiles3@illinois.edu');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Leffler-Franecki', '407-148-7882', 'Emmaline Pesek', '5472 Gale Crossing', null, 'Orlando', 'FL', '32868', '570-882-4415', 'epesek4@rediff.com');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Raynor Group', '815-661-6765', 'Shalne Hidderley', '796 Pawling Junction', null, 'Joliet', 'IL', '60435', '303-141-6461', 'shidderley5@bigcartel.com');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Bergstrom, Kunze and Rath', '650-132-5233', 'Dallis Taunton.', '2016 Sunfield Junction', null, 'San Jose', 'CA', '95113', '217-797-7685', 'dtaunton6@jugem.jp');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Hagenes-Hermiston', '619-233-9362', 'Raf Glowacha', '33875 Evergreen Point', null, 'San Diego', 'CA', '92186', '832-764-3161', 'rglowacha7@go.com');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Hagenes Group', '508-456-9850', 'Raquel Lewknor', '7552 Artisan Crossing', null, 'Boston', 'MA', '02114', '952-565-7865', 'rlewknor8@lulu.com');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Leuschke, Corwin and Dickens', '858-303-9032', 'Ferris Piser', '7 Kensington Point', null, 'Oceanside', 'CA', '92056', '504-270-9973', 'fpiser9@histats.com');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Toy LLC', '317-381-2116', 'Gifford McCooke', '996 Farmco Crossing', null, 'Indianapolis', 'IN', '46239', '202-349-7732', 'gmccookea@goo.gl');
INSERT INTO Vendors (Vendor_Name, Phone, Contact_Person, address_1, address_2, City, State, Zip, Vendor_Phone, Email) values ('Denesik LLC', '202-962-6776', 'Kendricks Huller', '333 Mariners Cove Pass', null, 'Washington', 'DC', '20260', '423-775-9089', 'khullerb@nytimes.com');

--Product

INSERT INTO Product ([Topic_ID], Asset_Name, [Genera],[Author_ID],[ISBN],[Asset_Cost]) VALUES ( 3, 'yes', 'Comedy', 1, 2111846805, 70)

--Library_Inventory

INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 1, 3, 'false', '8/3/2016', '6/25/2017', 'Shelf','Bluschke', '6/28/2017', 'Good','GREAT BOOK');
INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 2, 2, 'true', '1/29/2015', '8/9/2015', 'Shelf', 'Bluschke', '8/12/2015', 'Bad', 'Deep philosohical boook');
INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 3, 3, 'true', '4/30/2015', '8/30/2017', 'Out', 'Bluschke', '9/02/2017', 'Replace', 'Amazing sql book');
INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 4, 4, 'true', '10/16/2016', '12/4/2014', 'Self','Burkess', '12/7/2014', 'Good', 'Five Stars' );
INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 5, 5, 'true', '1/10/2016', '2/1/2016', 'Processing','Burkess', '2/4/2016', 'Bad', 'Order extra copies');
INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 6, 6, 'true', '5/22/2016', '1/3/2017', 'Processing', 'Burkess', '1/6/2017', 'Replace', 'Best Seller');
INSERT INTO Library_Inventory ( Product_ID, [CardNumber_ID], [Item_Availablity], [Checked_In], [Checked_Out], [location], [Processed_ByEmployee], [Processed_Date], [Condition], notes) values ( 7, 7, 'false', '5/4/2015', '10/15/2016', 'Out', 'Bluschke', '10/18/2016', 'Good', 'Next generation of future reading');


-- Product_Topics Table

INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('Books');
INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('e-books');
INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('AudioBooks');
INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('Magazines');
INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('Movies');
INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('Documentaries');
INSERT INTO dbo.Product_Topics (Product_Description) VALUES ('Recorded Lectures');








select * from Product_Topics








