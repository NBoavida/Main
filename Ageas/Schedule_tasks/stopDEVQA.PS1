<#
	.NOTES
	===========================================================================
	 Created on:   	20/10/2014 22:06
	 Created by:   	Frederico Fraz�o
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Stop DEV \ QUAL VMs

Domain: Ageasdev.com

STOP Vms

ServiceName                               Name                                                                        
-----------                               ----                                                                                                                                     
SDAZIIS01                                 SDAZIIS01                                                                                                                               
sdazsp13-01                               SDAZSP13-01                                                              
sdazsql01                                 SDAZSQL01                                                                
sdaztfs01                                 sdaztfs01                                                                
sqazsp13-01                               sqazsp13-01                                                              
wdazsp2013-01                             wdazsp2013-01                                                            
wdazvs01                                  wdazvs01                                                        
wdazvs02                                  wdazvs02                                                        
#>

 Get-AzureVM | Where-Object { $_.Name -like "sq*" -or $_.Name -like "wd*" -or $_.Name -like "sd*" -and $_.Name -notlike "sdazop01" } | select name, servicename | ForEach-Object {
       
       stop-azurevm  -ServiceName $_.Servicename -Name $_.Name  -StayProvisioned

}


