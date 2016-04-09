param($p1,$p2, $p3)

Function Erro_Sintaxe
{
	param($p1)
	Write-Host "`nErro: $p1"
	Write-Host "`nSintaxe: Get-NovoCN <CN_Prefix> <Qt> <OU>"
	Write-Host "`n<CN_Prefix> : O Prefixo CN. Ex. formato:"
	Write-Host   "              FMNRAHR05W3  - Prefixo para Windows XP, local <Edifício Rua Alexandre Herculano Piso 5>"
	Write-Host   "              FMNRAHR05W7  - Prefixo para Windows  7, local <Edifício Rua Alexandre Herculano Piso 5>"
	Write-Host   "              FMNRJML02W3  - Prefixo para Windows XP, local <Edificio Av. José Malhoa - Piso 2>"
	Write-Host   "       <Qt> : Quantidade de CN's a criar"
	Write-Host   "       <OU> : Organizational Unit de destino na AD. Ex. formato:"
	Write-Host "`n  ===FM==="
	Write-Host   " WinXP            'OU=Estacoes,OU=Servicos-Centrais,OU=FM,DC=Fidelidademundial,DC=com'"
	Write-Host   " WinXP 100-A      'OU=Perfil 100-A,OU=Estacoes,OU=Servicos-Centrais,OU=FM,DC=fidelidademundial,DC=com'"
	Write-Host   " WinXP Portatil   'OU=Portateis,OU=Estacoes,OU=Servicos-Centrais,OU=FM,DC=fidelidademundial,DC=com'"
	Write-Host   " WinXP Port 100-A 'OU=Portateis 100-A,OU=Estacoes,OU=Servicos-Centrais,OU=FM,DC=fidelidademundial,DC=com'"
	Write-Host   " Win7             'OU=EstacoesW7,OU=Servicos-Centrais,OU=FM,DC=Fidelidademundial,DC=com'"
	Write-Host "`n  ===Multicare==="
	Write-Host   " WinXP            'OU=Estacoes,OU=Servicos-Centrais,OU=Multicare,DC=fidelidademundial,DC=com'"
	Write-Host   " WinXP 100-A      'OU=Perfil 100-A,OU=Estacoes,OU=Servicos-Centrais,OU=Multicare,DC=fidelidademundial,DC=com'"
	Write-Host   " Win7             'OU=EstacoesW7,OU=Servicos-Centrais,OU=Multicare,DC=Fidelidademundial,DC=com'"
	Write-Host "`n  ===ViaDirecta==="
	Write-Host   " WinXP            'OU=Estacoes,OU=Servicos-Centrais,OU=ViaDirecta,DC=fidelidademundial,DC=com'"
	Write-Host   " WinXP 100-A      'OU=Perfil 100-A,OU=Estacoes,OU=Servicos-Centrais,OU=ViaDirecta,DC=fidelidademundial,DC=com'"
	Write-Host   " WinXP Portatil   'OU=Portateis,OU=Estacoes,OU=Servicos-Centrais,OU=ViaDirecta,DC=fidelidademundial,DC=com'"
	Write-Host   " WinXP Port 100-A 'OU=Portateis 100-A,OU=Estacoes,OU=Servicos-Centrais,OU=ViaDirecta,DC=fidelidademundial,DC=com'"
	Write-Host   " Win7             'OU=EstacoesW7,OU=Servicos-Centrais,OU=ViaDirecta,DC=fidelidademundial,DC=com'"
	Write-Host "`n  ===CETRA==="
	Write-Host   " Win7             'OU=EstacoesW7,OU=Servicos-Centrais,OU=CETRA,DC=Fidelidademundial,DC=com'"
	Write-Host "`n Obs.: Para criar <Qt> CN's na <OU> da AD a partir do ultimo existente com esse prefixo."
	Write-Host   "       A <Description> do CN sera preenchida com a <Description> do ultimo CN existente com esse prefixo.`n"
	Write-Host "`nProcesso cancelado!`n"
	exit
}

cls
if ($PSBoundParameters.keys.count -eq 3)
{
	$x_CN_Prefix = $PSBoundParameters["p1"]
	$x_CN_Qt = $PSBoundParameters["p2"]
	$x_CN_OU = $PSBoundParameters["p3"]
} else
{
	Erro_Sintaxe("Faltam parametros. Ver sintaxe")
}

Write-Host   "Inicio de Processo!"

# Prefixo com 11 Caracteres
$x_Error=$true
$x_Error = $x_CN_Prefix.length -ne 11
if ($x_Error)
{
	Erro_Sintaxe("<$x_CN_Prefix> : Este prefixo CN tem menos de 11 caracteres.")
}

# Confirmar valores do Qt
$x_Error = $true
$x_Error = ($x_CN_Qt -match '^[0-9]$') -or ($x_CN_Qt -match '^[0-9][0-9]$') -or ($x_CN_Qt -match '^[0-9][0-9][0-9]$')
$x_Error = !$x_Error
if ($x_Error)
{
	Erro_Sintaxe("`n<$x_CN_Qt> : Qt introduzida nao numerica")
}
if ($x_CN_Qt -le 0)
{
	Erro_Sintaxe("`n<$x_CN_Qt> : Qt introduzida igual a zero")
}

# Confirmar OU
$x_Error = $true
try{
	$x_Error = !([adsi]::Exists("LDAP://$x_CN_OU"))
}
catch{
	$x_Error = $true
}
if ($x_Error)
{
	Erro_Sintaxe("`n<$x_CN_OU> : OU nao existe na AD.")
}

# Ler todos os CN's da AD
$x_Prefix_Existentes = (Get-ADComputer -filter *).name | where {($_.StartsWith("FMN"))} | sort | group {$_.substring(0,11)}

# Validar último numero do CN
$x_Error = $true
$x_UltNum = $null
$x_UltNum = $x_Prefix_Existentes | where {$_.name -contains $x_CN_Prefix}

if ($x_UltNum -eq $null)
{
	if ((read-host "Confirma a criacao dos CN's para este novo prefixo <$x_CN_Prefix> (S/N)?").tolower() -eq "s")
	{
		$x_UltNum="000"
		$x_CN_Description = read-host "Introduza nova Description para os CN's"
	} else
	{
		Erro_Sintaxe("`n<$x_CN_Prefix> : Prefixo novo introduzido por engano!")
	}
} else
{
	$x_UltNum = ($x_UltNum.group | sort -descending | select -first 1).substring(11,3) 
}

$x_Error = !($x_UltNum -match '^[0-9][0-9][0-9]$')
if ($x_Error)
{
	Erro_Sintaxe("`n<$x_UltNum> : Ultimo numero encontrado para este prefixo nao numerico")
}

$x_UltNum = [int]$x_UltNum
$x_CN_Ini = $x_CN_Prefix + ($x_UltNum+1).tostring("000")
$x_CN_Fim = $x_CN_Prefix + ($x_UltNum+$x_CN_Qt).tostring("000")
if ($x_UltNum -ne "000")
{
	$x_CN_Ref = $x_CN_Prefix + ($x_UltNum).tostring("000")
	$x_CN_Description = (Get-ADComputer  $x_CN_Ref -properties *).description
} 

write-host "`n=== Novos CN's gerados ==="
write-host   "         OU: <$x_CN_OU>"
write-host   "Description: <$x_CN_Description>"
write-host   "         Qt: <$x_CN_Qt>"
write-host   "      Desde: <$x_CN_Ini>"
write-host   "        Ate: <$x_CN_Fim>`n"

$x_HoraBackup = (Get-Date -format "yyyyMMddHHmm") + "_" + (get-random)
$x_CurrentUser = [Environment]::UserName
$x_File="Add_CN_" + $x_HoraBackup + "_" + $x_CurrentUser
$x_LogFile = "D:\Scripts\AD\Add_CN\" + $x_File + ".Log"
$x_OutFileCSV="D:\Scripts\AD\Add_CN\" + $x_File +  ".csv"

$x_Colunas = 	"Date" +
				"`t" +
				"LogFile" +
				"`t" +
				"Acao" +
				"`t" +
				"CN" +
				"`t" +
				"Description" 

Function Main_Proc
{
	$x_Colunas > $x_OutFileCSV
	$x_ind=1
	While ($x_ind -le $x_CN_Qt)
	 {
		$x_CN_Actual = $x_CN_Prefix + ($x_UltNum+$x_ind).tostring("000")

		New-ADComputer -Name $x_CN_Actual -Path $x_CN_OU -Enabled $true -Description $x_CN_Description

		$x_Detalhe = 	(Get-Date -format "yyyy-MM-dd HH:mm") +
						"`t" + 
						"$x_File" + 
						"`t" + 
						"CN Criado" + 
						"`t" + 
						$x_CN_Actual + 
						"`t" + 
						$x_CN_Description
		$x_Detalhe >> $x_OutFileCSV
		$x_ind+=1
	 }
}

get-date -UFormat "Begin Script -> %c" | Out-File $x_LogFile -Force

Main_Proc 2>&1 >> $x_LogFile

get-date -UFormat "End Script -> %c" 2>&1 >> $x_LogFile
