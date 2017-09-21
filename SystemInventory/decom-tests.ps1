<#
	.SYNOPSIS
		(C) MarlÃ©n Norling 2017. marlen@norling.cx
		Windows Machine Inventory Using PowerShell.

	.DESCRIPTION
		
		
	.EXAMPLE


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
Import-Module ActiveDirectory

If ($Inputfile.length -gt 0) {
	$ComputerName = Get-Content $Inputfile | ForEach-Object {$_ }
}

$ID = ""
$date =  get-date -format 'yyyy-MM-dd HH:mm'
$ErrorLog = ".\error_disk.log"
$Decomissioned = 0
$report = @()
$disk = @()

Write-host "Testing connection to computer(s)"
Foreach ($c in $ComputerName){
		if(Test-Connection -computername $c -count 1 -ea 0 -ev Err){}
		else {Write-Host ""$c": The requested name is valid, but no data of the requested type was found" -Foregroundcolor Red}
		
}

write-host "Resove DNS name"
Foreach ($c in $ComputerName){	
        #$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
		if (Resolve-DnsName $C -ea 0 -ev Err){}
		else{Write-Host ""$C": "$Err " `r" -Foregroundcolor Red}
}


Foreach ($c in $ComputerName){	
		Get-ADComputer -Filter '(DNSHostName -like $c -or Name -like $c)' | select DistinguishedName -ea 0 -ev Err
			
}





<#
		


If ($report){
	#Write and export report to CSV
	$report | export-csv -Path "$BasePath" -NoTypeInformation -delimiter ";" -encoding UTF8

	#Convert CSV for import to SQL database
	(Get-Content $BasePath) | foreach {$_ -replace '"'} | Set-Content $BasePath
	(Get-Content $BasePath) | foreach {$_ -replace ',',"."} | Set-Content $BasePath
}
#>
