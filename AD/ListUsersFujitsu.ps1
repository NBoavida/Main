param($p1)

import-module activedirectory  
$x_HoraBackup = Get-Date -format "yyyyMMddHHmm"
$x_CurrentUser = [Environment]::UserName
$x_PathFich = "D:\Scripts\AD\Fujitsu\ListUsersFujitsu_" + $x_HoraBackup + "_" + $x_CurrentUser + ".csv"

if ($PSBoundParameters.keys.count -ne 1)
{
	Write-Host "`nSintaxe correcta:`n.\ListUsersFujitsu.ps1 1Semestre|2Semestre`n"
	exit
} else {
	$x_Semestre=$p1.ToUpper()
	if ($x_Semestre -ne "1SEMESTRE" -and $x_Semestre -ne "2SEMESTRE")
	{
		Write-Host "`nSintaxe correcta:`n.\ListUsersFujitsu.ps1 1Semestre|2Semestre`n"
		exit
	} else {
		"FILTRO: $x_Semestre;`n" | Out-File $x_PathFich
	}
}

if ($x_Semestre -eq "1SEMESTRE")
{
	$x_Data_Analise = [DateTime]([String]((Date).Year - 1) + "-12-18")
} else {
	$x_Data_Analise = [DateTime]([String]((Date).Year) + "-06-18")
}

# Filtro excluidos e motivo
$x_Excluir_Report = @{
				"FCS"									= "Objecto Sistema/Testes"
				"Users"									= "Objecto Sistema/Testes"
				"OU Testes GPO"							= "Objecto Sistema/Testes"
				"Microsoft Exchange System Objects"		= "Objecto Sistema/Testes"
				"GEP"									= "Filtro Procedimento: User's OU=GEP"
				"SSI"									= "Filtro Procedimento: User's OU=SSI"
				"Servicos-Transversais"					= "Filtro Procedimento: User's OU=Servicos-Transversais"
				"Mediadores"							= "Filtro Procedimento: User's OU=Mediadores externos"
				"HDK"									= "Filtro Procedimento: User's OU=HDK Fujitsu"
				"IBM"									= "Filtro Procedimento: User's Company=IBM afetos XSource"
				}
				
# Get all AD computers  
#$x_Total_Users = Get-ADUser -Filter * -Properties * -ResultSetSize $null |  
$x_Total_Users = Get-ADUser -Filter * -Properties * -ResultSetSize $null | 
select-object @{Name="Report"; Expression={$True}}, @{Name="Motivo"; Expression = {" "}}, @{Name="Empresa"; Expression = {" "}}, 
				SamAccountName, DisplayName, Name, Department, Company, Description, Enabled, CanonicalName, 
				@{Name="LastLogonDate"; Expression={[DateTime]::FromFileTime($_.lastLogonTimestamp)}} 

$x_Total_Users | 
	%{
		$x_User_DIN = $False
		$x_User_Mediadores = $False
		$x_A_Pesquisar = "ERRO"
#	Identifica a empresa por OU
		$x_Empresa = ($_.CanonicalName -split("/",3))[1]	
		$x_A_Pesquisar = $x_Empresa 
		$x_TempOU2 = ($_.CanonicalName -split("/",6))[4]
		Switch ($x_TempOU2)
		{
		"GEP" 
			{
			$x_Empresa = "GEP"
			$x_A_Pesquisar = "GEP"
			}
		"SAFEMODE"
			{
			$x_Empresa = "Safemode"
			}
		"DIN"
			{
			$x_User_DIN = $True
			}
		"Mediadores"
			{
			$x_A_Pesquisar = "Mediadores"
			}
		"HDK"
			{
			$x_A_Pesquisar = "HDK"
			}
		"SSI"
			{
			$x_A_Pesquisar = "SSI"
			}
		}
		$_.Empresa = $x_Empresa 

# 	Identifica OU
		$x_TempOU2 = ($_.CanonicalName -split("/",6))[2]
		Switch ($x_TempOU2)
		{
		"Servicos-Transversais" 
			{
			$x_A_Pesquisar="Servicos-Transversais"
			}
		}		

# 	Identifica Company
		Switch ($_.Company)
		{
		"IBM" 
			{
			$x_A_Pesquisar="IBM"
			}
		}
		
# Pesquisa filtro do Report
		if ($x_Excluir_Report.Contains($x_A_Pesquisar))
		{
			$_.Report = $False
			$_.Motivo = $x_Excluir_Report[$x_A_Pesquisar]
		}

#	Exlusões Users estrangeiros menos Espanha		
		if	($x_User_DIN -and
			!($_.SamAccountName.ToUpper().StartsWith("ESP")) -and 
			!($_.SamAccountName.ToUpper().StartsWith("F")))
		{
			$_.Report = $False
			$_.Motivo = "Filtro Procedimento: User's Estrangeiro (nao Espanha)"
		}

#	Exlusões Users funcionais/Mailbox equipa/Serviços		
		if	($_.SamAccountName.ToUpper().StartsWith("Y"))
		{
			$_.Report = $False
			$_.Motivo = "Filtro Procedimento: User's Funcionais/Mailbox Equipa/Servicos"
		}

#	Exlusões Users Provisorios		
		if	($_.SamAccountName.ToUpper().StartsWith("ADM") -or
			 $_.SamAccountName.ToUpper().StartsWith("AUDIT") -or
			 $_.SamAccountName.ToUpper().StartsWith("ADV") -or
			 $_.SamAccountName.ToUpper().StartsWith("CONSULT"))		 
		{
			$_.Report = $False
			$_.Motivo = "Filtro Procedimento: User's Provisorios/Teste/Genericos"
		}

#	Exlusões Users genéricos
		$x_SamAccountName = $_.SamAccountName.ToUpper()
		if	($x_SamAccountName.Contains("TESTE") -or
			 $x_SamAccountName.Contains("TST") -or
			 $x_SamAccountName.Contains("USER") -or
			 $x_SamAccountName.Contains("USR"))
		{
			$_.Report = $False
			$_.Motivo = "Filtro Procedimento: User's Provisorios/Teste/Genericos"
		}

#	Verifica ultimo login

		if ($_.LastLogonDate -lt $x_Data_Analise)
		{
			$_.Report = $False
			$_.Motivo = "Filtro Procedimento: Last Login anterior ao semestre seleccionado"			
		}
		
		return $_;
	} | sort -property @{Expression="Report";Descending=$true}, @{Expression="Empresa";Descending=$false}, @{Expression="SamAccountName";Descending=$false} | 
		ConvertTo-Csv -Delimiter "`t" -NoTypeInformation |
		Out-File $x_PathFich -Encoding unicode -Append
#    Export-CSV -path $x_PathFich -Delimiter "`t" -Encoding unicode -NoTypeInformation 
	
