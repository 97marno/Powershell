cls
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator in an elevated Powershell!"
    Break
}

# -------------------- INFORMATION -------------------- 
<#
	.SYNOPSIS
		(C) Marlén Norling 2017. marlen@norling.cx
		Script that create new service account and adds it to local group. 

	.DESCRIPTION
		

	.EXAMPLE

		PS C:\> .\Form1.ps1
		
		Description
		-------------
		
		
	.OUTPUTS
		

#>

# -------------------- PARAMETERS --------------------
$RDSGroup = "Remote Desktop Users"
$Computer = [ADSI]"WinNT://$Env:COMPUTERNAME,Computer"


# -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE -------------------- DO NOT EDIT AFTER THIS LINE --------------------

# -------------------- FUNCTIONS --------------------
# Function to check if local account exist
function LocalUserExist($userName)
{
  # Local user account creation: 
  $colUsers = ($Computer.psbase.children | Where-Object {$_.psBase.schemaClassName -eq "User"} | Select-Object -expand Name)
  $userFound = $colUsers -contains $userName
  return $userFound
} 

# Function to check for the existence of Local group
function LocalGroupExist($groupName)
{ 
 return [ADSI]::Exists("WinNT://$Env:COMPUTERNAME/$groupName,group")
}

# Function to check for the existence of member in Local group
function CheckGroupMember($groupName,$memberName)
{
 $group = [ADSI]"WinNT://$Env:COMPUTERNAME/$groupName"
 
 $members = @($group.psbase.Invoke("Members"))
 $memberNames = $members | foreach {$_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)} 

 $memberFound = $memberNames -contains $memberName
 return $memberFound
 
}

# -------------------- SCRIPT --------------------

# Verify if module ActiveDirectory is available or not and create accounts after the preconditions
If ((Get-WMIObject Win32_OperatingSystem).Version -ge '6.1'){ #Windows 2008 R2 or above
    Import-Module ServerManager
	If ((Get-WindowsFeature RSAT-AD-PowerShell).Installed -eq $true) { #Check for module ActiceDirectory
	    $AD = $true
    }
    else {
		# Powershell 5.1 New-LocalUser $SvcAccStr -Password $accountpassword -FullName "SQL Service Account" -Description "Administrative account that will start the SQL Services"
        # Add-GroupMember -Name 'SQL App Admin Users' -Member $SvcAccStr
		$userExist = LocalUserExist($SvcAccStr) #Call function LocalUserExist to check if user exist
 
		if($userExist -eq $false) #Create user if not exist
		{
			$User = $Computer.Create("User", $SvcAccStr)
			$User.SetPassword($SvcAccpwd)
			$User.SetInfo()
			$User.FullName = "SQL Service Account"
			$User.SetInfo()
			$User.UserFlags = 64 + 65536 # ADS_UF_PASSWD_CANT_CHANGE + ADS_UF_DONT_EXPIRE_PASSWD
			$User.SetInfo()
			Write-Output "`r`n# -------------------- ADMINISTRATIVE ACCOUNT - SQL SERVICES -------------------- " | out-File -append -filepath $installog
			Write-Output "User : $SvcAccStr already exist." | out-File -append -filepath $installog
		}
		else {
			Write-Output "`r`n# -------------------- ADMINISTRATIVE ACCOUNT - SQL SERVICES -------------------- " | out-File -append -filepath $installog
			Write-Output "User : $SvcAccStr already exist." | out-File -append -filepath $installog
		}

		$groupExist = LocalGroupExist($grpLocalUsrGrp) #Call function to check if local group exist
		Write-Output "`r`n# -------------------- ADMINISTRATIVE ACCOUNT - GROUPS -------------------- " | out-File -append -filepath $installog
		if($groupExist -eq $false) #Create local group if not exist, and add service account and att group to RDS-group
		{
			$Group = $Computer.Create("Group", $grpLocalUsrGrp)
			$Group.SetInfo()
			$Group.Description = "SQL App User group"
			$Group.SetInfo()
			($computer.Children.find($grpLocalUsrGrp,'group')).add(("Winnt://$env:COMPUTERNAME/$svcaccstr"))
			($computer.Children.find('Remote Desktop Users','group')).add(("Winnt://$env:COMPUTERNAME/$grpLocalUsrGrp"))
			
			Write-Output "$grpLocalUseGrp created and user $SvcAccStr added to it. $grpLocalUseGrp added to Remote Desktop Users" | out-File -append -filepath $installog
		}
		else
		{
			Write-output "Group: $grpLocalUsrGrp already exist." | out-File -append -filepath $installog
			$memberExist = CheckGroupMember $RDSGroup $grpLocalUsrGrp #If local group exist, check if member in RDS-group and add if not
			if($memberExist -eq $false){
				($computer.Children.find('Remote Desktop Users','group')).add(("Winnt://$env:COMPUTERNAME/$grpLocalUsrGrp"))
				Write-output "$grpLocalUsrGrp added to Remote Desktop Users." | out-File -append -filepath $installog
			}
            $memberExist = CheckGroupMember $grpLocalUsrGrp $svcaccstr #If local service account not exist in local group, add. 
            if($memberExist -eq $false){
				($computer.Children.find($grpLocalUsrGrp,'group')).add(("Winnt://$env:COMPUTERNAME/$svcaccstr"))
				Write-output "$svcaccstr is added to $grpLocalUsrGrp" | out-File -append -filepath $installog
			}
		}
	}
}
Else { Write-Output "Windows version is lower than Windows 2008 R2. Please upgrade." | out-File -append -filepath $installog}

Write-output "Service account: $SvcAccStr" | out-File -append -filepath $installog
Write-output "Service account password: $SvcAccpwd" | out-File -append -filepath $installog
Write-output "SA password: $svcsapwd" | out-File -append -filepath $installog



#New-ADUser  -Name $SvcAccStr -Enabled $true -AccountPassword (ConvertTo-SecureString $accountpassword -AsPlainText -Force) -Path "OU=Avengers,DC=savilltech,DC=net" -PassThru | Add-ADPrincipalGroupMembership -MemberOf CurrentRoster
#New-ADuser -Name ($newuser.Username) -DisplayName ($newuser.Fullname) -Description ($newuser.Desc) -Path ("OU=Users,OU=Student,DC=Student,DC=example,DC=se") -SamAccountName ($newuser.Username) -UserPrincipalName ($newuser.Username + "@student.example.se") -Homedrive ("H") -Homedirectory ("\\nas-s1\home$\" + $newuser.Username) -ProfilePath ("\\nas-s1\profiles$\" + $newuser.Username) -AccountPassword (ConvertTo-SecureString $newuser.Password -AsPlainText -force) -Enabled $true

<#
Creating objects in AD
If ($AD){ #Windows 2008 R2 or above, Use module ActiceDirectory
    
    Import-Module ActiveDirectory

    #Create AppGroup in Active Directory + membership
    $AdPath = "OU=ODP-SSIS,OU=KCDB,OU=SystemAccounts,DC=tcad,DC=telia,DC=se"
    $Desc = "SSIS users for application " + $Application.ToUpper()
    New-ADGroup -Name $AppGroup -SamAccountName $AppGroup -GroupCategory Security -GroupScope Universal -DisplayName $AppGroup -Path $AdPath -Description $Desc
    Add-ADGroupMember $InstanceGroup $AppGroup

    #Create AppUser in Active Directory + membership
    $pwplain = Get-RandomString -Length 8 -UpperCase -Numbers -Symbols
    $pwsecure = $pwplain | ConvertTo-SecureString -AsPlainText -Force
    $UserAndPw.Add("TCAD\"+$AppUser,$pwplain)
    $Desc = "SSIS user for application " + $Application.ToUpper()
    $Principal = $AppUser + "@tcad.telia.se"
    New-ADUser -Name $AppUser -GivenName $AppUser -DisplayName $AppUser -SamAccountName $AppUser -UserPrincipalName $Principal -Enabled $true -AccountPassword $pwsecure -PasswordNeverExpires $true -CannotChangePassword $false -Path $AdPath -Description $Desc
    Add-ADGroupMember $AppGroup $AppUser

    #Create CredUser in Active Directory + memberships
    $pwplain = Get-RandomString -Length 16 -UpperCase -Numbers -Symbols
    $pwsecure = $pwplain | ConvertTo-SecureString -AsPlainText -Force
    $UserAndPw.Add("TCAD\"+$CredUser,$pwplain)
    $Desc = "SSIS proxy account for " + $Application
    $Principal = $CredUser + "@tcad.telia.se"
    $Surname = "System Account"
    $Name = $Surname + ", " + $CredUser
    New-ADUser -SamAccountName $CredUser -Name $Name -GivenName $CredUser -Surname $Surname -DisplayName $Name -UserPrincipalName $Principal -Enabled $true -AccountPassword $pwsecure -PasswordNeverExpires $true -CannotChangePassword $true -Path $AdPath -Description $Desc
    Add-ADGroupMember $ProxyGroup $CredUser
    Add-ADGroupMember $AppGroup $CredUser

    $Name | Write-Output
}

#>