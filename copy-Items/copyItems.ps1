<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		Script that move/copy files using PowerShell.

	.DESCRIPTION
		This script is to copy/move files older than specified dates in specified folders. 
		
	
	.USAGE
		1) Create an secure string for password. This is done one time or when password is updated.
			Start powershell on computer that will have the script running and write following string: 
			read-host -assecurestring | convertfrom-securestring | out-file C:\mysecurestring.txt [ENTER] 
			%PASSWORD% [ENTER]
		2) Edit script with correct parameters. (username, share, datespans, logfile path, share path etc.)
		3) Run script
			
	.EXAMPLE
		PS C:\> .\copyItems.ps1 

		
	.OUTPUTS
		Logfile: 
			# -------------------- LOG FILE 2017-09-20 -------------------- 

			# -------------------- sharedrive:\ -------------------- 
			\\$SHARE\$SUBFOLDER\$SUBFOLDER1\file.extension
			\\$SHARE\$SUBFOLDER\$SUBFOLDER1\file.extension
#>

# -------------------- PARAMETERS -------------------- 

$username = "corpnet\e-mnorling"												#specify username
$password = cat "C:\temp\mysecurestring.txt" | convertto-securestring			#specify file where secure password is stored

$share = ""																		#specify UNC share path. If this is empty, must $sourcefolder be filled in
$sharename ="sharedrive" 														#specify human name for share
$SourceFolder = "c:\work\backup"												#Specify local path. If this is filled in, $share must be empty
$ArchiveFolder = "C:\temp\backup"												#Specify archive location 
#$IncludeFiles = ("*.vb","*.cs","*.aspx","*.js","*.css")						#If special extension conditions. (need to include "-Include $IncludeFiles" in Get-ChildItem statement at line 65)

$modified = (Get-Date).AddDays(-6)												#specify modified date (from todays date) 
$created = (Get-Date).AddDays(-6)												#specify created date (from todays date)

$logfile = "C:\temp\logfile.txt"												#log file path

# -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE --------------------

#read-host -assecurestring | convertfrom-securestring | out-file C:\temp\mysecurestring.txt	#To create secure string with password

$ErrorActionPreference = 'SilentlyContinue'  

Write-Output "`r`n# -------------------- LOG FILE $date -------------------- " | out-File -filepath $logfile

if($share -ne ""){
    write-host $share
    $cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password
    New-PSDrive -Name $sharename -PSProvider "FileSystem" -Root $share -credential $cred #Connect to the specified path and credentials
    $SourceFolder = $sharename + ':\'
}

Write-Output "`r`n# -------------------- $SourceFolder -------------------- " | out-File -append -filepath $logfile
Get-ChildItem $SourceFolder -Recurse | where-object {$_.creationtime -lt $created -and $_.LastWriteTime -lt $modified}| ForEach-Object {
    $PathArray = $_.FullName.Replace($SourceFolder,"").ToString().Split('\') 

    $Folder = $ArchiveFolder

    for ($i=1; $i -lt $PathArray.length-1; $i++) {
        $Folder += "\" + $PathArray[$i]
        if (!(Test-Path $Folder)) {
            New-Item -ItemType directory -Path $Folder
        }
    }   
    $NewPath = Join-Path $ArchiveFolder $_.FullName.Replace($SourceFolder,"")

    Copy-Item $_.FullName -Destination $NewPath
	If(Test-path "$NewPath\*" -include $_.Name) {Remove-item $_.Name | Out-File -append $logfile}
   
    $date = (get-date -format "yyyy-MM-dd")
    
    Write-Output $_.Fullname | out-File -append -filepath $logfile
}


Remove-PSDrive $sharename