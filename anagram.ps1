$word1 = (Read-host "Input a word").ToLower()
$word2 = (Read-host "Input a second word").ToLower()

$array1 = $word1.ToCharArray()
$array2 = $word2.ToCharArray()

if($array1.count -eq $array2.count){
    $array1 = $array1 | sort
    $array2 = $array2 | sort

    $string1 = -join($array1)
    $string2 = -join($array2)

    if($string1 -match $string2){
        
        write-host "This is an anagram" 
    }
}
else{
    Write-host "This is not an anagram"
}
