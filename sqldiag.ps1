#Add SqlServer Management Objects (SMO) into Powershell context
Add-PSSnapin SqlServer*

#Function for grabbing DB info from specified server
Function DBInfo($Server) {
	#Add required SMO Assembly
	[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO') | out-null
	#Specify SQL Server for remainder of function
	$sqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server($Server)
	#Add array of Databases on SQL Server to a variable
	$dbs = $sqlServer.Databases
	#For each database on the SQL server, pull the following information
	ForEach ($db in $dbs){
		$dbName = $db.Name 
		$dbOwner = $db.Owner
		$dbSize = $db.Size
		$dbTLogSize = $db.LogFiles.Size / 1024
		If ($db.LogFiles.Growth -gt 0) {
			$dbAutoGrow = "True"
			} else {
			$dbAutoGrow = "False"
			}
		If ($db.LogFiles.MaxSize -eq '-1') {
			$dbMaxSize = "Unrestricted"
			} else {
			$dbMaxSize = $db.LogFiles.MaxSize / 1024
			}
		$dbCollation = $db.Collation
		$dbRecovery = $db.RecoveryModel
		If ($db.CompatibilityLevel -eq "Version90") {
			$dbCompatibility = "SQL Server 2005 (90)"
			} else {
				If ($db.CompatibilityLevel -eq "Version100") {
					$dbCompatibility = "SQL Server 2008 (100)"
					} else {
						If ($db.CompatibilityLevel -eq "Version80") {
							$dbCompatibility = "SQL Server 2000 (80)"
							} else {
								If ($db.CompatibilityLevel -eq "Version120") {
									$dbCompatibility = "SQL Server 2012 (120)"
									} else {
									$dbCompatibility = $db.CompatibilityLevel
								}
						}
				}
		}
		$dbClose = $db.AutoClose
		$dbCreate = $db.AutoCreateStatisticsEnabled
		$dbShrink = $db.AutoShrink
		$dbUpdate = $db.AutoUpdateStatisticsEnabled

		#Once the information is gathered and assigned its own variable, assign each variable a column name in csv format		
		$output = New-Object -TypeName PSObject -Property @{
			DBName = $dbName
			Owner = $dbOwner
			Size = $dbSize
			TLogSize = $dbTLogSize
			AutoGrow = $dbAutoGrow
			MaxSize = $dbMaxSize
			Collation = $dbCollation
			Recovery = $dbRecovery
			Compatibility = $dbCompatibility
			AutoClose = $dbClose
			AutoCreate = $dbCreate
			AutoShrink = $dbShrink
			AutoUpdate = $dbUpdate
		} 
	
		#Organize the column and data for export to a csv file which matches the SQL Update View in Sharepoint
		$output = $output | Select-Object DBName,Owner,Size,TLogSize,AutoGrow,MaxSize,Collation,Recovery,Compatibility,AutoClose,AutoCreate,AutoShrink,AutoUpdate
		
		#Output all of the gathered information to a csv file for use in documentation process
		#Must have a C:\Work directory on the server/machine you're running this from
		$output | Export-CSV C:\Work\$Server.csv -Append -NoTypeInformation -Force
		
	} 

	#Empty variable values for memory management and ease of repeat script use on extra sql server names
	# so as not to cause conflicts/errors down the road
	$Server = $null
	$sqlServer = $null
	$dbs = $null
	$dbName = $null
	$dbOwner = $null
	$dbSize = $null
	$dbTLogSize = $null
	$dbAutoGrow = $null
	$dbMaxSize = $null
	$dbCollation = $null
	$dbRecovery = $null
	$dbCompatibility = $null
	$dbClose = $null
	$dbCreate = $null
	$dbShrink = $null
	$dbUpdate = $null
	$output = $null
	
	#Call the Begin Script function so multiple servers can be reported on simultaneously
	BeginScript
}

#Function to start the program
Function BeginScript() {
	#Ask user for sql server they want to query
	$Server = Read-Host 'SQL Server to Inventory (q to quit)'
	#Check if the user wants to quit the script before continuing
	If ($Server -eq ''){
		exit
		} else {
			If ($Server -eq 'q'){
				exit
				} else {
				#Using the user provided server name, start the information pull process in the DBInfo Function
				DBInfo ($Server)
				}
		}
}

#Clear the powershell window for easier visibility
Clear-Host
#Call the BeginScript Function to start the program
BeginScript