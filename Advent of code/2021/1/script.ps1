
cls
$input = get-content '.\Advent of code\2021\1\input.txt'
$start = $null
$increased = $null
$decreased =$null
foreach($no in $input){
    if (!$start) {
        $last = $no
        $start = $no
        $no    
    }
    else{
        if($no -gt $last){
            write-host "$($no) increased" 
            $increased += 1
            #$increased
        }
        else {
            write-host "$($no) decreased"
            $decreased = $decreased + 1
        }
        $last = $no
    }
    
}

Write-output "Increased: $increased "
Write-output "Decreased: $decreased "