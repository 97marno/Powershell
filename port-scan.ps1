[cmdletBinding(SupportsShouldProcess=$false, DefaultParametersetName='computername')]
param(
	[Parameter(
		Mandatory=$false,
		ParameterSetName='computername',
		HelpMessage='Computer Name(s)'
	)] 
	[alias('computer')]
	[string[]]
	$ComputerName = $env:computername
	,
	[Parameter(Mandatory=$false)] 
	[ValidateNotNullOrEmpty()]
	[string]
	$Port = 1433
)

#$ComputerName= 's1sqlmgmt-p'
#$Port= 1433

$tcp = New-Object Net.Sockets.TcpClient
$tcp.Connect($ComputerName,$Port)
    if($tcp.Connected)
    {
        "Port $Port is operational"
    }
    else
    {
        "Port $Port is closed, You may need to contact your IT team to open it. "
    }
$tcp.Dispose()

	
<#$server = 
$port   = 1433

$tcp = New-Object Net.Sockets.TcpClient
if ([void]$tcp.Connect($server, $port)) {
  'connected'
} else {
  'not connected'
}
$tcp.Dispose()
#>