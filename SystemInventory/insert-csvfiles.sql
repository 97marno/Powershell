/*.\Get-DiskSpaceUsage.ps1 | export-csv -Path "B:\Marlen\csv\diskspace.csv" -NoTypeInformation -delimiter ";"
(Get-Content C:\Users\Public\diskspace.csv) | foreach {$_ -replace '"'} | Set-Content B:\Marlen\csv\diskspace.csv
(Get-Content C:\Users\Public\diskspace.csv) | foreach {$_ -replace ',',"."} | Set-Content B:\Marlen\csv\diskspace.csv
*/

/*------------------------------
Create tables
--------------------------------*/
USE marlen

--Sysinfo
CREATE TABLE dbo.sysinfo(
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
)

--Disk
CREATE TABLE dbo.diskinfo(
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
CREATE TABLE dbo.network(
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
CREATE TABLE dbo.software(
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
CREATE TABLE dbo.serviceinv(
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
CREATE TABLE dbo.sqlinfo(
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
CREATE TABLE dbo.contactinfo(
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
/* 

drop table dbo.sysinfo
drop table dbo.diskinfo
drop table dbo.network
drop table dbo.software
drop table dbo.serviceinv
drop table dbo.sqlinfo
drop table dbo.contactinfo
ALTER TABLE ORDERS 
   ADD FOREIGN KEY () REFERENCES CUSTOMERS (ID);

*/

"id";"SystemName";"Name";"Label";"Capacity(GB)";"FreeSpace(GB)";"ProcentFree(%)"


	Size decimal(6,2),
	Free decimal(6,2),
	PrecentFree decimal(5,2)
	
	
use marlen

BULK INSERT sysinfo
    FROM 'B:\Marlen\csv\WindowsInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from sysinfo


BULK INSERT diskinfo
    FROM 'B:\Marlen\csv\DiskInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )
select * from diskinfo

BULK INSERT network
    FROM 'B:\Marlen\csv\NWInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from network

BULK INSERT serviceinv
    FROM 'B:\Marlen\csv\ServicesInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from serviceinv

BULK INSERT software
    FROM 'B:\Marlen\csv\SoftwareInventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from software

BULK INSERT sqlinfo
    FROM 'B:\Marlen\csv\sqlinventory.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from sqlinfo where ssas ='TRUE'

BULK INSERT contactinfo
    FROM 'B:\Marlen\csv\contacts.csv'
    WITH
    (
    FIRSTROW = 2,
    FIELDTERMINATOR = ';',  --CSV field delimiter
    ROWTERMINATOR = '\n',   --Use to shift the control to next row
    --ERRORFILE = 'C:\CSVDATA\SchoolsErrorRows.csv',
    TABLOCK
    )

select * from sysinfo
select * from diskinfo
select * from network
select * from software
select * from serviceinv
select * from sqlinfo
select * from contactinfo

select * from master.sys.sysdatabases
select @@version