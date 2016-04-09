# Este script pode receber um parametro OU para List do ADRecycleBin
# Sintax:
# 	PS D:\Scripts\AD> .\Recover_ADRecicleBin.ps1 [parametro]
#
#	<parametro>
#		<OU>					>> Vai Listar essa OU do RecycleBin
#		<vazio>					>> Pede OU

#	Verificar parametros de entrada
param($p1)
cls

if ($PSBoundParameters.keys.count -gt 0)
{
	$x_OULastKnown = $PSBoundParameters["p1"]
}else
{
	$x_OULastKnown = Read-Host 'Qual a última OU conhecida onde estava o objecto a recuperar?'
}

if ($x_OULastKnown -eq $null -or $x_OULastKnown -le "      " )
{
	Write-Host "`nÉ necessário indicar OU conhecida onde estava o objecto a recuperar."
	exit
}

$x_Obj_Recuperado = Get-ADObject -Filter {sAMAccountName -eq $x_OULastKnown} -IncludeDeletedObjects -properties "Description"
if ($x_Obj_Recuperado -eq $null)
{
	Write-Host "`nNão existem objectos a recuperar da OU: <" $x_OULastKnown "> na ADRecycleBin"
	Write-Host "Processo terminado !"
	exit
	} else
{
	Write-Host "`nObjecto a recuperar:`n"
	#Write-Host $x_Obj_Recuperado "`n"
	$x_Obj_Recuperado | fl 
}

if ( ('S' , 'S' ) -contains (Read-Host 'Confirma recuperação deste objeto (S/N)?'))
{
	Get-ADObject -Filter {sAMAccountName -eq $x_OULastKnown} -IncludeDeletedObjects | Restore-ADObject
	Write-Host "`nObjecto <" $x_OULastKnown "> recuperado com sucesso."
	$x_HoraBackup = Get-Date -format "yyyyMMdd_HHmm"
	$x_CurrentUser = [Environment]::UserName
	$x_PathFich = 	"D:\Scripts\AD\Recover_ADRecicleBin\" + $x_OULastKnown + "_" + "Recover_ADRecicleBin_" + 
					$x_HoraBackup + "_" + $x_CurrentUser + ".txt"
	$x_Obj_Recuperado > $x_PathFich
} else
{
	Write-Host "`nObjecto <" $x_OULastKnown "> NÃO recuperado."
}
Write-Host "Processo terminado !`n"