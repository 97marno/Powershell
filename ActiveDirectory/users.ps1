#import the ActiveDirectory Module

Import-Module ActiveDirectory

#Create a variable for the date stamp in the log file

$LogDate = get-date -f yyyyMMddhhmm

#Sets the OU to do the base search for all user accounts, change for your env.

$SearchBase = "DC=skypoint,DC=LOCAL"

#Create an empty array for the log file

$LogArray = @()

#Sets the number of days to delete user accounts based on value in description field

$Disabledage = (get-date).adddays(-14)

#Sets the number of days to disable user accounts based on lastlogontimestamp and pwdlastset.

$PasswordAge = (Get-Date).adddays(-90)

#RegEx pattern to verify date format in user description field.

$RegEx = '^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](20)\d\d$'

#Use ForEach to loop through all users with description date older than date set. Deletes the accounts and adds to log array.

ForEach ($DeletedUser in (Get-Aduser -searchbase $SearchBase -Filter {enabled -eq $False} -properties description ) ){

  #Verifies description field is in the correct date format by matching the regular expression from above to prevent errors with other disbaled users.

  If ($DeletedUser.Description -match $Regex){

    #Compares date in the description field to the DisabledAge set.

    If((get-date $DeletedUser.Description) -le $Disabledage){

      #Deletes the user object. This will prompt for each user. To suppress the prompt add "-confirm:$False". To log only add "-whatif".

      Remove-ADObject $DeletedUser -whatif

        #Create new object for logging

        $obj = New-Object PSObject

        $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value $DeletedUser.name

        $obj | Add-Member -MemberType NoteProperty -Name "samAccountName" -Value $DeletedUser.samaccountname

        $obj | Add-Member -MemberType NoteProperty -Name "DistinguishedName" -Value $DeletedUser.DistinguishedName

        $obj | Add-Member -MemberType NoteProperty -Name "Status" -Value 'Deleted'

        #Adds object to the log array

        $LogArray += $obj

    }

  }

}

#Use ForEach to loop through all users with pwdlastset and lastlogontimestamp greater than date set. Also added users with no lastlogon date set. Disables the accounts and adds to log array.

ForEach ($DisabledUser in (Get-ADUser -searchbase $SearchBase -filter {((lastlogondate -notlike "*") -OR (lastlogondate -le $Passwordage)) -AND (passwordlastset -le $Passwordage) -AND (enabled -eq $True)} )) {

  #Sets the user objects description attribute to a date stamp. Example "11/13/2011"

  set-aduser $DisabledUser -Description ((get-date).toshortdatestring())

  #Disabled user object. To log only add "-whatif"

  Disable-ADAccount $DisabledUser -whatif

    #Create new object for logging

    $obj = New-Object PSObject

    $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value $DisabledUser.name

    $obj | Add-Member -MemberType NoteProperty -Name "samAccountName" -Value $DisabledUser.samaccountname

    $obj | Add-Member -MemberType NoteProperty -Name "DistinguishedName" -Value $DisabledUser.DistinguishedName

    $obj | Add-Member -MemberType NoteProperty -Name "Status" -Value 'Disabled'

    #Adds object to the log array

    $LogArray += $obj

}

#Exports log array to CSV file in the temp directory with a date and time stamp in the file name.

$logArray | Export-Csv "C:\Temp\User_Report_$logDate.csv" -NoTypeInformation