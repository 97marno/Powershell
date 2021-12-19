Clear-Host
$avcinput = Get-Content .\3\input.txt
$start = 0
$trees = 0
foreach($row in $avcinput){

    if($start -ge $row.length){
        $start = $start - $row.length
 
    }
    if($row[$start] -eq "#"){
        $trees++
    }
    $start = $start + 3
}
Write-host "Trees count: $($trees)"

<#
Right 1, down 1.
Right 3, down 1. (This is the slope you already checked.)
Right 5, down 1.
Right 7, down 1.
Right 1, down 2.
#>