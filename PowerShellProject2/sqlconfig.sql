-- Change memory options
declare @memory int
select @memory = physical_memory_kb from sys.dm_os_sys_info
select @memory = (@memory/1024)-4096

EXEC sys.sp_configure N'show advanced options', N'1'  RECONFIGURE WITH OVERRIDE
EXEC sys.sp_configure N'min server memory (MB)', N'2048'
EXEC sys.sp_configure N'max server memory (MB)', @memory
RECONFIGURE WITH OVERRIDE
EXEC sys.sp_configure N'show advanced options', N'0'  RECONFIGURE WITH OVERRIDE
--select physical_memory_kb from sys.dm_os_sys_info

-- Change Audit Level
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'AuditLevel', REG_DWORD, 3

-- Activate DAC
EXEC sp_configure 'remote admin connections', 1;
RECONFIGURE

-- Adjust model
ALTER DATABASE [model] MODIFY FILE (NAME = N'modeldev', SIZE = 20MB, FILEGROWTH = 100MB)
ALTER DATABASE [model] MODIFY FILE (NAME = N'modellog', SIZE = 20MB, FILEGROWTH = 100MB)

/* Adjust tempdb
Set tempdb size to 2400 MB by creating as many equally sized datafiles as logical cpu:s. Max number of files is limited to 8
Logfile is set to 2 times the data file size. Autogrowth is set to 100 MB
*/

DECLARE @sockets int, @datafile_size int, @i int, @datafile_name nvarchar(255), @datafile_path nvarchar(255),@cmd nvarchar(255)

SELECT @sockets = cpu_count FROM sys.dm_os_sys_info
IF (@sockets > 8) SET @sockets = 8

SELECT @datafile_size = (2400/@sockets)*1024	-- tempdb size = 2400 MB, size in KB
SELECT @datafile_path = (SELECT filename FROM tempdb..sysfiles WHERE name = 'tempdev')
SELECT @datafile_path = LEFT(@datafile_path, LEN(@datafile_path)-10) --remove "tempdb.mdf"

SELECT @cmd = 'ALTER DATABASE [tempdb] MODIFY FILE (NAME = N''tempdev'', SIZE = ' + CAST(@datafile_size AS nvarchar) + 'KB, FILEGROWTH = 100MB)'
EXEC (@cmd)

SELECT @cmd = 'ALTER DATABASE [tempdb] MODIFY FILE (NAME = N''templog'', SIZE = ' + CAST(2*@datafile_size AS nvarchar) + 'KB, FILEGROWTH = 100MB)'
EXEC (@cmd)

IF (@sockets > 1)
BEGIN
	SELECT @i = 2
	WHILE (@i <= @sockets)
	BEGIN
		SELECT @datafile_name = @datafile_path + 'tempdb' + CAST(@i AS nvarchar) + '.ndf'
		SELECT @cmd = 'ALTER DATABASE [tempdb] ADD FILE (NAME = N''tempdev' + CAST(@i AS nvarchar) + ''', FILENAME = ''' + @datafile_name + ''', SIZE = ' + CAST(@datafile_size AS nvarchar) + 'KB, FILEGROWTH = 100MB)'
		EXEC (@cmd)
		SELECT @i = @i + 1
	END
END

EXEC sp_helpdb tempdb