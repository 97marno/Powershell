/*------------------------------
Drop tables
--------------------------------*/

USE marlen
drop table dbo.tmpsysinfo
drop table dbo.tmpdiskinfo
drop table dbo.tmpnetwork
drop table dbo.tmpsoftware
drop table dbo.tmpserviceinv
drop table dbo.tmpsqlinfo
drop table dbo.tmpcontactinfo

/*------------------------------
Create tables
--------------------------------*/


--Sysinfo
CREATE TABLE dbo.tmpsysinfo(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null UNIQUE,
	ComputerDomain varchar(50),
	Decomissioned bit,
	Model varchar(50),
	Manufacturer varchar(50),
	InstallDate varchar(20),
	SerialNumber varchar(60),
	OperatingSystem varchar(100),
	ServicePack varchar(50),
	OSArchitecture varchar(50),
	OSLanguage varchar(50),
	InstalledMemory varchar(10),
	CPUID varchar(50),
	CPULogical varchar(20),
	CPUCores varchar(20),
	PRIMARY KEY (ID)
)

--Disk
CREATE TABLE dbo.tmpdiskinfo(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null,
	VolumeName varchar(50),
	Label varchar(50),
	CapacityGB varchar(50),
	FreeSpaceGB varchar(20),
	ProcentFree varchar(60),
	Decomissioned bit,
	PRIMARY KEY (ID)
)

--Network
CREATE TABLE dbo.tmpnetwork(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null,
	AdapterName varchar(50),
	IsDHCPEnabled varchar(5),
	IPAddress varchar(15),
	SubnetMask varchar(15),
	Gateway varchar(60),
	DNSServers varchar(60),
	MACAddress varchar(20),
	Decomissioned bit,
	PRIMARY KEY (ID)
)

--Software
CREATE TABLE dbo.tmpsoftware(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null,
	Name varchar(500),
	Vendor varchar(100),
	SWversion varchar(50),
	Decomissioned bit,
	PRIMARY KEY (ID)
)

--Services
CREATE TABLE dbo.tmpserviceinv(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null,
	DisplayName varchar(500),
	Name varchar(100),
	StartMode varchar(10),
	StartName varchar(50),
	SrcPath varchar(500),
	Decomissioned bit,
	PRIMARY KEY (ID)
)

--SQL
CREATE TABLE dbo.tmpsqlinfo(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null,
	ComputerDomain varchar(50),
	--SQLServer varchar(50), 
	MSSQL varchar(10),
	SSAS varchar(10),
	SSIS varchar(10),
	SSRS varchar(10),
	SQLVersion varchar(10),
	ResourceVersionString varchar(500),
	ProductLevel varchar(20),
	Edition varchar(100),
	InstanceName varchar(50),
	SQLPort varchar(20),
	ServerType varchar(50),
	SQLCollation varchar(50),
	IsCaseSensitive varchar(10),
	IsClustered varchar(10),
	IsFullTextInstalled varchar(10),
	LoginMode varchar(10),
	RootDirectory varchar(500),
	MasterDBPath varchar(500),
	DefaultFile varchar(500),
	DefaultLog varchar(500),
	BackupDirectory varchar(500),
	ErrorLogPath varchar(500),
	Decomissioned bit,
	PRIMARY KEY (ID)
)

--Contact info 
CREATE TABLE dbo.tmpcontactinfo(
	ID int IDENTITY(1,1) not null,
	ModifyDate DATETIME DEFAULT (GETDATE()),
	ComputerName varchar(50) not null,
	ComputerDomain varchar(50),
	Environment varchar(10),
	ApplName	varchar(50),
	AM varchar(100),
	Comment	varchar(500),
	SLA varchar(50),
	Decomissioned bit,
	PRIMARY KEY (ID)
)

select * from tmpsysinfo
select * from tmpdiskinfo
select * from tmpnetwork
select * from tmpsoftware
select * from tmpserviceinv
select * from tmpsqlinfo
select * from tmpcontactinfo


/*------------------------------
Bulk insert
--------------------------------*/
select ID,ModifyDate, Decomissioned,ComputerName into dbo.computers from dbo.sysinfo

BULK INSERT tmpsysinfo
    FROM 'B:\Marlen\csv\Perimeter\WindowsInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpdiskinfo
    FROM 'B:\Marlen\csv\Perimeter\DiskInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpnetwork
    FROM 'B:\Marlen\csv\Perimeter\NWInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpserviceinv
    FROM 'B:\Marlen\csv\Perimeter\ServicesInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpsoftware
    FROM 'B:\Marlen\csv\Perimeter\SoftwareInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpsqlinfo
    FROM 'B:\Marlen\csv\Perimeter\sqlinventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpcontactinfo
    FROM 'B:\Marlen\csv\Perimeter\contacts.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from tmpsysinfo
select * from tmpdiskinfo
select * from tmpnetwork
select * from tmpsoftware
select * from tmpserviceinv
select * from tmpsqlinfo
select * from tmpcontactinfo

BULK INSERT tmpsysinfo
    FROM 'B:\Marlen\csv\Boxer\WindowsInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpdiskinfo
    FROM 'B:\Marlen\csv\Boxer\DiskInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpnetwork
    FROM 'B:\Marlen\csv\Boxer\NWInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpserviceinv
    FROM 'B:\Marlen\csv\Boxer\ServicesInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpsoftware
    FROM 'B:\Marlen\csv\Boxer\SoftwareInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpsqlinfo
    FROM 'B:\Marlen\csv\Boxer\sqlinventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

BULK INSERT tmpcontactinfo
    FROM 'B:\Marlen\csv\Boxer\contacts.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )
