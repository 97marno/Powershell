
/*------------------------------
Merge tables
--------------------------------*/

/*------------------------------
	Sysinfo
--------------------------------*/
	MERGE INTO dbo.sysinfo AS C
	USING (SELECT ModifyDate,Decomissioned,ComputerName,ComputerDomain,Model,Manufacturer,InstallDate,SerialNumber,OperatingSystem,ServicePack,OSArchitecture,OSLanguage,InstalledMemory,CPUID,CPUcores,CPULogical FROM dbo.tmpsysinfo) AS CT

	ON	(C.[Computername] = CT.[Computername])

	WHEN MATCHED THEN
	  UPDATE SET       
			C.[ModifyDate]	=	CT.[ModifyDate],
			C.[Decomissioned]	=	CT.[Decomissioned],
			C.[ComputerDomain]	=	CT.[ComputerDomain],
			C.[Model]	=	CT.[Model],
			C.[Manufacturer]	=	CT.[Manufacturer],
			C.[InstallDate]	=	CT.[InstallDate],
			C.[SerialNumber]	=	CT.[SerialNumber],
			C.[OperatingSystem]	=	CT.[OperatingSystem],
			C.[ServicePack]	=	CT.[ServicePack],
			C.[OSArchitecture]	=	CT.[OSArchitecture],
			C.[OSLanguage]	=	CT.[OSLanguage],
			C.[InstalledMemory]	=	CT.[InstalledMemory],
			C.[CPUID]	=	CT.[CPUID],
			C.[CPUcores]	=	CT.[CPUcores],
			C.[CPULogical]	=	CT.[CPULogical]

	WHEN NOT MATCHED THEN 
		INSERT (ModifyDate,Decomissioned,ComputerName,ComputerDomain,Model,Manufacturer,InstallDate,SerialNumber,OperatingSystem,ServicePack,OSArchitecture,OSLanguage,InstalledMemory,CPUID,CPUcores,CPULogical)
		VALUES (CT.[ModifyDate], CT.[Decomissioned], CT.[ComputerName], CT.[ComputerDomain], CT.[Model], CT.[Manufacturer], CT.[InstallDate], CT.[SerialNumber], CT.[OperatingSystem], CT.[ServicePack], CT.[OSArchitecture], CT.[OSLanguage], CT.[InstalledMemory], CT.[CPUID], CT.[CPUcores], CT.[CPULogical]);

	select * from dbo.sysinfo where ComputerName = 'S1WEBDB-P'
	select * from dbo.tmpsysinfo where ComputerName = 'S1WEBDB-P'

/*------------------------------
	Diskinfo
--------------------------------*/
	
	MERGE INTO dbo.diskinfo AS C
	USING (SELECT ComputerName,ModifyDate,VolumeName,Label,CapacityGB,FreeSpaceGB,ProcentFree,Decomissioned FROM dbo.tmpdiskinfo) AS CT

	ON	(C.[Computername] = CT.[Computername] AND C.[VolumeName] = CT.[Volumename])

	WHEN MATCHED THEN
	  UPDATE SET    
		   C.[ModifyDate]	=	CT.[ModifyDate],
		   C.[Label] = CT.[Label],
		   C.[CapacityGB] = CT.[CapacityGB],
		   C.[FreeSpaceGB] = CT.[FreeSpaceGB],
		   C.[ProcentFree] = CT.[ProcentFree],
		   C.[Decomissioned]	=	CT.[Decomissioned]

	WHEN NOT MATCHED THEN 
		INSERT (ComputerName,ModifyDate,VolumeName,Label,CapacityGB,FreeSpaceGB,ProcentFree,Decomissioned)
		VALUES (CT.[ComputerName], CT.[ModifyDate], CT.[Volumename], CT.[Label], CT.[CapacityGB], CT.[FreeSpaceGB], CT.[ProcentFree],CT.[Decomissioned]); 
		--select @@identity
		select * from dbo.diskinfo where ComputerName = 'S1WEBDB-P'
		select * from dbo.tmpdiskinfo where ComputerName = 'S1WEBDB-P'
/*------------------------------
	Network
--------------------------------*/
		
	MERGE INTO dbo.network AS C
	USING (SELECT ComputerName,ModifyDate,AdapterName,IsDHCPEnabled,IPAddress,SubnetMask,Gateway,DNSServers,MACAddress,Decomissioned FROM dbo.tmpnetwork) AS CT

	ON	( C.[ComputerName]	=	CT.[ComputerName] AND
			C.[MACAddress]	=	CT.[MACAddress])

	WHEN MATCHED THEN
	  UPDATE SET  
		C.[ModifyDate]	=	CT.[ModifyDate],
		C.[AdapterName]	=	CT.[AdapterName],
		C.[IsDHCPEnabled]	=	CT.[IsDHCPEnabled],
		C.[IPAddress]	=	CT.[IPAddress],
		C.[SubnetMask]	=	CT.[SubnetMask],
		C.[Gateway]	=	CT.[Gateway],
		C.[DNSServers]	=	CT.[DNSServers],
		C.[Decomissioned]	=	CT.[Decomissioned]
		

	WHEN NOT MATCHED THEN 
		INSERT (ComputerName,ModifyDate,AdapterName,IsDHCPEnabled,IPAddress,SubnetMask,Gateway,DNSServers,MACAddress,Decomissioned)
		VALUES (CT.[ComputerName],CT.[ModifyDate], CT.[AdapterName], CT.[IsDHCPEnabled], CT.[IPAddress], CT.[SubnetMask], CT.[Gateway], CT.[DNSServers], CT.[MACAddress],CT.[Decomissioned]);	
			
	select * from dbo.network where ComputerName = 'S1WEBDB-P'
	select * from dbo.tmpnetwork where ComputerName = 'S1WEBDB-P'

/*------------------------------
	Software
--------------------------------*/
		
		
	MERGE INTO dbo.software AS C
	USING (SELECT ComputerName,ModifyDate,Name,Vendor,SWversion,Decomissioned FROM dbo.tmpsoftware) AS CT

	ON	(C.[ComputerName]	=	CT.[ComputerName] AND
			C.[Name]	=	CT.[Name] and 
			C.[SWversion]	=	CT.[SWversion])

	WHEN NOT MATCHED THEN 
		INSERT (ComputerName,ModifyDate,Name,Vendor,SWversion,Decomissioned)
		VALUES (CT.[ComputerName],CT.[ModifyDate], CT.[Name], CT.[Vendor], CT.[SWversion],CT.[Decomissioned]);	

	select * from dbo.software where ComputerName = 'S1WEBDB-P'
	select * from dbo.tmpsoftware where ComputerName = 'S1WEBDB-P'

/*------------------------------
	Services
--------------------------------*/
	
	MERGE INTO dbo.serviceinv AS C
	USING (SELECT ComputerName,ModifyDate,DisplayName,Name,StartMode,StartName,SrcPath,Decomissioned FROM dbo.tmpserviceinv) AS CT

	ON	(C.[ComputerName]	=	CT.[ComputerName] AND 
		C.[Name]	=	CT.[Name])

	WHEN MATCHED THEN
	  UPDATE SET       
		C.[ModifyDate]	=	CT.[ModifyDate],
		C.[DisplayName]	=	CT.[DisplayName],
		C.[StartMode]	=	CT.[StartMode],
		C.[StartName]	=	CT.[StartName],
		C.[SrcPath]	=	CT.[SrcPath],
		C.[Decomissioned]	=	CT.[Decomissioned]

	WHEN NOT MATCHED THEN 
		INSERT (ComputerName,ModifyDate,DisplayName,Name,StartMode,StartName,SrcPath,Decomissioned)
		VALUES (CT.[ComputerName],CT.[ModifyDate], CT.[DisplayName], CT.[Name], CT.[StartMode], CT.[StartName], CT.[SrcPath],CT.[Decomissioned]);	

	select * from dbo.serviceinv where ComputerName = 'S1WEBDB-P'
	select * from dbo.tmpserviceinv where ComputerName = 'S1WEBDB-P'


/*------------------------------
	SQL
--------------------------------*/
			
	MERGE INTO dbo.sqlinfo AS C
	USING (SELECT ComputerName,ModifyDate,ComputerDomain,MSSQL,SSAS,SSIS,SSRS,SQLVersion,ResourceVersionString,ProductLevel,Edition,InstanceName,SQLPort,ServerType,SQLCollation,IsCaseSensitive,IsClustered,IsFullTextInstalled,LoginMode,RootDirectory,MasterDBPath,DefaultFile,DefaultLog,BackupDirectory,ErrorLogPath,Decomissioned FROM dbo.tmpsqlinfo) AS CT

	ON	(C.[ComputerName]	=	CT.[ComputerName] and C.[InstanceName]	=	CT.[InstanceName])

	WHEN MATCHED THEN
	  UPDATE SET       
		C.[ModifyDate]	=	CT.[ModifyDate],
		C.[ComputerDomain]	=	CT.[ComputerDomain],
		C.[MSSQL]	=	CT.[MSSQL],
		C.[SSAS]	=	CT.[SSAS],
		C.[SSIS]	=	CT.[SSIS],
		C.[SSRS]	=	CT.[SSRS],
		C.[SQLVersion]	=	CT.[SQLVersion],
		C.[ResourceVersionString]	=	CT.[ResourceVersionString],
		C.[ProductLevel]	=	CT.[ProductLevel],
		C.[Edition]	=	CT.[Edition],
		C.[InstanceName]	=	CT.[InstanceName],
		C.[ServerType]	=	CT.[ServerType],
		C.[SQLCollation]	=	CT.[SQLCollation],
		C.[IsCaseSensitive]	=	CT.[IsCaseSensitive],
		C.[IsClustered]	=	CT.[IsClustered],
		C.[IsFullTextInstalled]	=	CT.[IsFullTextInstalled],
		C.[LoginMode]	=	CT.[LoginMode],
		C.[RootDirectory]	=	CT.[RootDirectory],
		C.[MasterDBPath]	=	CT.[MasterDBPath],
		C.[DefaultFile]	=	CT.[DefaultFile],
		C.[DefaultLog]	=	CT.[DefaultLog],
		C.[BackupDirectory]	=	CT.[BackupDirectory],
		C.[ErrorLogPath]	=	CT.[ErrorLogPath],
		C.[Decomissioned]	=	CT.[Decomissioned],
		C.[SQLPort]	=	CT.[SQLPort]
				

	WHEN NOT MATCHED THEN 
		INSERT (ComputerName,ModifyDate,ComputerDomain,MSSQL,SSAS,SSIS,SSRS,SQLVersion,ResourceVersionString,ProductLevel,Edition,InstanceName,SQLPort,ServerType,SQLCollation,IsCaseSensitive,IsClustered,IsFullTextInstalled,LoginMode,RootDirectory,MasterDBPath,DefaultFile,DefaultLog,BackupDirectory,ErrorLogPath,Decomissioned)
		VALUES (CT.[ComputerName],CT.[ModifyDate], CT.[ComputerDomain], CT.[MSSQL], CT.[SSAS], CT.[SSIS], CT.[SSRS],CT.[SQLVersion], CT.[ResourceVersionString], CT.[ProductLevel], CT.[Edition], CT.[InstanceName], CT.[SQLPort], CT.[ServerType], CT.[SQLCollation], CT.[IsCaseSensitive], CT.[IsClustered], CT.[IsFullTextInstalled], CT.[LoginMode], CT.[RootDirectory], CT.[MasterDBPath],CT.[DefaultFile], CT.[DefaultLog], CT.[BackupDirectory], CT.[ErrorLogPath],CT.[Decomissioned]);		


	--select * from dbo.sqlinfo where ComputerName = 'S1WEBDB-P'
	--select * from dbo.tmpsqlinfo where ComputerName = 'S1WEBDB-P'
	--delete from sqlinfo where id = '141'

/*------------------------------
	Contacts
--------------------------------*/
		
	MERGE INTO dbo.contactinfo AS C
	USING (SELECT ComputerName,ComputerDomain,Environment,ApplName,AM,[Comment],SLA,Decomissioned FROM dbo.tmpcontactinfo) AS CT

	ON	(C.[ComputerName]	=	CT.[ComputerName] AND
			C.[ComputerDomain]	=	CT.[ComputerDomain])

	WHEN MATCHED THEN
	  UPDATE SET       
		C.[Environment]	=	CT.[Environment],
		C.[ApplName]	=	CT.[ApplName],
		C.[AM]	=	CT.[AM],
		C.[Comment]	=	CT.[Comment],
		C.[SLA]	=	CT.[SLA],
		C.[Decomissioned]	=	CT.[Decomissioned]


	WHEN NOT MATCHED THEN 
		INSERT (ComputerName,ComputerDomain,Environment,ApplName,AM,[Comment],SLA,Decomissioned)
		VALUES (CT.[ComputerName], CT.[ComputerDomain], CT.[Environment], CT.[ApplName], CT.[AM], CT.[Comment], CT.[SLA],CT.[Decomissioned]);	
			
	select * from dbo.contactinfo where ComputerName = 'S1WEBDB-P'
	select * from dbo.tmpcontactinfo where ComputerName = 'S1WEBDB-P'	