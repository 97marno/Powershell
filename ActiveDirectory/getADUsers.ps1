<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		Inventory of Active Directory users with or wothout Department numbers. 

	.DESCRIPTION
		This script document GivenName, SurName, Mobile and DepartmentNumber 
		in an Excel sheet and mail it to specified user
		To get a fulll scale Excel-report, ImportExcel Module must be installed. 
		(Install-Module ImportExcel in adminitrative PS 5.0 terminal)

	.EXAMPLE
	.\getADUsers.ps1

=======================================================================================================================#>

#Set directory path (default is in the same folder as the script reside)
$DirectoryPath = ".\"
#Set file name for the report (default Users-yyy-MM-dd.csv)
$FileXls = ('Users - ' + (Get-Date -Format 'yyyy-MM-dd') + '.xlsx')
$FileCsv = ('Users - ' + (Get-Date -Format 'yyyy-MM-dd') + '.csv')

#Set variables to mail the report
$From = "noreply@teracom.se"
$To= "marlen.norling@teracom.se"
#$CC = "helpdesk@company.com"
$subject = "MobilityLINK - Update"
$SMTPServer = "SMTP-internal.corpnet.teracom.se"

# ======================================DO NOT EDIT AFTER LINE======================================
Import-Module ActiveDirectory

$report = @()
#$BasePath = (Join-Path -Path $DirectoryPath -ChildPath $FileName)
$date = Get-Date -Format 'yyyy-MM-dd'

#Active AD users with Department number
Write-Host "Active AD users with Department number"
$user = Get-ADUser -filter * -Property *| Where {$_.Enabled -eq $true -and $_.departmentnumber -notlike $null -and ($_.extensionAttribute2 -like "TeracomUser" -or $_.extensionAttribute2 -like "NoTeracomUser")} | select givenname, surname, mobile, @{Name="departmentnumber";Expression={$_.departmentnumber[0]}}
$report += $user

#Active users without department number in the User OUs
Write-Host "Active users without department number in the User OUs"
$UsersNoDepNr = Get-ADOrganizationalUnit -Filter "Name -eq 'Users'"

ForEach($ou in $UsersNoDepNr){
	$user = Get-ADUser -LDAPFilter "(!departmentnumber=*)" -Property * -SearchBase $ou| Where {$_.Enabled -eq $true -and $_.extensionAttribute2 -like "TeracomUser"}| select givenname, surname, mobile, @{Name="departmentnumber";Expression={$_.departmentnumber[0]}}
	$report += $user
}

#Active AD users without department number in the External users OUs
Write-Host "Active AD users without department number in the External users OUs"
$UsersExtNoDepNr = Get-ADOrganizationalUnit -Filter "Name -eq 'External-Users'" 

ForEach($Exs in $UsersExtNoDepNr){
	$user = Get-ADUser -LDAPFilter "(!departmentnumber=*)" -Properties * -SearchBase $Exs| Where {$_.Enabled -eq $true -and $_.extensionAttribute2 -like "TeracomUser"}| select givenname, surname, mobile, @{Name="departmentnumber";Expression={$_.departmentnumber[0]}}
	$report += $user
}

If ($report){
	#Control i ImportExcel Moule is installed and write an report to Excel
	if(get-module ImportExcel) {
		$BasePath = (Join-Path -Path $DirectoryPath -ChildPath $FileXls)
		$report | export-excel $BasePath
	}
	#If ImportExcel module isn't installed, write CSV file
	else {
		$BasePath = (Join-Path -Path $DirectoryPath -ChildPath $FileCsv)
		$report | export-csv -Path "$BasePath" -NoTypeInformation -delimiter ";" -encoding UTF8
			
		#Convert CSV
		#(Get-Content $BasePath) | foreach {$_ -replace '"'} | Set-Content $BasePath
		#(Get-Content $BasePath) | foreach {$_ -replace ',',"."} | Set-Content $BasePath
	}

}

If($BasePath){
	Send-MailMessage -To $To -From $From -Subject $subject -SmtpServer $SMTPServer -Body "En uppdatering $date" -Attachments $BasePath
}