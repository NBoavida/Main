$computer="localhost"
$time=Get-WmiObject -class Win32_OperatingSystem -computer $computer
$t=$time.ConvertToDateTime($time.Lastbootuptime)
[TimeSpan]$uptime=New-TimeSpan $t $(get-date)
"$($uptime.days)d $($uptime.hours)h $($uptime.minutes)m $($uptime.seconds)S"  
