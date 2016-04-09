#mudar de St Accont
Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount "storagenetinfra"

#validar os settings de Storage 
 Get-AzureSubscription


 Import-AzureVM -Path 'C:\Vms_export\AD-AGEASNET.xml' | New-AzureVM -ServiceName 'AGEAS-NET-DC' -Location 'West Europe' -VNetName 'vnet02_dev_cq'