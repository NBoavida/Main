param($p1)

if ($PSBoundParameters.keys.count -eq 1)
{
	$x_grupo = $PSBoundParameters["p1"]
}else
{
	$x_grupo = 	Read-Host 'GroupID?'
}

Try {
$x_Members = Get-ADGroupMember $x_grupo
}
Catch {
	Write-Host "`nGroupID: <$x_grupo>"
	Write-Host "`nÉ necessário indicar um GroupID válido para exportar os membros."
	exit
}

$x_File_Out_Csv = "d:\scripts\ad\Get-ADMembers\Get-ADMembers_" + $x_grupo + "_"+ (get-random) + ".csv"

Import-Module ActiveDirectory 
$x_Members | 
	Get-ADObject -Properties sAMAccountName, displayName | 
		Select-Object @{name="Grupo"; expression={$x_grupo}}, sAMAccountName, DisplayName | sort sAMAccountName |
			Export-Csv $x_File_Out_Csv -Encoding UTF8 -Append -Delimiter ";" -notypeinformation

echo "Backup criado !"
echo $x_File_Out_Csv
Echo "======================================================="