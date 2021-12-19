Clear-Host
$count=0
$day2_input = Get-Content .\2\input.txt

foreach($row in $day2_input){
    $condition = $row.split(":")[0]
    $puzzlepwd = $row.split(": ")[1]
    $letter = $($condition.split(" ")[1])
    $occurance = $condition.split(" ")[0] -replace ("-",",")
    
    <#
    $condition
    $puzzlepwd ="lllllllllllllllllsdsdlll"
    $letter
    $occurance
    #>
    if((($puzzlepwd.Split("$($letter)")).count-1) -ge $($occurance.Split(",")[0]) -and (($puzzlepwd.Split("$($letter)")).count-1) -le $($occurance.Split(",")[1])){
        $count++
    }
}
Write-host "There are $($count) valid passwords"

<#
("1-3 a: abcde" -split ':*.-')
"Hello" -match '^(.*)llo$'; $matches[1]
1-3 a: abcde
("OU=MTL1,OU=CORP,DC=FX,DC=LAB" -split ',*..=')[1]

-cmatch '[a-z]'
-cmatch '[A-Z]'
-match '\d'
-match '^([7-9]|[1][0-9]|[2]|[0-5])$'
'!|@|#|%|&'
#>