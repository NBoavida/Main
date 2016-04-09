cls
$x_pathcsv = "D:\Scripts\AD\MemberOf\" 
Echo "================ Export Computer Name MemberOF ======================"
echo "Path BK: " $x_pathcsv 
$x_CN = Read-Host -Prompt "Introduza o CN"
$x_HoraBackup = Get-Date -format "yyyyMMdd_HHmm"
$x_CurrentUser = [Environment]::UserName
$x_pathcsv += "CN_MemberOf_" + $x_CN + "_" + $x_HoraBackup + "_" + 	$x_CurrentUser + "_" + (get-random) + ".csv"

$x_Colunas = 	"CN" +
				"`t" +
				"Group Name" +
				"`t" +
				"Group Scope" +
				"`t" +
				"Group Category" +
				"`t" +
				"Description" 
$x_Colunas > $x_pathcsv

$x_ADCN=Get-ADComputer $x_CN -properties *
$x_members=$x_ADCN.MemberOf | %{$_ -split (",")} | where {$_ -match "CN" } | %{$_ -split "CN="} | where {$_ -ne ""}

$x_members | %{
				$x_group = Get-ADGroup -Identity $_ -Properties *
				$x_Colunas = 	$x_CN +
								"`t" +
								$x_group.CN +
								"`t" +
								$x_group.Groupscope +
								"`t" +
								$x_group.groupcategory +
								"`t" +
								$x_group.Description 
				$x_Colunas >> $x_pathcsv
			  }
$x_ADCN.servicePrincipalName | sort | %{
				$x_Colunas = 	$x_CN +
								"`t" +
								$_ +
								"`t" +
								"" +
								"`t" +
								"" +
								"`t" +
								"SPN - Service Principal Name" 
				$x_Colunas >> $x_pathcsv
			  }

echo "Backup criado !"
echo $pathcsv
Echo "======================================================="
