$codeinput = get-content '.\Powershell\Advent of code\2022\1_input.txt'

$i = 0  
$elfarray = @()

foreach($row in $codeinput){
    if($row -ne ""){
        $i = $i + $row
        #write-host "adding"
    }
    else {
        $elfarray += $i 
        $i = 0
        #write-host "writing to elfarray"
    }
}

[array]::sort($elfarray)
Write-host "The fattest elf is $($elfarray[-1])"

# Part 2
$elftotal = ($elfarray[-3..-1] | Measure-Object -Sum).Sum
Write-Host "Top three elves are in total $elftotal"