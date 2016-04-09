$chg = read-host CHG
$xnuc = read-host username

Write-Output  username: $xnuc  >> D:\ff\$Xnuc.log
Write-Output Change_ID: $chg  >> D:\ff\$Xnuc.log
Get-ADPrincipalGroupMembership $xnuc | select name >> D:\ff\$Xnuc.log