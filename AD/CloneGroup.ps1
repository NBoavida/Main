param($p1,$p2,$p3,$p4)

Function Erro_Sintaxe
{
	param($p1)
	Write-Host   "Erro: $p1"
	Write-Host "`nSintaxe: .\CloneGroup.ps1 <Source Domain> <Source Group> <Target OU> <New Group>"
	Write-Host "`n<Source Domain> : 'DC=grupocgd,DC=Com'                                                      para GrupoCGD.com"
	Write-Host "`n <Source Group> : 'GGCXS-Process360-PRD-USERS'                                              exemplo de um grupo"
	Write-Host "`n    <Target OU> : 'OU=Servicos,OU=Servicos-Transversais,OU=FM,DC=fidelidademundial,DC=com'  OU Destino"
	Write-Host "`n    <New Group> : 'TESTE-GRP'                                                               Nome novo Grupo"
	Write-Host "`nProcesso cancelado!`n"
	exit
}

cls
if ($PSBoundParameters.keys.count -eq 4)
{
	$x_Source_Domain = $PSBoundParameters["p1"]
	$x_Source_Group = $PSBoundParameters["p2"]
	$x_TargetOU = $PSBoundParameters["p3"]
	$x_NewGroup = $PSBoundParameters["p4"]
} else
{
	Erro_Sintaxe("Faltam parametros. Ver sintaxe")
}

Write-Host   "Inicio de Processo!"

$x_Users_List = dsquery group $x_Source_Domain -name $x_Source_Group | dsget group -members -expand

Try
{
	New-ADGroup -Name $x_NewGroup -SamAccountName $x_NewGroup -GroupCategory Security -GroupScope DomainLocal -DisplayName $x_NewGroup -Path $x_TargetOU -Description $x_NewGroup
}
Catch
{
	 echo $error[0]
	 exit
}

$x_Users_List | 
	%{
		$x_UserMember = ((($_ -split ",")[0]) -split "CN=")[1]
		Try 
		{
			Add-ADGroupMember -Identity $x_NewGroup -Members $x_UserMember
		}
		Catch
		{
			echo "User not added : $x_UserMember"
		}
		
	}
