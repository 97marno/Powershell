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
	$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('DiskInventory - ' + (Get-Date -Format 'yyyy-MM-dd-HH-mm') + '.csv'))
	,
	[Parameter(Mandatory=$false)] 
	[ValidateNotNullOrEmpty()]
	[string]
	$Inputfile = ""
)

If ($Inputfile.length -gt 0) {
	$ComputerName = Get-Content $Inputfile | ForEach-Object {$_ }
}

$ID = ""
$date =  get-date -format 'yyyy-MM-dd HH:mm'
$ErrorLog = ".\error_disk.log"
$Decomissioned = 0
$report = @()
$disk = @()


Foreach ($c in $ComputerName){
	if(Test-Connection -ComputerName $c -Count 1 -ea 0 -ev Err){
		$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
		if ($Err){Write-Host ""$c": Can't connect to server via WMI" -Foregroundcolor Red
				 Add-Content -Path $ErrorLog "$$date $env:UserName ERROR: $c - WMI connection unavailable"
				 Add-Content -Path $ErrorLog "**********************************************************************************"
				 Add-Content -Path $ErrorLog " $Err" 
				 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
		}
		Else 
		{			
			$disk = Get-WmiObject  Win32_Volume -filter "DriveType=3" -ComputerName $c | select -property id, date, __SERVER, Name, Label, @{Name="Capacity(GB)";Expression={"{0:N1}" -f (($_.Capacity/1GB),2)}},
			@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f (($_.FreeSpace/1GB),2)}}, @{Name="ProcentFree(%)";Expression={"{0:N1}" -f ((($_.FreeSpace/$_.Capacity)*100),2)}}, Decomissioned
			
			$report += $disk
		}
	}
	else {
		 Write-Host ""$c": Testing connection to computer failed" -Foregroundcolor Red
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