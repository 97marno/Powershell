clear-host
$data = get-content .\input.txt
$index = 0
#$index2 = 2
$itt = 0
Do { 
        Do{
            if((($data[$itt] -as [int]) + ($data[$index+1] -as [int])) -eq 2020){
                $tal1= $data[$itt] -as [int]
                $tal2=$data[$index+1] -as [int]
                Write-host "Sum of" $data[$itt] "and " $data[$index+1] " is " ($tal1+$tal2)
                Write-host "Your input should be " ($tal1*$tal2) 
            }
            $index++

        } while ($index -ne $data.count) 
    
    $index=-1  

    $itt++
    $index= -1

    } while($itt -ne $data.count)
