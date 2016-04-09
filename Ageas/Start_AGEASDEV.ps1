<#

.DESCRIPTION

Start Azure vms

.NOTES
	Author: Frederico Frazão
	Last Updated: 6/11/2014  
#>



workflow Start_AGEASDEV
{   

    $subName = 'Ageas'
        
    Connect-Azure `
        -AzureConnectionName $subName
        
    Select-AzureSubscription `
        -SubscriptionName $subName 
        
 Write-Output "-------------------------------------------------------------------------"
       Write-Output "Starting the Virtual Machines NOW!"

     Get-AzureVM | Where-Object { $_.Name -like "sq*" -or $_.Name -like "wd*" -or $_.Name -like "sd*" -and $_.Name -notlike "sdazop01" } | select name, servicename | ForEach-Object {
       
       start-azurevm  -ServiceName $_.Servicename -Name $_.Name  

}

           
           }

 

