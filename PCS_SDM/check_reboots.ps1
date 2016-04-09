
###########################################################################
# NAME: Check reboots 
#
# 
# VERSION HISTORY:
#   1.0 20150813 - Frederico Frazão
###########################################################################

$maquina = read-host Hostname


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
} | Select-Object Date, Action, Reason, User 


$batch_Date = (get-date).AddDays(-2).ToString("yyy-MM-dd")

$batch_Date