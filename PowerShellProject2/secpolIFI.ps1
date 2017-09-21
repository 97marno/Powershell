# -------------------- INFORMATION --------------------  INFORMATION --------------------  INFORMATION -------------------- 
<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		Script that add account to be able to "Perform Volume Maintenance Task" in local server. 

	.DESCRIPTION
		Script used for SQL server so SQL service account can perform volume manintancence task. 
		Whenever SQL Server needs to allocate space for certain operations like creating/restoring a database or growing 
		data/log files, SQL Server first fills the space it needs with zeros. In many cases, writing zeros across the 
		disk space before using that space is unnecessary.

		Instant file initialization (IFI) allows SQL Server to skip the zero-writing step and begin using the allocated 
		space immediately for data files. It doesn’t impact growths of your transaction log files, those still need all 
		the zeroes. 
		
		READ MORE:	https://www.brentozar.com/blitz/instant-file-initialization/
					https://www.brentozar.com/archive/2013/07/will-instant-file-initialization-really-help-my-databases/

	.EXAMPLE

		PS C:\> .\secpolIFI.ps1
		
		Description
		-------------
		
		
	.OUTPUTS
		

#>
# -------------------- PARAMETERS --------------------
$accountToAdd = $SvcAccStr




# -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE --------------------
$sidstr = $null

Write-Output "`r`n# -------------------- SECPOL IFI CONFIGURATION -------------------- " | out-File -append -filepath $installog

try {
       $ntprincipal = new-object System.Security.Principal.NTAccount "$accountToAdd"
       $sid = $ntprincipal.Translate([System.Security.Principal.SecurityIdentifier])
       $sidstr = $sid.Value.ToString()
} catch {
       $sidstr = $null
}
Write-host "Account: $($accountToAdd)" -ForegroundColor DarkCyan
Write-output "Account: $($accountToAdd)" | out-File -append -filepath $installog
if( [string]::IsNullOrEmpty($sidstr) ) {
	   Write-host "Account not found!" -ForegroundColor Red 
       Write-output "Account not found!" | out-File -append -filepath $installog
       #exit -1
}

Write-host "Account SID: $($sidstr)" -ForegroundColor DarkCyan 
Write-output "Account SID: $($sidstr)" | out-File -append -filepath $installog
$tmp = ""
$tmp = [System.IO.Path]::GetTempFileName()
Write-host "Export current Local Security Policy" -ForegroundColor DarkCyan
Write-output "Export current Local Security Policy" | out-File -append -filepath $installog
secedit.exe /export /cfg "$($tmp)" 
$c = ""
$c = Get-Content -Path $tmp
$currentSetting = ""
foreach($s in $c) {
       if( $s -like "SeManageVolumePrivilege*") {
             $x = $s.split("=",[System.StringSplitOptions]::RemoveEmptyEntries)
             $currentSetting = $x[1].Trim()
       }
}


if( $currentSetting -notlike "*$($sidstr)*" ) {
	   Write-host "Modify Setting ""Perform Volume Maintenance Task""" -ForegroundColor DarkCyan
       Write-output "Modify Setting ""Perform Volume Maintenance Task""" | out-File -append -filepath $installog
       
       if( [string]::IsNullOrEmpty($currentSetting) ) {
             $currentSetting = "*$($sidstr)"
       } else {
             $currentSetting = "*$($sidstr),$($currentSetting)"
       }
       
	   Write-host "$currentSetting"
       Write-output "$currentSetting" | out-File -append -filepath $installog
       
       $outfile = @"
[Unicode]
Unicode=yes
[Version]
signature="`$CHICAGO`$"
Revision=1
[Privilege Rights]
SeManageVolumePrivilege = $($currentSetting)
"@
       
       $tmp2 = ""
       $tmp2 = [System.IO.Path]::GetTempFileName()
       
       Write-host "Import new settings to Local Security Policy" -ForegroundColor DarkCyan
       Write-Output "Import new settings to Local Security Policy" | out-File -append -filepath $installog
       $outfile | Set-Content -Path $tmp2 -Encoding Unicode -Force
       #notepad.exe $tmp2
       Push-Location (Split-Path $tmp2)
       
       try {
             secedit.exe /configure /db "secedit.sdb" /cfg "$($tmp2)" /areas USER_RIGHTS 
             #write-host "secedit.exe /configure /db ""secedit.sdb"" /cfg ""$($tmp2)"" /areas USER_RIGHTS "
       } finally {  
             Pop-Location
       }
} else {
	   Write-host "NO ACTIONS REQUIRED! Account already in ""Perform Volume Maintenance Task""" -ForegroundColor DarkCyan
       Write-Output "NO ACTIONS REQUIRED! Account already in ""Perform Volume Maintenance Task""" | out-File -append -filepath $installog
}
Write-host "Done." -ForegroundColor DarkCyan
Write-Output "Done." | out-File -append -filepath $installog