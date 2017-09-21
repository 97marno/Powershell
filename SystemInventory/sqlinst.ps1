<#
	.SYNOPSIS
		(C) Marlen Norling 2017. marlen@norling.cx
        Version 1.3
		Microsoft SQL Server Inventory using PowerShell.

	.DESCRIPTION
		This script is to document the SQL server. 

	.EXAMPLE
		PS C:\>.\sqlinst.ps1 
		Description
		-------------
		Collect a SQL Inventory of local computer and put the report in CSV format with the name SQLInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script. 
		
		PS C:\>.\sqlinst.ps1 -ComputerName Server1, Server2
		Description
		-------------
		Collect a SQL Inventory of Server1 and Server2 and put the report in CSV format with the name SQLInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script.
				
		PS C:\>.\sqlinst.ps1 -ComputerName Server1, Server2 -Path "C:\Temp"
		Description
		-------------
		Collect a SQL Inventory of Server1 and Server2 and put the report in CSV format with the name SQLInventory-yyyy-MM-dd-HH-mm.csv in the C:\Temp folder.
		
		PS C:\>.\sqlinst.ps1 -ComputerName Server1, Server2 -Path "C:\Temp" -file "SQLInventory.csv"
		Description
		-------------
		Collect a SQL Inventory of Server1 and Server2 and put the report in CSV format with the name SQLInventory.csv in the C:\Temp folder.

		PS C:\>.\sqlinst.ps1 -InputFile ".\servers.txt" 
		Description
		-------------
		Collect a SQL Inventory of all servers in the text file servers.txt and put the report in CSV format with the name SQLInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script.
		
	.OUTPUTS
		ID;ModifyDate;ComputerName;Domain;MSSQL;SSAS;SSIS;SSRS;SQLVersion;ResourceVersionString;ProductLevel;Edition;InstanceName;SQLPort;ServerType;
		Collation;IsCaseSensitive;IsClustered;IsFullTextInstalled;LoginMode;RootDirectory;DefaultFile;DefaultLog;BackupDirectory;ErrorLogPath;Decomissioned


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
			#Connect to the remote registry and search up SQL server name space
			$namespace = gwmi -computername $C -Namespace "root\microsoft\sqlserver" -Class "__Namespace" -Filter "name like 'ComputerManagement%'" | sort desc | select -ExpandProperty name -First 1			
			
			foreach ($i in $mssql) {
				if($i.name -ne "MSSQLSERVER" -and $i.name -ne "SQLEXPRESS"){
					#Find hive and SQL port with the correct instance name.
					$tcpport = Get-WmiObject -computername $c -Namespace "root\microsoft\SqlServer\$namespace" -Class ServerNetworkProtocolProperty | select instancename,propertystrval, IPAddressName | where{$_.IPAddressName -eq 'IPAll' -and $_.propertystrval -ne '' -and $_.instancename -eq $i.name}
                    $SQLServer = $ComputerSystem.name + '\' + $i.name
                    if ($tcpport.propertystrval -eq 1433 -or !$tcpport){
                        $sqlport = 1433
                        $cSQL =$SQLServer #+ ',' + $sqlport
						$sql = new-object ("Microsoft.SqlServer.Management.Smo.Server") $cSQL
                    } 
                    else{
						$sqlport = $tcpport.propertystrval
                        $cSQL =$SQLServer + ',' + $sqlport
						$sql = new-object ("Microsoft.SqlServer.Management.Smo.Server") $cSQL
                    }
				}		
				else{
					#Find hive and SQL port with the correct instance name.
					$tcpport = Get-WmiObject -computername $C -Namespace "root\microsoft\SqlServer\$namespace" -Class ServerNetworkProtocolProperty | select instancename,propertystrval, IPAddressName | where{$_.IPAddressName -eq 'IPAll' -and $_.propertystrval -ne '' -and $_.instancename -eq $i.name}
                    $SQLServer = $ComputerSystem.name
                    if ($tcpport.propertystrval -eq 1433 -or !$tcpport){
                        $sqlport = 1433                        
                        $cSQL =$SQLServer #+ ',' + $sqlport
						$sql = new-object ("Microsoft.SqlServer.Management.Smo.Server") $cSQL
                    } 
                    else{
						$sqlport = $tcpport.propertystrval
                       	$cSQL =$SQLServer + ',' + $sqlport
						$sql = new-object ("Microsoft.SqlServer.Management.Smo.Server") $cSQL
                    }
				}
				
				$ResourceVersionString=''
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
						
                       # $instancename = $SQLInstance.Name -replace "$c"+'\\' 
                        
						$reportinfo = New-Object -Type PSObject
						$reportinfo | Add-Member -MemberType NoteProperty -name ID -Value $ID
						$reportinfo | Add-Member -MemberType NoteProperty -name ModifyDate -Value $Date
						$reportinfo | Add-Member -MemberType NoteProperty -name ComputerName -Value $ComputerSystem.name
						$reportinfo | Add-Member -MemberType NoteProperty -name Domain -Value $ComputerSystem.domain
						$reportinfo | Add-Member -MemberType NoteProperty -Name MSSQL -Value $MSSQL
						$reportinfo | Add-Member -MemberType NoteProperty -Name SSAS -Value $SSAS
						$reportinfo | Add-Member -MemberType NoteProperty -Name SSIS -Value $SSIS
						$reportinfo | Add-Member -MemberType NoteProperty -Name SSRS -Value $SSRS
						$reportinfo | Add-Member -MemberType NoteProperty -Name SQLVersion -Value $sql.ResourceVersionString
						$reportinfo | Add-Member -MemberType NoteProperty -Name ResourceVersionString -Value $ResourceVersionString
						$reportinfo | Add-Member -MemberType NoteProperty -Name ProductLevel -Value $sql.ProductLevel
						$reportinfo | Add-Member -MemberType NoteProperty -Name Edition -Value $sql.Edition
						$reportinfo | Add-Member -MemberType NoteProperty -Name InstanceName -Value $i.Name
						$reportinfo | Add-Member -MemberType NoteProperty -Name SQLPort -Value $sqlport
						$reportinfo | Add-Member -MemberType NoteProperty -Name ServerType -Value $sql.ServerType
						$reportinfo | Add-Member -MemberType NoteProperty -Name Collation -Value $sql.collation
						$reportinfo | Add-Member -MemberType NoteProperty -Name IsCaseSensitive -Value $sql.IsCaseSensitive
						$reportinfo | Add-Member -MemberType NoteProperty -Name IsClustered -Value $sql.IsClustered
						$reportinfo | Add-Member -MemberType NoteProperty -Name IsFullTextInstalled -Value $sql.IsFullTextInstalled
						$reportinfo | Add-Member -MemberType NoteProperty -Name LoginMode -Value $sql.LoginMode
						$reportinfo | Add-Member -MemberType NoteProperty -Name RootDirectory -Value $sql.RootDirectory
						$reportinfo | Add-Member -MemberType NoteProperty -Name MasterDBPath -Value $sql.MasterDBPath
						$reportinfo | Add-Member -MemberType NoteProperty -Name DefaultFile -Value $sql.DefaultFile
						$reportinfo | Add-Member -MemberType NoteProperty -Name DefaultLog -Value $sql.DefaultLog
						$reportinfo | Add-Member -MemberType NoteProperty -Name BackupDirectory -Value $sql.BackupDirectory
						$reportinfo | Add-Member -MemberType NoteProperty -Name ErrorLogPath -Value $sql.ErrorLogPath
						$reportinfo | Add-Member -MemberType NoteProperty -name Decomissioned -Value $Decomissioned

						#Create report array
						$report += $reportinfo		
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