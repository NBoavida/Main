 $grp = Read-host "Group"
 
 Get-ADGroup -Filter {name -like $grp} -Properties * | select Name, description
