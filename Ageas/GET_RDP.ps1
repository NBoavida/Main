<#
	.NOTES
	===========================================================================
	 Created on:   	20/10/2014 22:06
	 Created by:   	Frederico Frazão
	 Organization: 	
	 Filename:     	
	===========================================================================
	.DESCRIPTION
		Get Vms RDp File
                                                      
#>

 Get-AzureVM |  select name, servicename | ForEach-Object {
       
       Get-AzureRemoteDesktopFile -ServiceName csiis01 -Name spaziis02 

}



