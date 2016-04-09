
$Storage = "portalvhdsjhkyqvhd88p4l"

$OS = “wdazsp2013-01”

#Set Cloud Service
$ServiceName = 'ageasdev'
#set Vm name
$name = 'wdazsp2013-02'



#Set Subnet
$SubnetNames = 'Development'

#>
$VNetName = 'vnet02_dev_cq'



#region Create VM (não alterar)

#Set Default Storage Accont
Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount $Storage



#CreateVM Specialized 
New-AzureQuickVM -Windows -ServiceName $ServiceName -Name $name -InstanceSize Large  -ImageName $OS  -SubnetNames $SubnetNames -VNetName $VNetName




#endregion


