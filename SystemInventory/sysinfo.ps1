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
	$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('WindowsInventory - ' + (Get-Date -Format 'yyyy-MM-dd-HHmm') + '.csv'))
	,
	[Parameter(Mandatory=$false)] 
	[ValidateNotNullOrEmpty()]
	[string]
	$Inputfile = ""
)

If ($Inputfile.length -gt 0) {
	$ComputerName = Get-Content $Inputfile | ForEach-Object {$_ }
}
$ErrorActionPreference = 'SilentlyContinue'  
$ID =""
$date =  get-date -format 'yyyy-MM-dd HH:mm'
$ErrorLog = ".\error_sys.log"
$Decomissioned = 0
$report = @()

Foreach ($c in $ComputerName){
	if(Test-Connection -ComputerName $c -Count 1 -ea 0 -ev Err){ 
		$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
		if ($Err){Write-Host ""$c": Can't connect to server via WMI" -Foregroundcolor Red
				 Add-Content -Path $ErrorLog "$date $env:UserName ERROR: $c - WMI connection unavailable"
				 Add-Content -Path $ErrorLog "**********************************************************************************"
				 Add-Content -Path $ErrorLog " $Err" 
				 Add-Content -Path $ErrorLog " `r" # `r means new carrige return
		}
		Else 
		{
			$ExportDate = $((get-date).ToString("yyyy-MM-dd"))
			$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c | Select -Property Name, Domain, Model, Manufacturer, @{Name="Memory(GB)";Expression={"{0:N1}" -f ($_.TotalPhysicalMemory/1GB)}} 
			#$Installdate = ([WMI] "").ConvertToDateTime((Get-WmiObject Win32_OperatingSystem -ComputerName $c).InstallDate)
			$OS = Get-WmiObject -Class Win32_OperatingSystem
			$OSdate = $OS.ConvertToDateTime($OS.InstallDate)
			
			$BIOS = Get-WmiObject -Class Win32_BIOS -ComputerName $c | Select -Property SerialNumber
			$OS = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $c | Select -Property Caption , CSDVersion , OSArchitecture , OSLanguage
			$CPU = Get-WmiObject -Class win32_processor -ComputerName $c | select -property DeviceID, Numberofcores, NumberofLogicalProcessors

			#Create info from all parameters
			$reportinfo = New-Object psobject
			$reportinfo | Add-Member -MemberType NoteProperty -name ID -Value $ID
			$reportinfo | Add-Member -MemberType NoteProperty -name ExportDate -Value $ExportDate
			
			$reportinfo | Add-Member -MemberType NoteProperty -name ComputerName -Value $ComputerSystem.Name
			$reportinfo | Add-Member -MemberType NoteProperty -name Domain -Value $ComputerSystem.Domain
			$reportinfo | Add-Member -MemberType NoteProperty -name Decomissioned -Value $Decomissioned
			$reportinfo | Add-Member -MemberType NoteProperty -name Model -Value $ComputerSystem.Model
			$reportinfo | Add-Member -MemberType NoteProperty -name Manufacturer -Value $ComputerSystem.Manufacturer

			$reportinfo | Add-Member -MemberType NoteProperty -name InstallDate -Value $osdate.tostring("yyyy-MM-dd")

			$reportinfo | Add-Member -MemberType NoteProperty -name SerialNumber -Value $BIOS.SerialNumber

			$reportinfo | Add-Member -MemberType NoteProperty -name OperatingSystem -Value $OS.Caption
			$reportinfo | Add-Member -MemberType NoteProperty -name ServicePack -Value $OS.CSDVersion
			$reportinfo | Add-Member -MemberType NoteProperty -name OSArchitecture -Value $OS.OSArchitecture
			$reportinfo | Add-Member -MemberType NoteProperty -name OSLanguage -Value $OS.OSLanguage

			$reportinfo | Add-Member -MemberType NoteProperty -name InstalledMemory -Value $ComputerSystem."Memory(GB)"
			
			$reportinfo | Add-Member -MemberType NoteProperty -name CPUID -Value ($CPU.DeviceID -join "/")
			$reportinfo | Add-Member -MemberType NoteProperty -name CPULogical -Value ($CPU.NumberofLogicalProcessors -join "/")
			$reportinfo | Add-Member -MemberType NoteProperty -name CPUcores -Value ($CPU.Numberofcores -join "/")
			
			#Create report array
			$report += $reportinfo
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


