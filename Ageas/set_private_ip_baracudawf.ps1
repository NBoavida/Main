<#	
	.NOTES
	===========================================================================
	 Created on:   	20/10/2014 22:06
	 Created by:   	Frederico Frazão
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Set Private IP Barracuda
#>


get-azurevm -Servicename 	ageasfw 	-Name	spazfw01 | Set-AzureStaticVNetIP -IPAddress "10.108.64.7"  | Update-AzureVM   



