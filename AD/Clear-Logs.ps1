param($p1)

Function Erro_Sintaxe
{
	param($p1)
	Write-Host "`nErro: $p1"
	Write-Host "`nSintaxe: .\Set-UserExpirationDate.ps1 <ExpirationDate dd-mm-aaaa>"
	Write-Host "`n<CN_Prefix> : O Prefixo CN. Ex. formato:"
	Write-Host "`nProcesso cancelado!`n"
	exit
}

cls
if ($PSBoundParameters.keys.count -eq 1)
{
	$x_ExpirationDate = $PSBoundParameters["p1"]
} else
{
	Erro_Sintaxe("Faltam parametros. Ver sintaxe")
}

Write-Host "Inicio de Processo!"
Write-Host "Expiration Date:$x_ExpirationDate"

# Testar data Valida dd/mm/yyyy
$x_Error=$true
$x_Error = $x_ExpirationDate -match "^(((((0[1-9])|(1\d)|(2[0-8]))\/((0[1-9])|(1[0-2])))|((31\/((0[13578])|(1[02])))|((29|30)\/((0[1,3-9])|(1[0-2])))))\/((20[0-9][0-9])|(19[0-9][0-9])))|((29\/02\/(19|20)(([02468][048])|([13579][26]))))$"

if ($x_Error)
{
	Erro_Sintaxe("<$x_CN_Prefix> : Este prefixo CN tem menos de 11 caracteres.")
}

$x_ExpirationDate += " 23:59:59"
# Ler todos os user's a modificar do ficheiros Set-UserExpirationDate_List.txt
$x_UsersList = Get-Content .\UserExpirationDate\Set-UserExpirationDate_List.txt
$x_HoraBackup = (Get-Date -format "yyyyMMddHHmm") + "_" + (get-random)
$x_CurrentUser = [Environment]::UserName
$x_File="Set-UserExpirationDate_Out_" + $x_HoraBackup + "_" + $x_CurrentUser
$x_LogFile = "D:\Scripts\AD\UserExpirationDate\" + $x_File + ".Log"
$x_OutFileCSV="D:\Scripts\AD\UserExpirationDate\" + $x_File +  ".csv"

$x_linha= "" | Select-Object -Property UserID, CurrentExpirationDate, SetExpirationDate

Function Main_Proc
{
	$x_UsersList | %{
					$x_linha.UserID = $_
					$x_CurUserID = Get-ADUser -Identity $_ -properties accountexpirationdate
					$x_linha.CurrentExpirationDate = $x_CurUserID.AccountExpirationDate
					$x_linha.SetExpirationDate = $x_ExpirationDate
					Set-ADUser -Identity $_ -AccountExpirationDate:$x_ExpirationDate
					Write-Host "User:$_ > Expiration Date:$x_ExpirationDate"
					$x_linha | Export-csv $x_OutFileCSV -Delimiter ";" -NoTypeinformation -append
					}
}

get-date -UFormat "Begin Script -> %c" | Out-File $x_LogFile -Force

Main_Proc 2>&1 >> $x_LogFile

get-date -UFormat "End Script -> %c" 2>&1 >> $x_LogFile
