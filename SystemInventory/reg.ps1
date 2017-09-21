
$c = 's1sqlmgmt-p.corpnet.teracom.se'


$ComputerSystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $c -EV Err -ErrorAction SilentlyContinue
			#$MSSQL = Get-Service -displayname 'SQL Server (*' -computername $c | select @{n='Name';e={$_.name -replace 'MSSQL[$]'}} #special characters within brackets 
			write-host $c
			write-host $ComputerSystem
			$namespace = gwmi -computername $c -Namespace "root\microsoft\sqlserver" -Class "__Namespace" -Filter "name like 'ComputerManagement%'" | sort desc | select -ExpandProperty name -First 1			
			write-host $namespace
			#write-host $mssql
			#$MSSQL = Get-Service -Name *MSSQL* -computername $c | select @{n='Name';e={$_.name -replace 'MSSQL[$]'}} #special characters within brackets
			$dbConnection = New-Object System.Data.SqlClient.SqlConnection -EV Err -EA SilentlyContinue
			$tcpport = Get-WmiObject -computername $c -Namespace "root\microsoft\SqlServer\$namespace" -Class ServerNetworkProtocolProperty | select instancename,propertystrval, IPAddressName | where{$_.IPAddressName -eq 'IPAll' -and $_.propertystrval -ne '' -and $_.instancename -eq $i }
			write-host $tcpport
			$sqlport = tcpport.propertystrval
			write-host $sqlport
			$SQLServer = $ComputerSystem.name
			write-host $SQLServer
			$dbConnection.ConnectionString = ("Server=$SQLServer,$sqlport;Database=master;Integrated Security=True;Connect Timeout=3")
			$dbConnection.Open()
					if ($dbConnection.State -eq 'Closed'){
							 Write-Host ""$SQLServer": No database connection to server" -Foregroundcolor Red
					}
					else { $dbconnection.close()}