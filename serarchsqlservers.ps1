<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		Windows Machine Inventory Using PowerShell.

	.DESCRIPTION
		This script is to document the Windows machine. 

	.EXAMPLE
		PS C:\> .\sysinfo.ps1 
		Description
		-------------
		Collect an inventory of local computer and put the report in CSV format with the name WindowsInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script. 
		
		PS C:\> .\sysinfo.ps1 -ComputerName Server1, Server2
		Description
		-------------
		Collect an inventory of Server1 and Server2 and put the report in CSV format with the name WindowsInventory-yyyy-MM-dd-HH-mm.csv in the same folder as executing script.
				
		PS C:\> .\sysinfo.ps1  --ComputerName Server1, Server2 -Path "C:\Temp"
		Description
		-------------
		Collect an inventory of Server1 and Server2 and put the report in CSV format with the name WindowsInventory-yyyy-MM-dd-HH-mm.csv in the C:\Temp folder.
		
		PS C:\> .\sysinfo.ps1  --ComputerName Server1, Server2 -Path "C:\Temp" -file "myinventory.csv"
		Description
		-------------
		Collect an inventory of Server1 and Server2 and put the report in CSV format with the name myinventory.csv in the C:\Temp folder.
		
	.OUTPUTS
		ExportDate, ComputerName, Domain, Model, Manufacturer, InstallDate, SerialNumber, OperatingSystem, ServicePack, OSArchitecture, OSLanguage, InstalledMemory, CPULogical, CPUcores

#>
#=======================================================================================================================

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
	$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('SearchSQLService - ' + (Get-Date -Format 'yyyy-MM-dd-HHmm') + '.csv'))
	,
	[Parameter(Mandatory=$false)] 
	[ValidateNotNullOrEmpty()]
	[string]
	$Inputfile = ""
)

If ($Inputfile.length -gt 0) {
	$ComputerName = Get-Content $Inputfile | ForEach-Object {$_ }
}
$ID =""
$date =  get-date -format 'yyyy-MM-dd HH:mm'
$ErrorLog = ".\error_search.log"
$Decomissioned = 0
$report = @()

Foreach ($c in $ComputerName){
	if(Test-Connection -ComputerName $c -Count 1 -ea 0){ 
		$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
		if ($Err){Write-Host ""$c": Can't connect to server via WMI" -Foregroundcolor Red
				 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - WMI connection unavailable"
				 Add-Content -Path $ErrorLog "**********************************************************************************"
				 Add-Content -Path $ErrorLog " $Err" 
				 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
		}
		Else 
		{
			$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c 
			$MSSQL = Get-Service -displayname 'SQL Server (*' -computername $c | select @{n='Name';e={$_.name -replace 'MSSQL[$]'}} #special characters within brackets 
			$MSSQL = Get-Service -Name *MSSQL* -computername $c  -ErrorAction SilentlyContinue
			$SSAS = Get-Service -Name *MSOLAP* -computername $c  -ErrorAction SilentlyContinue
			$SSIS = Get-Service -Name *MSDtsServer* -computername $c  -ErrorAction SilentlyContinue
			$SSRS = Get-Service -Name *ReportServer* -computername $c  -ErrorAction SilentlyContinue
				if ($MSSQL.Length -gt 0) {$MSSQL = "True"} else {$MSSQL = "False"}
				if ($SSAS.Length -gt 0) {$SSAS = "True"} else {$SSAS = "False"}
				if ($SSIS.Length -gt 0) {$SSIS = "True"} else {$SSIS = "False"}
				if ($SSRS.Length -gt 0) {$SSRS = "True"} else {$SSRS = "False"}

			#Create info from all parameters
			$reportinfo = New-Object psobject
			$reportinfo | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerSystem.Name
			$reportinfo | Add-Member -MemberType NoteProperty -Name MSSQL -Value $MSSQL
			$reportinfo | Add-Member -MemberType NoteProperty -Name SSAS -Value $SSAS
			$reportinfo | Add-Member -MemberType NoteProperty -Name SSIS -Value $SSIS
			$reportinfo | Add-Member -MemberType NoteProperty -Name SSRS -Value $SSRS
			
			#Create report array
			$report += $reportinfo
		} 
	}
	else {
		 Write-Host ""$c": Server doesn't seem to be online" -Foregroundcolor Red
		 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - Ping request timed out"
		 Add-Content -Path $ErrorLog "**********************************************************************************"
		 Add-Content -Path $ErrorLog " $Err" 
		 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
	}
}
If ($report){
	#Write and export report to CSV
	$report | export-csv -Path "$BasePath" -NoTypeInformation -delimiter ";"
	
	#Convert CSV for import to SQL database
	(Get-Content $BasePath) | foreach {$_ -replace '"'} | Set-Content $BasePath
	(Get-Content $BasePath) | foreach {$_ -replace ',',"."} | Set-Content $BasePath	
}


