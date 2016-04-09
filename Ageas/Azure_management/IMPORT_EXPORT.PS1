

#Export-AzureVM -ServiceName wdazvs01 -Name wdazvs01 -Path "C:\Vms_export\wdazvs01.xml"

Remove-AzureVM -ServiceName wdazvs01  -Name wdazvs01

#mudar de St Accont
Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount "storagedevwrks"

#validar os settings de Storage 
 Get-AzureSubscription

 ## EDIT XML com a Subnet 
 # at portal cloud services remover o cloud service 


 Import-AzureVM -Path 'C:\Vms_export\wdazvs01.xml' | New-AzureVM -ServiceName 'wdazvs01' -Location 'West Europe' -VNetName 'vnet02_dev_cq'