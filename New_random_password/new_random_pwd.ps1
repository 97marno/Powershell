clear-host
#$ascii=$NULL;For ($a=33;$a �le 126;$a++) {$ascii+=,[char][byte]$a } #All ascii chars from 33 to 126
$a=$NULL;For ($z=48;$z �le 57;$z++) {$a+=,[char][byte]$z } #0-9
$b=$NULL;For ($z=63;$z �le 90;$z++) {$b+=,[char][byte]$z } #a-z
$c=$NULL;For ($z=97;$z �le 122;$z++) {$c+=,[char][byte]$z } #A-Z + ?@
$ascii =$a + $b + $c

Function GET-Temppassword() {

Param(

[int]$length=10,

[string[]]$sourcedata


)



For ($loop=1; $loop �le $length; $loop++) {
          
            $TempPassword+=($sourcedata | GET-RANDOM)

            }

return $TempPassword

}

write-host "Your Random Generated Password Is below: `n `r" -ForegroundColor GRAY
$password1 = (GET-Temppassword �length 19 �sourcedata $ascii )
$password2 = (GET-Temppassword �length 19 �sourcedata $ascii )
$password3 = (GET-Temppassword �length 19 �sourcedata $ascii )

write-host "`n `rPASSWORD1: `r" 
write-host $password1  -ForegroundColor YELLOW

write-host "`n `rPASSWORD2: `r" 
write-host $password2  -ForegroundColor GREEN

write-host "`n `rPASSWORD3: `r" 
write-host $password3  -ForegroundColor CYAN