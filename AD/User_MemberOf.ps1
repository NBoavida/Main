param($p1, $p2)

#cls
$x_pathcsv = "D:\Scripts\AD\MemberOf\" 
Echo "================ Export User MemberOF ======================"
if ($PSBoundParameters.keys.count -eq 2)
{
	$x_username = $PSBoundParameters["p1"]
	$x_pathcsv = $PSBoundParameters["p2"]
	echo "Dois"
}ElseIf ($PSBoundParameters.keys.count -eq 1)
{
	$x_username = $PSBoundParameters["p1"]
}Else
{	
	$x_username = Read-Host -Prompt "Introduza o UserID"
}
echo "Path BK: $x_pathcsv"
echo " UserId: $x_username"

$x_HoraBackup = Get-Date -format "yyyyMMdd_HHmm"
$x_CurrentUser = [Environment]::UserName
$x_pathcsv += "User_MemberOf_" + $x_username + "_" + $x_HoraBackup + "_" + 	$x_CurrentUser + "_" + (get-random) + ".csv"

$x_Colunas = 	"User" +
				"`t" +
				"Group Name" +
				"`t" +
				"Group Scope" +
				"`t" +
				"Group Category" +
				"`t" +
				"Description" 
$x_Colunas > $x_pathcsv

$x_members=Get-ADPrincipalGroupMembership $x_username
$x_members | %{
				$x_group = Get-ADGroup -Identity $_.name -Properties *
				$x_Colunas = 	$x_username +
								"`t" +
								$_.name +
								"`t" +
								$_.Groupscope +
								"`t" +
								$_.groupcategory +
								"`t" +
								$x_group.Description 
				$x_Colunas >> $x_pathcsv
			  }

echo "Backup criado !"
echo $pathcsv
Echo "======================================================="
return $x_pathcsv
