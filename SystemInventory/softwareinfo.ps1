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
	$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('SoftwareInventory - ' + (Get-Date -Format 'yyyy-MM-dd-HHmm') + '.csv'))
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
$ErrorLog = ".\error_sw.log"
$Decomissioned = 0
$report = @()

foreach ($c in $ComputerName) {
	if(Test-Connection -ComputerName $c -Count 1 -ea 0 -ev Err) {
	$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
		if ($Err){Write-Host ""$c": Can't connect to server via WMI" -Foregroundcolor Red
				 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - WMI connection unavailable"
				 Add-Content -Path $ErrorLog "**********************************************************************************"
				 Add-Content -Path $ErrorLog " $Err" 
				 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
		}
		Else 
		{
			$sw = Get-WmiObject -Class Win32_Product -ComputerName $c -ErrorAction SilentlyContinue|Select Name , Vendor , Version
			foreach ($s in $sw) {
				$reportinfo = New-Object -Type PSObject
				$reportinfo | Add-Member -MemberType NoteProperty -name ID -Value $ID
				$reportinfo | Add-Member -MemberType NoteProperty -name ModifyDate -Value $Date
				$reportinfo | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerSystem.Name
				$reportinfo | Add-Member -MemberType NoteProperty -Name Name -Value $s.Name
				$reportinfo | Add-Member -MemberType NoteProperty -Name Vendor -Value $s.Vendor
				$reportinfo | Add-Member -MemberType NoteProperty -Name Version -Value $s.Version
				$reportinfo | Add-Member -MemberType NoteProperty -name Decomissioned -Value $Decomissioned
				
				#Create report array
				$report += $reportinfo
			}
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

if	($report){
#Write and export report to CSV
$report | export-csv -Path "$BasePath" -NoTypeInformation -delimiter ";" -encoding UTF8

#Convert CSV for import to SQL database
(Get-Content $BasePath) | foreach {$_ -replace '"'} | Set-Content $BasePath
(Get-Content $BasePath) | foreach {$_ -replace ',',"."} | Set-Content $BasePath
}