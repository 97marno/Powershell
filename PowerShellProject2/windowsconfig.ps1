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

		PS C:\> .\windowsconfig.ps1
		
		Description
		-------------
		
		
	.OUTPUTS
		

#>

# -------------------- PARAMETERS -------------------- 




# -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE --------------------
Write-Output "`r`n# -------------------- LOCAL FIREWALL CONFIGURATION -------------------- " | out-File -append -filepath $installog
if (-Not (Get-NetFirewallRule -displayname "SQL Server (TCP 1433-1434)")) {
		netsh advfirewall firewall add rule name="SQL Server (TCP 1433-1434)" dir=in action=allow profile=any protocol=TCP localport=1433-1434
		netsh advfirewall firewall add rule name="SQL Server (UDP 1434)" dir=in action=allow profile=any protocol=UDP localport=1434
		
		Write-Output "Firewall rules created" | out-File -append -filepath $installog
	} 
	else {
		
		Write-Output "Firewall rules already created" | out-File -append -filepath $installog
	}

