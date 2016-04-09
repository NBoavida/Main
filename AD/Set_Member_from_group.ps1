param($p1, $p2)

# Receive Action
$x_action=$p1
# Receive the group
$x_group=$p2

$x_users = Import-Csv "D:\scripts\ad\Set_Member_from_group_config.csv" -delimiter ";" -encoding UTF7
Write-Host "Alterar Grupo: <$x_group>"

$x_users | %{
				$x_LUserID = [String]$_.Userid
				$x_LUserName = [String]$_.Name
				Write-Host "<$x_group - $x_LUserID - $x_LUserName>"
				
				.\User_MemberOf.ps1 $x_LUserID
				
				if ($x_action -eq "Add")
				{
					add-adgroupmember -Identity $x_group -Member $x_LUserID -confirm:$false
					Write-Host "   Member:<$x_LUserID> $x_action from group."
				}

				if ($x_action -eq "Del")
				{
					remove-adgroupmember -Identity $x_group -Member $x_LUserID -confirm:$false
					Write-Host "   Member:<$x_LUserID> $x_action from group."				}
			}