clear-host
$data = get-content .\input.txt
$index = 0
$index2 = 2
$itt = 0
Do { 
    Do{
        Do{
            if((($data[$itt] -as [int]) + ($data[$index+1] -as [int])+ ($data[$index2] -as [int])) -eq 2020){
                Write-host "Sum of" $data[$itt] "and " $data[$index+1] "and " $data[$index2] " is 2020"
                $tal1= $data[$itt] -as [int]
                $tal2=$data[$index+1] -as [int]
                $tal3=$data[$index+2] -as [int]

            $sum = $tal1*$tal2*$tal3
            $sum
            }
            $index++
           # Write-host "Index 1 loop $($index)"
        } while ($index -ne $data.count) 
    
    $index2++
    $index=-1  
   # Write-host "`tIndex2 loop $($index2)"
     
    } while ($index2 -ne $data.Count)    
    
    $itt++
    $index= -1
    $index2=2
    Write-host "`t`tItteration loop $($itt)"
    } while($itt -ne $data.count)