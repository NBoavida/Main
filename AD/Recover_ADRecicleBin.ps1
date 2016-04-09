# Este script pode receber um parametro SAMAccountName para recuperar do ADRecycleBin
# Sintax:
# 	PS D:\Scripts\AD> .\Recover_ADRecicleBin.ps1 [parametro]
#
#	<parametro>
#		<SAMAccountName>		>> Vai tentar recuperar essa SAMAccountName do RecycleBin
#		<vazio>					>> Pede SAMAccountName

#	Verificar parametros de entrada
param($p1)
cls

if ($PSBoundParameters.keys.count -gt 0)
{
	$x_SAMAccountName = $PSBoundParameters["p1"]
}else
{
	$x_SAMAccountName = Read-Host 'Qual o nome objecto a recuperar?'
}

if ($x_SAMAccountName -eq $null -or $x_SAMAccountName -le "      " )
{
	Write-Host "`nÉ necessário indicar um objecto a recuperar."
	exit
}

$x_Obj_Recuperado = Get-ADObject -Filter {sAMAccountName -eq $x_SAMAccountName} -IncludeDeletedObjects -properties "Description"
if ($x_Obj_Recuperado -eq $null)
{
	Write-Host "`nObjecto a recuperar: <" $x_SAMAccountName "> não existe na ADRecycleBin"
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
	Get-ADObject -Filter {sAMAccountName -eq $x_SAMAccountName} -IncludeDeletedObjects | Restore-ADObject
	Write-Host "`nObjecto <" $x_SAMAccountName "> recuperado com sucesso."
	$x_HoraBackup = Get-Date -format "yyyyMMdd_HHmm"
	$x_CurrentUser = [Environment]::UserName
	$x_PathFich = 	"D:\Scripts\AD\Recover_ADRecicleBin\" + $x_SAMAccountName + "_" + "Recover_ADRecicleBin_" + 
					$x_HoraBackup + "_" + $x_CurrentUser + ".txt"
	$x_Obj_Recuperado > $x_PathFich
} else
{
	Write-Host "`nObjecto <" $x_SAMAccountName "> NÃO recuperado."
}
Write-Host "Processo terminado !`n"