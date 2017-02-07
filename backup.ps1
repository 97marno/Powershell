
# =========================================================================================================
# (C) Marlen Norling 2017-01-05 marlen.norling@rtsab.com
# This script does the following
# ¤ Copy all files in the source path to the target path. (to avoid that files are locked when trying to compress them)
# ¤ Create an archive file from the target path and send it to the destination directory
# ¤ 
# ¤ 
# ¤ 
# =========================================================================================================

# Parameters
# =========================================================================================================

$counter = 1														# Parameter to use when counting files
$parmdate = get-date -format yyMMdd									# Todays date in the format yyMMdd
$limit = (Get-Date).AddDays(0)										# How many days the script will save files on destination disk ($destinationpath)
$logfile2 = "connection_log.txt"
$logfile = "c:\temp\connection_log.txt"
$parmSourceDir = "C:\powershell"									# The source path where the files are
$parmTargetDir = "C:\temp\" + $parmdate								# The target directory where the source files will be copied (local disk)
$archivepath = "C:\temp"											# The target directory for the archive file
$destinationpath = "\\killerrabbit\Users\marlen\Intel\"				# The destination path for the archive file
$zipname = $parmdate + "_datafiles_" + $env:computername + ".zip"	# Name of archvie file (todays date + common name + computername + extension)
$archivefile = Join-Path -Path $archivepath -ChildPath $zipname 	# Parameter that joins the archive path and archive name in one string


# =========================== DO NOT CHANGE AFTER THIS LINE ================================================


# Count files in source folder
Write-Output("***Counting files and folders in " + $parmSourceDir + " ***") | Out-File $logfile
(Get-ChildItem $parmSourceDir -recurse).count | Out-File -append $logfile		#filter with -filter *.doc

# Check if the target folder exist if not create it 
Write-Output ("")  | Out-File -append $logfile
Write-Output ("***Creating " + $parmTargetDir + " ***")  | Out-File -append $logfile
If (!(Test-Path $parmTargetDir)) {
 
	New-Item -Path $parmTargetDir -ItemType Directory | Out-File -append $logfile
	Write-Output ("Target directory created")  | Out-File -append $logfile
}
 
else {
   
   Write-Output "Directory already exists!"  | Out-File -append $logfile
 
}

# Copy all source files to target directory
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Copying files to " + $parmTargetDir) | Out-File -append $logfile
Write-Output ("Copying files") | Out-File -append $logfile
copy-item $parmSourceDir $parmTargetDir -recurse -force -errorAction SilentlyContinue -errorVariable errors
foreach($error in $errors)
	{
		write-output ("Error: An error occured during copy operation") | Out-File -append $logfile
		write-output ("	Exception: " + $error[0].exception.message) | Out-File -append $logfile
	}	

# Count files in target folder
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Counting files and folders in " + $parmTargetDir + " ***") 	 | Out-File -append $logfile
ls $parmTargetDir -recurse | Out-File -append $logfile	
(Get-ChildItem $parmTargetDir -recurse).count | Out-File -append $logfile		#filter with -filter *.doc	


# Add folder to zip 
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Creating archive file " + $archivefile +" from " + $parmTargetDir) | Out-File -append $logfile
If(Test-path $ArchiveFile) {Remove-item $ArchiveFile | Out-File -append $logfile}
Add-Type -assembly "system.io.compression.filesystem"
[io.compression.zipfile]::CreateFromDirectory($parmTargetDir, $ArchiveFile) 
If(Test-path $ArchiveFile) 
	{
		Write-output ($ArchiveFile + " created") | Out-File -append $logfile
	}
else{
	Write-output ("Error: An error occured during operation to create " + $ArchiveFile) | Out-File -append $logfile
	}

# Copy archive to destination path
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Copying archive file " + $archivefile + " to " + $destinationpath) | Out-File -append $logfile

$counter = 1
$files = Get-ChildItem $archivepath -force -filter *.zip
foreach($file in $files)
	{	
		$status = "Copying file {0} of {1}: {2}" -f $counter, $files.count, $file.name
		Write-Output ($status) | Out-File -append $logfile
		copy-item $file.pspath $destinationpath -recurse -Force -errorAction SilentlyContinue -errorVariable errors
		$counter++	
		
		foreach($error in $errors)
		{
			{	
				write-output ("	Exception: " + $error[0].exception.message) | Out-File -append $logfile
				write-output ("Error: An error occured during copy operation.") | Out-File -append $logfile
			}
		}
	}

# Count files in destination folder
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Counting files and folders in " + $destinationpath + " ***") 	 | Out-File -append $logfile
(Get-ChildItem $destinationpath -filter *.zip) | Out-File -append $logfile
Write-Output ("Total amout of files: " + (Get-ChildItem $destinationpath -filter *.zip).count) | Out-File -append $logfile

# Cleanup old files on disk and destiation path 
# Delete files older than the $limit in the target directory.
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Deleting files and folders in " + $archivepath + " ***") 	 | Out-File -append $logfile
$counter = 1
$files = Get-ChildItem -Path $archivepath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit -and $_.name -ne $logfile2} 
if ($files -ne $null)
	{
		foreach($file in $files)
			{	
				$status = "Deleteing file {0} of {1}: {2}" -f $counter, $files.count, $file.name
				Write-Output ($status) | Out-File -append $logfile
				Remove-item $File.pspath -recurse -Force -errorAction SilentlyContinue -errorVariable errors
				$counter++	
				
				foreach($error in $errors)
				{
					{	
						write-output ("	Exception: " + $error[0].exception.message) | Out-File -append $logfile
						write-output ("Error: An error occured during copy operation.") | Out-File -append $logfile
					}
				}
			}
			
	}
else {write-output ("No more files to delete") | Out-File -append $logfile}	

# Delete any empty directories left behind after deleting the old files.
Get-ChildItem -Path $archivepath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

# Delete files older than the $limit in the destination directory.
Write-Output ("") | Out-File -append $logfile
Write-Output ("***Deleting files and folders in " + $destinationpath + " ***") 	 | Out-File -append $logfile
$counter = 1
$files = Get-ChildItem -Path $destinationpath -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit -and $_.name -ne $logfile2} 
if ($files -ne $null)
	{
		foreach($file in $files)
			{	
				$status = "Deleteing file {0} of {1}: {2}" -f $counter, $files.count, $file.name
				Write-Output ($status) | Out-File -append $logfile
				Remove-item $File.pspath -recurse -Force -errorAction SilentlyContinue -errorVariable errors
				$counter++	
				
				foreach($error in $errors)
				{
					{	
						write-output ("	Exception: " + $error[0].exception.message) | Out-File -append $logfile
						write-output ("Error: An error occured during copy operation.") | Out-File -append $logfile
					}
				}
			}
			
	}
else {write-output ("No more files to delete") | Out-File -append $logfile}	

#############################
#
#	Send-MailMessage -To email.com `
#	-From senders `
#	-Subject "Backup" `
#	-attachment c:\logs\copyLog.txt `
#	-Body "The Bakup is finished. to see data backup, please check path!" `
#	-SmtpServer mail4.creditriskmonitor.com
#	get-childitem c:\path -recurse | where {$_.lastwritetime -lt (get-date).adddays(-2) -and -not $_.psiscontainer} |% {remove-item $_.fullname -force}
#	get-childitem c:\path -recurse | where {$_.lastwritetime -lt (get-date).adddays(-2) -and -not $_.psiscontainer} |% {remove-item $_.fullname -force}
#	get-childitem \\desk77\c$\eCASBackup -recurse | where {$_.lastwritetime -lt (get-date).adddays(-2) -and -not $_.psiscontainer} |% {remove-item $_.fullname -force}
#	Send-MailMessage -To email.com `
#	-From email.com `
#	-Subject "old back deleted" `
#	-Body "eCASBackup old back deleted" `
#	-SmtpServer domain

