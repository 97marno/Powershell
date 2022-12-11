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

$n = $elfarray[0]
foreach ($elf in $elfarray){
    if($elf -le $n){

    }
    else {
        $n = $elf
    }
}

Write-host "The fattest elf is $($n)"