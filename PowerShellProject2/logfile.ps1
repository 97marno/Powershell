# -------------------- INTRODUCTION -------------------- 
Write-Output "; SQL Server Configuration File
`r`n[OPTIONS]
`r`n; Specifies a Setup work flow, like INSTALL, UNINSTALL, or UPGRADE. This is a required parameter.
`r`nACTION=`"Install`"
`r`n; Accept the license terms
`r`nIACCEPTSQLSERVERLICENSETERMS=`"True`"
`r`n; Detailed help for command line argument ENU has not been defined yet.
`r`nENU=`"True`"
`r`n; Setup will not display any user interface.
`r`nQUIET=`"True`"
`r`n; Setup will display progress only, without any user interaction.
`r`nQUIETSIMPLE=`"False`"
`r`n; Specify whether SQL Server Setup should discover and include product updates. The valid values are True and False or 1 and 0. By default SQL Server Setup will include updates that are found.
`r`nUpdateEnabled=`"False`"" | Out-File -Width 256 $logfile

# -------------------- INSTANCE --------------------
#{[System.Windows.MessageBox]::Show("TEST")}  #{$InstanceNamed.checked()}
#if ($Textbox9.Text.Length -eq 3){$Textbox10.focus()}

If ($InstanceDefault.Checked -eq $true){
	$instance = "MSSQLSERVER"
	Write-Output "`r`n; Specify a default or named instance. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS)." | Out-File -append -Width 256 $logfile
	Write-Output "INSTANCENAME=`"MSSQLSERVER`"" | Out-File -append -Width 256 $logfile
	Write-Output "`r`n; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance." | Out-File -append -Width 256 $logfile
	Write-Output "INSTANCEID=`"MSSQLSERVER`"" | Out-File -append -Width 256 $logfile
}
else {
	$instance = $InstanceName.Text
	Write-Output "`r`n; Specify a default or named instance. This parameter is required when installing the SQL Server Database Engine (SQL), Analysis Services (AS), or Reporting Services (RS)." | Out-File -append -Width 256 $logfile
	Write-Output "INSTANCENAME=`"$($Instance)`"" | Out-File -append -Width 256 $logfile
	Write-Output "`r`n; Specify the Instance ID for the SQL Server features you have specified. SQL Server directory structure, registry structure, and service names will incorporate the instance ID of the SQL Server instance." | Out-File -append -Width 256 $logfile
	Write-Output "INSTANCEID=`"$($Instance)`"" | Out-File -append -Width 256 $logfile
}
# -------------------- EDITION --------------------
if ($EditionDev.Checked -eq $true){
	$isopath = $isopathdev
	Write-Output "`r`n;SQL Edition: DEVELOPMENT" | Out-File -append -Width 256 $logfile
}
if ($EditionStd.Checked -eq $true){
	$isopath = $isopathstd
	Write-Output "`r`n;SQL Edition: STANDARD" | Out-File -append -Width 256 $logfile
}
if ($EditionEnt.Checked -eq $true){
	$isopath = $isopathent
	Write-Output "`r`n;SQL Edition: ENTERPRISE" | Out-File -append -Width 256 $logfile
}
# -------------------- COLLATION --------------------
Write-Output "`r`n; Specifies a Windows collation or an SQL collation to use for the Database Engine." | Out-File -append -Width 256 $logfile
Write-Output "SQLCOLLATION=`"$($cboxcollation.Text)`"" | Out-File -append -Width 256 $logfile

# -------------------- AUTHENTICATION MODE --------------------
Write-Output "`r`n; The default is Windows Authentication. Use `"SQL`" for Mixed Mode Authentication." | Out-File -append -Width 256 $logfile
Write-Output "SECURITYMODE=`"SQL`"" | Out-File -append -Width 256 $logfile

Write-Output "`r`n; Specifies features to install, uninstall, or upgrade. The list of top-level features include SQL, AS, RS, IS, MDS, and Tools. The SQL feature will install the Database Engine, Replication, Full-Text, and Data Quality Services (DQS) server. The Tools feature will install shared components." | Out-File -append -Width 256 $logfile
Write-Output "FEATURES=SQLENGINE,FULLTEXT,CONN,IS,BC,SDK,SNAC_SDK" | Out-File -append -Width 256 $logfile

# -------------------- INSTALL DIR --------------------
Write-Output "`r`n; Specify the installation directory." | Out-File -append -Width 256 $logfile
Write-Output "INSTANCEDIR=`"$($cboxInstDir.Text)Program Files\Microsoft SQL Server`""  | Out-File -append -Width 256 $logfile
Write-Output "`r`n; Specify the root installation directory for shared components. This directory remains unchanged after shared components are already installed." | Out-File -append -Width 256 $logfile
Write-Output "INSTALLSHAREDDIR=`"$($cboxInstDir.Text)Program Files\Microsoft SQL Server`"" | Out-File -append -Width 256 $logfile
Write-Output "`r`n; Specify the root installation directory for the WOW64 shared components. This directory remains unchanged after WOW64 shared components are already installed." | Out-File -append -Width 256 $logfile
Write-Output "INSTALLSHAREDWOWDIR=`"$($cboxInstDir.Text)Program Files`(x86`)\Microsoft SQL Server`"" | Out-File -append -Width 256 $logfile

# -------------------- DATA DIR --------------------
Write-Output "`r`n; Specifies the data directory for SQL Server data files." | Out-File -append -Width 256 $logfile
Write-Output "INSTALLSQLDATADIR=`"$($cboxDataDir.Text)SQL`"" | Out-File -append -Width 256 $logfile
Write-Output "`r`n; Specifies the directory for the data files for user databases." | Out-File -append -Width 256 $logfile
Write-Output "SQLUSERDBDIR=`"$($cboxDataDir.Text)SQL\$($sqlpathed).$($Instance)\MSSQL\Data`"" | Out-File -append -Width 256 $logfile

# -------------------- LOG DIR --------------------
Write-Output "`r`n; Specifies the directory for the log files for user databases." | Out-File -append -Width 256 $logfile
Write-Output "SQLUSERDBLOGDIR=`"$($cboxLogDir.Text)SQL\$($sqlpathed).$($Instance)\MSSQL\Data`"" | Out-File -append -Width 256 $logfile

# -------------------- TEMP DIR --------------------
Write-Output "`r`n; Specifies the directories for tempdb data files. When specifying more than one directory, separate the directories with a blank space. If multiple directories are specified the tempdb data files will be spread across the directories in a round-robin fashion." | Out-File -append -Width 256 $logfile
Write-Output "SQLTEMPDBDIR=`"$($cboxTempDir.Text)SQL\$($sqlpathed).$($Instance)\MSSQL\Data`"" | Out-File -append -Width 256 $logfile
Write-Output "`r`n;Specifies the directory for tempdb log file." | Out-File -append -Width 256 $logfile
Write-Output "SQLTEMPDBLOGDIR=`"$($cboxTempDir.Text)SQL\$($sqlpathed).$($Instance)\MSSQL\Data`"" | Out-File -append -Width 256 $logfile

# -------------------- BACKUP DIR --------------------
Write-Output "`r`n; Specifies the directory for backup files." | Out-File -append -Width 256 $logfile
Write-Output "SQLBACKUPDIR=`"$($cboxBkpDir.Text)SQL\$($sqlpathed).$($Instance)\MSSQL\Backup`"" | Out-File -append -Width 256 $logfile

# -------------------- SERVICE ACCOUNTS --------------------

if ($CreateSvcAcc.Checked -eq $false){
	$SvcAccStr = $SvcAcc.Text
	$SvcAccpwd = $SvcPwd.Text
	Write-Output "`r`n; Account for SQL Server service: Domain\User or system account." | Out-File -append -Width 256 $logfile
	Write-Output "SQLSVCACCOUNT=`"$($SvcAccStr)`"" | Out-File -append -Width 256 $logfile
	Write-Output "SQLSVCPASSWORD=`"$($SvcAccpwd)`"" | Out-File -append -Width 256 $logfile
	Write-Output "AGTSVCACCOUNT=`"$($SvcAccStr)`"" | Out-File -append -Width 256 $logfile
	Write-Output "AGTSVCPASSWORD=`"$($SvcAccpwd)`"" | Out-File -append -Width 256 $logfile
	Write-Output "`r`n; Windows account(s) to provision as SQL Server system administrators." | Out-File -append -Width 256 $logfile
	Write-Output "SQLSYSADMINACCOUNTS=`"$($SvcAccStr)`" `"CORPNET\Domain-DBSysAdmin-GRP`"" | Out-File -append -Width 256 $logfile
	}
elseif ($CreateSvcAcc.Checked -eq $true){
	$SvcAccStr = "svcSQL$env:COMPUTERNAME"
	$grpLocalUsrGrp = "SQLApp$env:COMPUTERNAME-grp"
	. (Join-Path $PSScriptRoot 'CreateAccounts.ps1')
	Write-Output "`r`n; Account for SQL Server service: Domain\User or system account." | Out-File -append -Width 256 $logfile
	Write-Output "SQLSVCACCOUNT=`"$($SvcAccStr)`"" | Out-File -append -Width 256 $logfile
	Write-Output "SQLSVCPASSWORD=`"$($SvcAccpwd)`"" | Out-File -append -Width 256 $logfile
	Write-Output "AGTSVCACCOUNT=`"$($SvcAccStr)`"" | Out-File -append -Width 256 $logfile
	Write-Output "AGTSVCPASSWORD=`"$($SvcAccpwd)`"" | Out-File -append -Width 256 $logfile
	Write-Output "`r`n; Windows account(s) to provision as SQL Server system administrators." | Out-File -append -Width 256 $logfile
	Write-Output "SQLSYSADMINACCOUNTS=`"$($grpLocalUsrGrp)`" `"CORPNET\Domain-DBSysAdmin-GRP`"" | Out-File -append -Width 256 $logfile
	}   
Write-Output "SAPWD=`"$($svcsapwd)`"" | Out-File -append -Width 256 $logfile

# -------------------- SERVICES STATUS --------------------

Write-Output "`r`n; Auto-start service after installation." | Out-File -append -Width 256 $logfile
Write-Output "AGTSVCSTARTUPTYPE=`"Automatic`"" | Out-File -append -Width 256 $logfile

Write-Output "`r`n; Specify 0 to disable or 1 to enable the Named Pipes protocol." | Out-File -append -Width 256 $logfile
Write-Output "NPENABLED=`"0`"" | Out-File -append -Width 256 $logfile

Write-Output "`r`n; Startup type for Browser Service." | Out-File -append -Width 256 $logfile
Write-Output "BROWSERSVCSTARTUPTYPE=`"Disabled`"" | Out-File -append -Width 256 $logfile

# -------------------- PASSWORD FILE -------------------- 
$pwdate = get-date -format "yyyy/MM/dd HH:mm:ss"
Write-Output "Group/Title;Username;Password;URL;AutoType;Created Time;Password Modified Time;Last Access Time;Password Expiry Date;Password Expiry Interval;Record Modified Time;Password Policy;Password Policy Name;History;Run Command;DCA;Shift DCA;e-mail;Protected;Symbols;Notes" | Out-File -Width 256 -encoding ASCII $pwfile
Write-Output "$($env:computername).SQL.$($instance);sa;$($svcsapwd);;;$($pwdate);;;;;;;;00000;;-1;-1;;N;;`"`"" | Out-File -append -Width 256 -encoding ASCII $pwfile
Write-Output "$($env:computername).Windows.$($SvcAccStr);$($SvcAccStr);$($SvcAccpwd);;;$($pwdate);;;;;;;;00000;;-1;-1;;N;;`"Account for SQL Server service`"" | Out-File -append -Width 256 -encoding ASCII $pwfile

# -------------------- WRITE TO LOG FILE -------------------- 
Write-Output "`r`n# -------------------- SQL CONFIGURATION -------------------- " | out-File -append -filepath $installog
Write-Output "SQL installation ini-file created `'$($logfile)`'" | out-File -append -filepath $installog
Write-Output "`r`n# -------------------- PASSWORD FILE -------------------- " | out-File -append -filepath $installog
Write-Output "Password file created `'$($pwfile)`'" | out-File -append -filepath $installog