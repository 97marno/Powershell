
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
	$BasePath = (Join-Path -Path $DirectoryPath -ChildPath ('computers.csv'))
	,
	[Parameter(Mandatory=$false)] 
	[ValidateNotNullOrEmpty()]
	[string]
	$Inputfile = ""
)

If ($Inputfile.length -gt 0) {
	$ComputerName = Get-Content $Inputfile | ForEach-Object {$_ }
}
#$ErrorActionPreference = 'SilentlyContinue'  
$ID =""
$date =  get-date -format 'yyyy-MM-dd HH:mm'
$ErrorLog = ".\error_connection.log"
$Decomissioned = 0
$report = @()

Foreach ($c in $ComputerName){
	if(Test-Connection -ComputerName $c -Count 1 -ea 0 -ev Err){ 
			#Create info from all parameters
			$reportinfo = New-Object psobject
			$reportinfo | Add-Member -MemberType NoteProperty -name ID -Value $c

			#Create report array
			$report += $reportinfo
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
	$report | export-csv -Path "$BasePath" -NoTypeInformation -delimiter ";"
	
	#Convert CSV for import to SQL database
	(Get-Content $BasePath) | foreach {$_ -replace '"'} | Set-Content $BasePath
	(Get-Content $BasePath) | foreach {$_ -replace ',',"."} | Set-Content $BasePath	
}


