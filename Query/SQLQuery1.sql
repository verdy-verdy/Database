CREATE DATABASE RALaundry

USE RALaundry

CREATE TABLE RaStaff(
	StaffId CHAR (5) PRIMARY KEY NOT NULL,
	StaffName VARCHAR (50) NOT NULL,
	StaffGender VARCHAR (6) NOT NULL CHECK (StaffGender IN ('Male', 'Female')),
	StaffSalary INT NOT NULL CHECK (StaffSalary BETWEEN 150000 and 3000000),
	StaffAddress VARCHAR (100),
	CONSTRAINT ST_ID CHECK (StaffId LIKE 'ST[0-9][0-9][0-9]')
)

CREATE TABLE RaCustomer(
	CustomerId CHAR (5) PRIMARY KEY NOT NULL,
	CustomerName VARCHAR (50) NOT NULL,
	CustomerDOB DATE,
	CustomerPhone VARCHAR(20) NOT NULL,
	CustomerAddress VARCHAR(100)NOT NULL,
	CustomerGender VARCHAR (6) CHECK (CustomerGender IN ('Male', 'Female')),
	CONSTRAINT CS_ID CHECK (CustomerId LIKE 'CU[0-9][0-9][0-9]')
)

CREATE TABLE RaVendor(
	VendorId CHAR (5) PRIMARY KEY NOT NULL,
	VendorName VARCHAR (100) NOT NULL,
	VendorAddress VARCHAR(100) NOT NULL CHECK (len(VendorAddress)>10),
	VendorPhone VARCHAR(20) NOT NULL,
	CONSTRAINT VR_ID CHECK (VendorId LIKE 'VE[0-9][0-9][0-9]')
)


CREATE TABLE RaClothes(
	ClothesId CHAR (5) PRIMARY KEY NOT NULL,
	ClothesName VARCHAR (100) NOT NULL,
	ClothesType VARCHAR (15) NOT NULL CHECK (ClothesType IN ('Cotton', 'Viscose', 'Polyester', 'Linen', 'Wool')),
	CONSTRAINT CL_ID CHECK (ClothesId LIKE 'CL[0-9][0-9][0-9]')
)

CREATE TABLE RaMaterial(
	MaterialId CHAR (5) PRIMARY KEY NOT NULL,
	MaterialName VARCHAR (100) NOT NULL,
	MaterialType VARCHAR (10) NOT NULL CHECK (MaterialType IN ('Equipment', 'Supplies')),
	MaterialPrice INT,
	CONSTRAINT MA_ID CHECK (MaterialId LIKE 'MA[0-9][0-9][0-9]')
)

CREATE TABLE RaServiceTransactionDetail(
	STransactionId CHAR (5) PRIMARY KEY NOT NULL,
	ServiceDate DATE,
	ServicePrice INT,
	ServiceType VARCHAR (30) NOT NULL CHECK (ServiceType IN ('Laundry service', 'Dry Cleaning Service', 'Ironing Service'))
)

CREATE TABLE RaServiceTransaction(
	STransactionId CHAR(5) FOREIGN KEY REFERENCES RaServiceTransactionDetail(STransactionId) ON DELETE CASCADE ON UPDATE CASCADE,
	StaffId CHAR(5) FOREIGN KEY REFERENCES RaStaff(StaffId) ON DELETE CASCADE ON UPDATE CASCADE,
	CustomerId CHAR(5) FOREIGN KEY REFERENCES RaCustomer(CustomerId) ON DELETE CASCADE ON UPDATE CASCADE,
	ClothesId CHAR(5) FOREIGN KEY REFERENCES RaClothes(ClothesId) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT SR_ID CHECK (STransactionId LIKE 'SR[0-9][0-9][0-9]'),
	PRIMARY KEY(StransactionId)
)

CREATE TABLE RaTransactionMaterialDetail(
	MTransactionId CHAR(5) PRIMARY KEY NOT NULL,
	VendorPurchaseDate DATE,
	QtyMaterial INT,
	CONSTRAINT PU_ID CHECK (MTransactionId LIKE 'PU[0-9][0-9][0-9]')
)

CREATE TABLE RaTransactionMaterial(
	MTransactionId CHAR(5) FOREIGN KEY REFERENCES RaTransactionMaterialDetail(MTransactionId) ON DELETE CASCADE ON UPDATE CASCADE,
	StaffId CHAR(5) FOREIGN KEY REFERENCES RaStaff(StaffId) ON DELETE CASCADE ON UPDATE CASCADE,
	MaterialId CHAR(5) FOREIGN KEY REFERENCES RaMaterial(MaterialId) ON DELETE CASCADE ON UPDATE CASCADE,
	VendorId CHAR(5) FOREIGN KEY REFERENCES RaVendor(VendorId) ON DELETE CASCADE ON UPDATE CASCADE,
	PRIMARY KEY(MTransactionId)
)