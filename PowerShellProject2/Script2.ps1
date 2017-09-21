$server = 's1sqlmgmt-p'
$report = @()

$sqlconnection = New-Object System.Data.SqlClient.SqlConnection
$sqlconnection.ConnectionString = "Data Source=" + $server + ";Database=ps;integrated security=true"
$sqlconnection.Open()
#$sqlconnection.state

$sqlquery = "Select computername from computers where decomissioned = 0"

$command = $sqlconnection.CreateCommand()
$command.CommandText = $sqlquery
$result = $command.ExecuteReader()

$formatOut = @()
$table = new-object “System.Data.DataTable”
$table.Load($result)

for ($i=0; $i -le $result.Length; $i++)
{
    $formatOut = $formatOut + ($result[$i].ItemArray -join ",")
}

$formatOut

<# 
foreach ($c in $table){
	$c.item("domain")

	


	#Write-Host "server $c.item[0]"
	<#$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c | Select -Property Name, Domain 
	$ComputerSystem
	$reportinfo = New-Object psobject
	$reportinfo | Add-Member -MemberType NoteProperty -name ComputerName -Value $ComputerSystem.Name
	$reportinfo | Add-Member -MemberType NoteProperty -name Domain -Value $ComputerSystem.Domain
	$report += $reportinfo
	}
#>
#$format = @{Expression={$_.Id};Label=”Id”;width=10},@{Expression={$_.ModifyDate;Label=”Modify Date"; width=30},@{Expression={$_.Decomissioned;Label=”Decom”; width=10},@{Expression={$_.computername;Label=”Computername”; width=20}

#$table | Where-Object {$_.Surname -like "*sson" -and $_.Born -lt 1990} | format-table $format
#>

#| format-table $format

#$report
  <#$execute_query = New-Object System.Data.SqlClient.SqlCommand
    $execute_query.connection = $sqlconnection
    # $execute_query.commandtext = $insert_query
    $execute_query.CommandText = "SELECT * FROM computers"
	#$execute_query.CommandText = "INSERT INTO computers (ModifyDate,Decomissioned,ComputerName) VALUES ('2017-08-23','0','$server')"
    $execute_query.executenonquery()
    #>


$sqlconnection.close()
$sqlconnection.state
	