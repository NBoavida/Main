<#	
	.NOTES
	===========================================================================
	 Created on:   	09/10/2014 18:44
	 Created by:   	Frederico Frazão
	 Organization: 	
	 Filename:     	Remove_Azure_ILB.ps1
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>



$svc = "hanetsql01"
$vmname = "SPAZSQL02"
$epname = "DBTIER2"
Get-AzureVM -ServiceName $svc -Name $vmname | Remove-AzureEndpoint -Name $epname | Update-AzureVM

$vmname1 = "SPAZSQL01"
$epname2 = "DBTIER1"
Get-AzureVM -ServiceName $svc -Name $vmname1 | Remove-AzureEndpoint -Name $epname | Update-AzureVM

$svc = "hanetsql01"
Remove-AzureInternalLoadBalancer -ServiceName $svc