$grp = 'GADM-W3EC'

$xnuc = Get-ADGroupMember -Identity $grp   

$xnuc | ForEach-Object Where $_.SamAccountName  {Get-ADUser -Identity $_.SamAccountName } | select GivenName, SamAccountName 


#>> d:\ff\$grp.txt





