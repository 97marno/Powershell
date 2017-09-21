$final = (Get-Date -Month 9 -Day 18).Date

$a = ((get-date).Date).AddDays(1)
$days = ($final - $a).Days
$eow = 1
for ($i = 0;$i -le $days;$i++){
   if (!($a.DayOfWeek -eq "Saturday" -or $a.DayOfWeek -eq "Sunday")) {
       $eow = $eow +1
   }
   $a = $a.AddDays(1)
}
Write-host "Number of working days left : $eow"




$StartDate=(GET-DATE)
$EndDate=[datetime]”09/18/2017 16:00”
$hourstot = (NEW-TIMESPAN –Start $StartDate –End $EndDate).TotalHours

