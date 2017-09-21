


<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		Windows Machine Network Inventory using PowerShell.

	.DESCRIPTION
		This script is to document the Windows machine. 

	.EXAMPLE
		PS C:\>.\networkinfo.ps1 
		Description
		-------------
		Collect an Network Inventory of local computer and put the report in CSV format with the name NWInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script. 
		
		PS C:\>.\networkinfo.ps1 -ComputerName Server1, Server2
		Description
		-------------
		Collect an Network Inventory of Server1 and Server2 and put the report in CSV format with the name NWInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script.
				
		PS C:\>.\networkinfo.ps1  --ComputerName Server1, Server2 -Path "C:\Temp"
		Description
		-------------
		Collect an Network Inventory of Server1 and Server2 and put the report in CSV format with the name NWInventory-yyyy-MM-dd-HH-mm.csv in the C:\Temp folder.
		
		PS C:\>.\networkinfo.ps1  --ComputerName Server1, Server2 -Path "C:\Temp" -file "NWInventory.csv"
		Description
		-------------
		Collect an Network Inventory of Server1 and Server2 and put the report in CSV format with the name NWInventory.csv in the C:\Temp folder.
		
	.OUTPUTS
		ID, ComputerName, AdapterName, IPAddress, SubnetMask, Gateway, IsDHCPEnabled, DNSServers, MACAddress

#>
#=======================================================================================================================

######################
# PARAMETERS
######################
[cmdletBinding(SupportsShouldProcess=$false, DefaultParametersetName='computername')]
param(
	[Parameter(
		Mandatory=$false,
		ParameterSetName='computername',
		HelpMessage='Computer Name(s)'
	)] 
	[alias('computer')]
	[string[]]
	#$ComputerName = "s-k1skypefe-p"
	$ComputerName = "."
	,
	[Parameter(Mandatory=$false)] 
	[alias('Directory','Path')]
	[ValidateNotNullOrEmpty()]
	[string]
	$DirectoryPath = ".\"
	,
	[Parameter(Mandatory=$false)] 
	[alias('File')]
	[ValidateNotNullOrEmpty()]
	[string]
	$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('SQLInventory - ' + (Get-Date -Format 'yyyy-MM-dd-HH-mm') + '.csv'))
	#$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('sql.csv'))
	,
	[Parameter(Mandatory=$false)] 
	[ValidateNotNullOrEmpty()]
	[string]
	$Inputfile = ""
)
#####################
# 
#####################
If ($Inputfile.length -gt 0) {
	$ComputerName = Get-Content $Inputfile | ForEach-Object {$_ }
}

#Add required SMO Assembly
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null

$ErrorActionPreference = 'SilentlyContinue'  
$ErrorLog = ".\error_sql.log"
$ID = ""
$date =  get-date -format 'yyyy-MM-dd HH:mm'
$Decomissioned = 0

$report = @()
$MSSQL = @()

foreach ($c in $ComputerName) {
	if(Test-Connection -ComputerName $c -Count 1 -ea 0 -ev Err){ 
		$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
		if ($Err){Write-Host ""$c": Can't connect to server via WMI" -Foregroundcolor Red
				 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - WMI connection unavailable"
				 Add-Content -Path $ErrorLog "**********************************************************************************"
				 Add-Content -Path $ErrorLog " $Err" 
				 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
		}		 
		else{
			 
			$MSSQL = Get-Service -displayname 'SQL Server (*' -computername $c | select @{n='Name';e={$_.name -replace 'MSSQL[$]'}} #special characters within brackets 
			#write-host $mssql
			#$MSSQL = Get-Service -Name *MSSQL* -computername $c | select @{n='Name';e={$_.name -replace 'MSSQL[$]'}} #special characters within brackets
			$dbConnection = New-Object System.Data.SqlClient.SqlConnection -EV Err -EA SilentlyContinue
			foreach ($i in $mssql) {
			#write-host $i
				if($i.name -ne "MSSQLSERVER" -and $i.name -ne "SQLEXPRESS"){
					#if($i.name -ne "SQLEXPRESS"){
					$SQLServer = $ComputerSystem.name + '\' + $i.name
					#write-host $SQLServer
					$dbConnection.ConnectionString = ("Server=$SQLServer;Database=master;Integrated Security=True;Connect Timeout=3")
					$dbConnection.Open()
					#write-host $dbconnection.state
					if ($dbConnection.State -eq 'Closed'){
							 Write-Host ""$SQLServer": No database connection to server" -Foregroundcolor Red
							 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $SQLServer - No database connection"
							 Add-Content -Path $ErrorLog "**********************************************************************************"
							 Add-Content -Path $ErrorLog " $Err" 
							 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
							 
							$dbConnection.ConnectionString = ("Server=$SQLServer,1433;Database=master;Integrated Security=True;Connect Timeout=3")
							$dbConnection.Open()
							#write-host $dbconnection.state
							if ($dbConnection.State -eq 'Closed'){
								Write-Host ""$SQLServer": No database connection to server on specific port 1433" -Foregroundcolor Red
								Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $SQLServer - No database connection"
								Add-Content -Path $ErrorLog "**********************************************************************************"
								Add-Content -Path $ErrorLog " $Err" 
								Add-Content -Path $ErrorLog " `r" # `r means new carrige return
							} 
					}
				}		
				else{
					$SQLServer = $ComputerSystem.name
					$dbConnection.ConnectionString = ('Data Source= ' + $SQLServer + '; Database=master;Integrated Security=True;Connect Timeout=3')
					$dbConnection.Open()
					#write-host $dbConnection.state
					if ($dbConnection.State -eq 'Closed'){
						 Write-Host ""$SQLServer": No database connection to server" -Foregroundcolor Red
						 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - No database connection"
						 Add-Content -Path $ErrorLog "**********************************************************************************"
						 Add-Content -Path $ErrorLog " $Err" 
						 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
					}
				}
				While ($dbConnection.State -eq 'Open'){
					$SQLInstance = New-Object Microsoft.SqlServer.Management.Smo.Server $SQLServer
					foreach ($sql in $SQLInstance) {
					
						#Get SQL Server Edition
						If ($sql.ResourceVersionString.StartsWith("13.0")) {$ResourceVersionString = "Microsoft SQL Server 2016"} 
								else {If ($sql.ResourceVersionString.StartsWith("12.0")) {$ResourceVersionString = "Microsoft SQL Server 2014"} 
									else {If ($sql.ResourceVersionString.StartsWith("11.0")) {$ResourceVersionString = "Microsoft SQL Server 2012"} 
										else {If ($sql.ResourceVersionString.StartsWith("10.5")) {$ResourceVersionString = "Microsoft SQL Server 2008 R2"} 
											else {If ($sql.ResourceVersionString.StartsWith("10.0")) {$ResourceVersionString = "Microsoft SQL Server 2008"} 
												else {If ($sql.ResourceVersionString.StartsWith("9.0")) {$ResourceVersionString = "Microsoft SQL Server 2005"} 
													else {If ($sql.ResourceVersionString.StartsWith("8.0")) {$ResourceVersionString = "Microsoft SQL Server 2000"} 
														else {$ResourceVersionString = $sql.ResourceVersionString}
													}	
												}
											}
										}
									}
								}
											
						$MSSQL = Get-Service -Name *MSSQL* -computername $c  -ErrorAction SilentlyContinue
						$SSAS = Get-Service -Name *MSOLAP* -computername $c  -ErrorAction SilentlyContinue
						$SSIS = Get-Service -Name *MSDtsServer* -computername $c  -ErrorAction SilentlyContinue
						$SSRS = Get-Service -Name *ReportServer* -computername $c  -ErrorAction SilentlyContinue
							if ($MSSQL.Length -gt 0) {$MSSQL = "True"} else {$MSSQL = "False"}
							if ($SSAS.Length -gt 0) {$SSAS = "True"} else {$SSAS = "False"}
							if ($SSIS.Length -gt 0) {$SSIS = "True"} else {$SSIS = "False"}
							if ($SSRS.Length -gt 0) {$SSRS = "True"} else {$SSRS = "False"}
						
						$reportinfo = New-Object -Type PSObject
						$reportinfo | Add-Member -MemberType NoteProperty -name ID -Value $ID
						$reportinfo | Add-Member -MemberType NoteProperty -name ModifyDate -Value $Date
						$reportinfo | Add-Member -MemberType NoteProperty -name ComputerName -Value $SQLServer
						$reportinfo | Add-Member -MemberType NoteProperty -name Domain -Value $ComputerSystem.domain
						$reportinfo | Add-Member -MemberType NoteProperty -Name MSSQL -Value $MSSQL
						$reportinfo | Add-Member -MemberType NoteProperty -Name SSAS -Value $SSAS
						$reportinfo | Add-Member -MemberType NoteProperty -Name SSIS -Value $SSIS
						$reportinfo | Add-Member -MemberType NoteProperty -Name SSRS -Value $SSRS
						$reportinfo | Add-Member -MemberType NoteProperty -Name ResourceVersionString -Value $ResourceVersionString
						$reportinfo | Add-Member -MemberType NoteProperty -Name ProductLevel -Value $sql.ProductLevel
						$reportinfo | Add-Member -MemberType NoteProperty -Name Edition -Value $sql.Edition
						$reportinfo | Add-Member -MemberType NoteProperty -Name InstanceName -Value $sql.InstanceName
						$reportinfo | Add-Member -MemberType NoteProperty -Name ServerType -Value $sql.ServerType
						$reportinfo | Add-Member -MemberType NoteProperty -Name Collation -Value $sql.collation
						$reportinfo | Add-Member -MemberType NoteProperty -Name IsCaseSensitive -Value $sql.IsCaseSensitive
						$reportinfo | Add-Member -MemberType NoteProperty -Name IsClustered -Value $sql.IsClustered
						$reportinfo | Add-Member -MemberType NoteProperty -Name IsFullTextInstalled -Value $sql.IsFullTextInstalled
						$reportinfo | Add-Member -MemberType NoteProperty -Name LoginMode -Value $sql.LoginMode
						$reportinfo | Add-Member -MemberType NoteProperty -Name RootDirectory -Value $sql.RootDirectory
						$reportinfo | Add-Member -MemberType NoteProperty -Name DefaultFile -Value $sql.DefaultFile
						$reportinfo | Add-Member -MemberType NoteProperty -Name DefaultLog -Value $sql.DefaultLog
						$reportinfo | Add-Member -MemberType NoteProperty -Name BackupDirectory -Value $sql.BackupDirectory
						$reportinfo | Add-Member -MemberType NoteProperty -Name ErrorLogPath -Value $sql.ErrorLogPath
						$reportinfo | Add-Member -MemberType NoteProperty -name Decomissioned -Value $Decomissioned

						#Create report array
						$report += $reportinfo					
					}	
					$dbConnection.close()
				}	
			}
		}
	}	
	else {
		 Write-Host ""$c" : Testing connection to computer failed" -Foregroundcolor Red
		 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - Ping request timed out"
		 Add-Content -Path $ErrorLog "**********************************************************************************"
		 Add-Content -Path $ErrorLog " $Err" 
		 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
	}
	
}

If ($report){
	#Write and export report to CSV
	$report | export-csv -Path "$BasePath" -NoTypeInformation -delimiter ";" -encoding UTF8
	
	#Convert CSV for import to SQL database
	(Get-Content $BasePath) | foreach {$_ -replace '"'} | Set-Content $BasePath
	(Get-Content $BasePath) | foreach {$_ -replace ',',"."} | Set-Content $BasePath	
}
