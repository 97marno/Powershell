$ascii=$NULL;For ($a=33;$a –le 126;$a++) {$ascii+=,[char][byte]$a }

Function GET-Temppassword() {

Param(

[int]$length=10,

[string[]]$sourcedata

)

 

For ($loop=1; $loop –le $length; $loop++) {

            $TempPassword+=($sourcedata | GET-RANDOM)

            }

return $TempPassword

}


$accountpassword = GET-Temppassword –length 15 –sourcedata $ascii

#New-ADUser  -Name $SvcAccStr -Enabled $true -AccountPassword (ConvertTo-SecureString $accountpassword -AsPlainText -Force) -Path "OU=Avengers,DC=savilltech,DC=net" -PassThru | Add-ADPrincipalGroupMembership -MemberOf CurrentRoster
#New-ADuser -Name ($newuser.Username) -DisplayName ($newuser.Fullname) -Description ($newuser.Desc) -Path ("OU=Users,OU=Student,DC=Student,DC=example,DC=se") -SamAccountName ($newuser.Username) -UserPrincipalName ($newuser.Username + "@student.example.se") -Homedrive ("H") -Homedirectory ("\\nas-s1\home$\" + $newuser.Username) -ProfilePath ("\\nas-s1\profiles$\" + $newuser.Username) -AccountPassword (ConvertTo-SecureString $newuser.Password -AsPlainText -force) -Enabled $true

#Verify if module ActiveDirectory is available or not
If ((Get-WMIObject Win32_OperatingSystem).Version -ge '6.1'){ #Windows 2008 R2 or above, Check for module ActiceDirectory
    Import-Module ServerManager
    If ((Get-WindowsFeature RSAT-AD-PowerShell).Installed -eq $true) {
	    $AD = $true
    }
    Else  { $AD = $false }
}
Else { $AD = $false }

$AD

<#Creating objects in AD
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