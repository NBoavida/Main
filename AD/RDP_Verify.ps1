$Fich_Out="D:\Scripts\ad\RDP2012.csv"

echo "Group`tDescription`tMemberOf`tMember Type" > $Fich_Out; 
Get-ADGroup -filter {Name -like "g-rdp*"} -Properties Description | 
	sort Name |
		select Name, Description | 
			%{
				$GrupoPai=($_.Name+"`t"+$_.Description+"`t"); 
				get-adgroupmember $_.name | 
					%{
						echo ($GrupoPai + $_.name + "`t" + $_.objectClass ) >> $Fich_Out
					}
			}
start excel.exe $Fich_Out
