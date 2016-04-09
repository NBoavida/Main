<#

.DESCRIPTION

Stop agead dev Azure vms

.NOTES
	Author: Frederico Frazão
	Last Updated: 6/11/2014  
#>

workflow stop_AGEASDEV_desprovisionado
{   
 
    $subName = 'Ageas'
        
    Connect-Azure `
        -AzureConnectionName $subName
        
    Select-AzureSubscription `
        -SubscriptionName $subName 

 Write-Output "-------------------------------------------------------------------------"
       Write-Output "Stopping the Virtual Machines NOW!"

      
        $StopOutPut =  Get-AzureVM | Where-Object { $_.Name -like "sq*" -or $_.Name -like "wd*" -or $_.Name -like "sd*" -and $_.Name -notlike "sdazop01" -and $_.Name -notlike "SDAZIIS01"  } | select name, servicename | ForEach-Object {
       
       stop-azurevm  -ServiceName $_.Servicename -Name $_.Name  -StayProvisioned

}

		
        
		Write-Output $StopOutPut
           
           }

