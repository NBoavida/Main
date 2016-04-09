# Author: Rafael Duarte
# Purpose: Export Local Group Administrators and Remote Destop User's

$LocalAdminGroup = "Administrators"
$LocalRDPGroup = "Remote Desktop Users"
$x_PathFich = "D:\Scripts\AD\CNInfo\CNInfo.csv"

# uncomment this line to grab list of computers from a file
$Workstations = Get-Content CNInfo.txt
#$Workstations = $env:computername # for testing on local computer
#$Workstations = "FMNRJML02W3020" # for testing on a computer
#$Workstations = "FMNRAHR06W3105" # for testing on a computer
#$Workstations = Get-ADComputer -filter 'Name -like "FMN*"' -ResultSetSize 10 | select name | sort | %{$_.name}
#$Workstations = Get-ADComputer -filter 'Name -like "FMN*"' | select name | sort | %{$_.name}
$TotalCN= $Workstations.count
$AtualCN= 0

$Report = "Seq`tData`tWorkstation`tUserId_GroupName`tLocalGroup"
$Report | Out-File $x_PathFich -Encoding unicode
	
foreach ( $Workstation in $Workstations ) {
	$AtualCN+=1
	echo "$AtualCN - $TotalCN : <$Workstation>"
	$MemberAdminNames = @()
	$MemberRDPNames = @()
	$CNDesligado = $False
	$GroupAdmin = [ADSI]"WinNT://$Workstation/$LocalAdminGroup,group"
	
	Try {
		$MembersAdmin = @($GroupAdmin.psbase.Invoke("Members"))
		$MembersAdmin | ForEach-Object {
			$MemberAdminNames += $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
		} 
		
		$GroupRDP= [ADSI]"WinNT://$Workstation/$LocalRDPGroup,group"
		$MembersRDP = @($GroupRDP.psbase.Invoke("Members"))
		$MembersRDP | ForEach-Object {
			$MemberRDPNames += $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
		} 
	} Catch {
		$CNDesligado=$True
	}
	
	if ($CNDesligado)
	{
		$Report="$AtualCN`t" + (Get-Date -format "yyyy/MM/dd HH:mm") + "`t$Workstation`t<Desligado>`t"
		$Report | Out-File $x_PathFich -Encoding unicode -append
		$Report=""
	} else
	{
		$MemberAdminNames | ForEach-Object {
			$Report="$AtualCN`t" + (Get-Date -format "yyyy/MM/dd HH:mm") + "`t$Workstation`t$_`t$LocalAdminGroup"
			$Report | Out-File $x_PathFich -Encoding unicode -append
		}
		$MemberRDPNames | ForEach-Object {
			$Report="$AtualCN`t" + (Get-Date -format "yyyy/MM/dd HH:mm") + "`t$Workstation`t$_`t$LocalRDPGroup"
			$Report | Out-File $x_PathFich -Encoding unicode -append
		}
		$Report=""
	}
}

