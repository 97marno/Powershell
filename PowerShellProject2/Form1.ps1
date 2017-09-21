cls
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

		PS C:\> .\Form1.ps1
		
		Description
		-------------
		
		
	.OUTPUTS
		

#>

# -------------------- PARAMETERS -------------------- 

$creds = Get-Credential #Get credentials that have permissions to the share where all isos and scripts reside.
$installog = "$PSScriptRoot\SQLinstallationlog_$($ENV:COMPUTERNAME).txt" #Path where to put the installation log file for installation. (Default = script root) 
$logfile = "$PSScriptRoot\ConfigurationFile.ini" #Path where to put configuration file for installation. (Default = script root) 
$pwfile = "$PSScriptRoot\$($env:computername)_$($instance)_passwords.txt" #Path where to put password file for inport in password safe. (Default = script root) 
$ico = "" #c:\temp\Temperature-1.ico" #Program icon in form, if not set, default icon is used

$isopathstd = "C:\temp\en_sql_server_2016_standard_with_service_pack_1_x64_dvd_9540929.iso" #Path where Standard Edition of SQL installation iso reside
$isopathent = "\\corpnet\data\IT_Media\ISO Files Database\SQL Server\SQL Server 2016\en_sql_server_2016_enterprise_with_service_pack_1_x64_dvd_9542382.iso" #Path where Enterprise Edition of SQL installation iso reside
$isopathdev = "\\corpnet\data\IT_Media\ISO Files Database\SQL Server\SQL Server 2016\en_sql_server_2016_developer_with_service_pack_1_x64_dvd_9548071.iso" #Path where Development Edition of SQL installation iso reside

$templocation = "$($env:systemdrive)\temp"
$sqlscriptpath = "\\corpnet\data\IT_Media\ISO Files Database\SQL Server\AutomatedInstall" #Path where SQL script configurations reside

$sqlpathed = "MSSQL13"

#Collations that are available in dropbox
$collations=@("SQL_Scandinavian_CP850_CI_AS","Finnish_Swedish_CI_AS","SQL_Latin1_General_CP1_CI-AS","SQL_Latin1_General_CP1_CI_AS","Latin1_General_CI_AS","Finnish_Swedish_CS_AS","Latin1_General_100_CI_AS") 



# -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE --------------------

# -------------------- FUNCTIONS --------------------
#Function to generate random password.
Function GET-Temppassword() {
	Param(
	[int]$length=10,
	[string[]]$sourcedata
	)
	For ($loop=1; $loop –le $length; $loop++) {
		$TempPassword+=($sourcedata | GET-RANDOM)
	}
	return $TempPassword
}

# -------------------- SCRIPT -------------------- 

$drives = Get-WmiObject Win32_Volume |Where { $_.drivetype -eq '3' -and $_.driveletter} |select -property name , @{name="capacity";Expression={"{0:n1}" -f (($_.capacity/1gb),2)}} |Sort-Object -property name #Get all disk drives on local computer

#$ascii=$NULL;For ($a=33;$a –le 126;$a++) {$ascii+=,[char][byte]$a } #Returns all ascii characters from 33-126
$a=$NULL;For ($z=48;$z –le 57;$z++) {$a+=,[char][byte]$z } # 0-9
$b=$NULL;For ($z=63;$z –le 90;$z++) {$b+=,[char][byte]$z } #a-z
$c=$NULL;For ($z=97;$z –le 122;$z++) {$c+=,[char][byte]$z } #?@A-Z
$ascii =$a + $b + $c

$SvcAccpwd = GET-Temppassword –length 15 –sourcedata $ascii 
$svcsapwd = GET-Temppassword –length 15 –sourcedata $ascii



. (Join-Path $PSScriptRoot 'Form1.designer.ps1')

$dialogResult = $MainForm.ShowDialog()


if ($dialogResult -eq [System.Windows.Forms.DialogResult]::OK)
{
	# -------------------- WRITE CONFIGURATION FILE --------------------
	. (Join-Path $PSScriptRoot 'logfile.ps1')

	# -------------------- START INSTALLATION --------------------
	. (Join-Path $PSScriptRoot 'installation.ps1')

	# -------------------- SECPOL CONFIGURATION --------------------
	. (Join-Path $PSScriptRoot 'secpolIFI.ps1')
	
	# -------------------- SQL CONFIGURATION --------------------
	. (Join-Path $PSScriptRoot 'sqlconfig.ps1')

	# -------------------- WINDOWS CONFIGURATION --------------------
	. (Join-Path $PSScriptRoot 'windowsconfig.ps1')
}