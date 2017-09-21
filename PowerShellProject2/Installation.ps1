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
		Script that create new service account and adds it to local group. 

	.DESCRIPTION
		

	.EXAMPLE

		PS C:\> .\Form1.ps1
		
		Description
		-------------
		
		
	.OUTPUTS
		

#>

Write-Output "`r`n# -------------------- INSTALLATION -------------------- " | out-File -append -filepath $installog
# Control Windows version and control Windows features
If ((Get-WMIObject Win32_OperatingSystem).Version -ge '6.1'){ #Windows 2008 R2 or above
    Import-Module ServerManager
	# Check .NET and install if not available
	$NETCore = (Get-WindowsFeature NET-Framework-Core).Installed
	$NET45Core = (Get-WindowsFeature NET-Framework-45-Core).Installed
	If ($NET45Core -eq $true){ #$NETCore -and
		Write-output ".NET is properly installed" | out-File -append -filepath $installog
	}
	else{
		<#If ($NETCore -eq $false){
			Install-WindowsFeature NET-Framework-Core
			Write-Host "Installing .NET Framework Core"
		}#>
		If ($NET45Core -eq $false){
			Install-WindowsFeature NET-Framework-45-Core
			Write-Host "Installing .NET Framework 4.5 Core"
			Write-Output "Installing .NET Framework 4.5 Core" | out-File -append -filepath $installog
		}
	}

# Copy and mount the ISO
	# Check if the target folder exist if not create it 
	If (!(Test-Path $templocation)) {
		New-Item -Path $templocation -ItemType Directory
	}
	# Copy iso and mount
	Copy-Item -Path $isopath -Destination $templocation\sql.iso
	$isopath = "$($templocation)\sql.iso"
	$setupDriveLetter = (Mount-DiskImage -ImagePath $isopath -PassThru | Get-Volume).DriveLetter + ":"
	if ($setupDriveLetter -eq $null) {
		throw "Could not mount SQL install iso" | out-File -append -filepath $installog
	}
	Write-Host "Drive letter for iso is: $setupDriveLetter"
                 
	# Run the installer using the ini file
	$cmd = "$setupDriveLetter\Setup.exe /ConfigurationFile=c:\temp\ConfigurationFile.ini /SAPWD=`"$svcsapwd`""
	Write-Host "Running SQL Install - check %programfiles%\Microsoft SQL Server\130\Setup Bootstrap\Log\ for logs..."
	Write-output "Running SQL Install - check %programfiles%\Microsoft SQL Server\130\Setup Bootstrap\Log\ for logs..." | out-File -append -filepath $installog
	Invoke-Expression $cmd | Write-Host

	# Dismount the iso
	Dismount-DiskImage -ImagePath $isopath
	Remove-Item "$($templocation)\sql.iso"

}
Else { Write-Output "Windows version is lower than Windows 2008 R2. Please upgrade."  | out-File -append -filepath $installog}