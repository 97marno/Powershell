
#import the ActiveDirectory Module
Import-Module ActiveDirectory

#how many days the computers have been inactive for, where X is number of days
$DaysInactive = 60
$time = (Get-Date).Adddays(-($DaysInactive))

#OU you are scanning for inactive computers
$searchOU = "DC=skypoint,DC=LOCAL"
#skypoint.local/03BackEnd/BackEnd_System/System_Microsoft/System_Microsoft_2012

#OU you want to place disabled computers
$DestinationOU = "OU=DisabledComputers,DC=skypoint,DC=LOCAL"

$StaleComputers = Get-ADComputer -SearchBase $SearchOU -Filter {LastLogonTimeStamp -lt $time} -Properties LastLogonTimeStamp
$StaleComputers | Disable-ADAccount
$StaleComputers | %{ Move-ADObject -Identity $_.DistinguishedName -TargetPath $DestinationOU }