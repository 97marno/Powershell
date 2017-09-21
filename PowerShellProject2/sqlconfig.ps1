If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated Powershell!"
    Break
}

# -------------------- INFORMATION -------------------- 
<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		

	.DESCRIPTION
		This script runs on PSVersion 4.0 or higher. 
		Check your Powershell version with $psversiontable

	.EXAMPLE

		PS C:\> .\sqlconfig.ps1
		
		Description
		-------------
		
		
	.OUTPUTS
		

#>

# -------------------- PARAMETERS -------------------- 
$files = @()
#$sqlscriptpath = "\\corpnet\data\IT_Media\ISO Files Database\SQL Server\StoredProcedures"
#$creds = Get-Credential

# -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE --------------------

if ($Instance -eq "MSSQLSERVER"){
	Write-Output "`r`n# -------------------- SQL SERVER CONFIGURATION -------------------- " | out-File -append -filepath $installog
	If (!(Test-Path $templocation\sql)) {
		New-Item -Path "$($templocation)\sql" -ItemType Directory
	}

	import-module "sqlps" -DisableNameChecking

	New-PSDrive -Name V -PSProvider filesystem -Root $sqlscriptpath -Credential $creds
	Copy-Item -Path V:\*.* -Destination "$($templocation)\sql"
	Remove-PSDrive V

	$files = Get-ChildItem $templocation\sql -name
	foreach($file in $files){
		Write-Output "`r$file processed" | out-File -append -filepath $installog
		invoke-sqlcmd -serverinstance "$env:computername" -inputFile "$templocation\sql\$($file)" | out-File -append -filepath $installog
	}

	Write-Output "`r`n# -------------------- DEFAULT REVOCERY MODEL (FULL OR SIMPLE) -------------------- " | out-File -append -filepath $installog
	if ($EnvProd.checked -or $EnvStage.checked -eq $true){
		$sqlquery ="DECLARE @dbname VARCHAR(50) DECLARE @recoverymodel varchar(2000) DECLARE db_cursor CURSOR FOR SELECT name FROM master.dbo.sysdatabases WHERE name NOT IN ('tempdb') OPEN db_cursor FETCH NEXT FROM db_cursor INTO @dbname WHILE @@FETCH_STATUS = 0 BEGIN SET @recoverymodel=('ALTER DATABASE [' + @dbname + '] SET RECOVERY FULL') FETCH NEXT FROM db_cursor INTO @dbname EXEC(@recoverymodel) END CLOSE db_cursor DEALLOCATE db_cursor"
		invoke-sqlcmd -serverinstance "$env:computername" -query $sqlquery
		Write-Output "Default recovery model changed to FULL" | out-File -append -filepath $installog
	}
	else
	{
		$sqlquery ="DECLARE @dbname VARCHAR(50) DECLARE @recoverymodel varchar(2000) DECLARE db_cursor CURSOR FOR SELECT name FROM master.dbo.sysdatabases WHERE name NOT IN ('tempdb') OPEN db_cursor FETCH NEXT FROM db_cursor INTO @dbname WHILE @@FETCH_STATUS = 0 BEGIN SET @recoverymodel=('ALTER DATABASE [' + @dbname + '] SET RECOVERY SIMPLE') FETCH NEXT FROM db_cursor INTO @dbname EXEC(@recoverymodel) END CLOSE db_cursor DEALLOCATE db_cursor"
		invoke-sqlcmd -serverinstance "$env:computername" -query $sqlquery
		Write-Output "Default recovery model changed to SIMPLE" | out-File -append -filepath $installog
	}

	restart-service "SQLSERVERAGENT"
	Write-Output "`r`n# -------------------- SQL SERVER AGENT RESTART -------------------- " | out-File -append -filepath $installog
	Write-Output "SQL Server Agent $instance is restarted" | out-File -append -filepath $installog
}
else{
	Write-Output "`r`n# -------------------- SQL SERVER CONFIGURATION -------------------- " | out-File -append -filepath $installog
	If (!(Test-Path $templocation\sql)) {
		New-Item -Path "$($templocation)\sql" -ItemType Directory
	}

	import-module "sqlps" -DisableNameChecking

	New-PSDrive -Name V -PSProvider filesystem -Root $sqlscriptpath -Credential $creds
	Copy-Item -Path V:\*.* -Destination "$($templocation)\sql"
	Remove-PSDrive V

	$files = Get-ChildItem $templocation\sql -name
	foreach($file in $files){
		Write-Output "`r$file processed" | out-File -append -filepath $installog
		invoke-sqlcmd -serverinstance "$env:computername\$instance" -inputFile "$templocation\sql\$($file)" | out-File -append -filepath $installog
	}
	
		Write-Output "`r`n# -------------------- DEFAULT REVOCERY MODEL (FULL OR SIMPLE) -------------------- " | out-File -append -filepath $installog
	if ($EnvProd.checked -or $EnvStage.checked -eq $true){
		$sqlquery ="DECLARE @dbname VARCHAR(50) DECLARE @recoverymodel varchar(2000) DECLARE db_cursor CURSOR FOR SELECT name FROM master.dbo.sysdatabases WHERE name NOT IN ('tempdb') OPEN db_cursor FETCH NEXT FROM db_cursor INTO @dbname WHILE @@FETCH_STATUS = 0 BEGIN SET @recoverymodel=('ALTER DATABASE [' + @dbname + '] SET RECOVERY FULL') FETCH NEXT FROM db_cursor INTO @dbname EXEC(@recoverymodel) END CLOSE db_cursor DEALLOCATE db_cursor"
		invoke-sqlcmd -serverinstance "$env:computername\$instance" -query $sqlquery
		Write-Output "Default recovery model changed to FULL" | out-File -append -filepath $installog
	}
	else
	{
		$sqlquery ="DECLARE @dbname VARCHAR(50) DECLARE @recoverymodel varchar(2000) DECLARE db_cursor CURSOR FOR SELECT name FROM master.dbo.sysdatabases WHERE name NOT IN ('tempdb') OPEN db_cursor FETCH NEXT FROM db_cursor INTO @dbname WHILE @@FETCH_STATUS = 0 BEGIN SET @recoverymodel=('ALTER DATABASE [' + @dbname + '] SET RECOVERY SIMPLE') FETCH NEXT FROM db_cursor INTO @dbname EXEC(@recoverymodel) END CLOSE db_cursor DEALLOCATE db_cursor"
		invoke-sqlcmd -serverinstance "$env:computername\$instance" -query $sqlquery
		Write-Output "Default recovery model changed to SIMPLE" | out-File -append -filepath $installog
	}

	restart-service "SQLAgent`$$($instance)"
	Write-Output "`r`n# -------------------- SQL SERVER AGENT RESTART -------------------- " | out-File -append -filepath $installog
	Write-Output "SQL Server Agent $instance is restarted" | out-File -append -filepath $installog
}