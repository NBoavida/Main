		###########################################################################
#
# NAME: Check reboots
#
# AUTHOR:  D333867  - Frederico Frazão
#
# COMMENT: Get reboot History 
#
# VERSION HISTORY:
# 1.0 13-04-2012 - Initial release
#
#################################################################################
	
	$computer="localhost"
$time=Get-WmiObject -class Win32_OperatingSystem -computer $computer
$t=$time.ConvertToDateTime($time.Lastbootuptime)
[TimeSpan]$uptime=New-TimeSpan $t $(get-date)
"$($uptime.days)d $($uptime.hours)h $($uptime.minutes)m $($uptime.seconds)S"  | Out-File reboots.txt


	
$maquina= hostname

Get-EventLog -LogName System -ComputerName $maquina |
where {$_.EventId -eq 1074} |
ForEach-Object {

 $rv = New-Object PSObject | Select-Object Date, User, Action, process, Reason, ReasonCode, Comment, Message
 if ($_.ReplacementStrings[4]) {
 $rv.Date = $_.TimeGenerated
 $rv.User = $_.ReplacementStrings[6]
 $rv.Process = $_.ReplacementStrings[0]
 $rv.Action = $_.ReplacementStrings[4]
 $rv.Reason = $_.ReplacementStrings[2]
 $rv.ReasonCode = $_.ReplacementStrings[3]
 $rv.Comment = $_.ReplacementStrings[5]
 $rv.Message = $_.Message
 $rv
 }
} | Select-Object Date, Action, Reason, User  | Out-File reboots.txt
	
	invoke-Expression "notepad.exe reboots.txt" 

