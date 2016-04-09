Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount "storagenetfront"

# Location/cloud service/vnet name for the virtual machines
$location = "West Europe"
$serviceName = "spageasfe"
$vnet = "vnet01_gtw_prd"
 
# Configure the image name 
$imageFamily = "c6e0f177abd8496e934234bd27f46c5d__SharePoint-2013-Trial-7-14-2014"
$imageName = Get-AzureVMImage |
                 where { $_.ImageFamily -eq $imageFamily } |
                 sort PublishedDate -Descending |
                 select -ExpandProperty ImageName -First 1 
 

 
 
# Create the internal load balancer configuration 
$ilbConfig = New-AzureInternalLoadBalancerConfig -InternalLoadBalancerName "spageasfe" `
                                    -StaticVNetIPAddress "10.108.64.4" `
                                    -SubnetName "Frontend"
 
 
# Create the VM configuration. Must be on the same subnet as the ILB.
# Add-AzureEndpoint must specify the name of the internal load-balancer
# Static IPs are not a requirement - I just like them :) 
$vm1 = New-AzureVMConfig -ImageName "c6e0f177abd8496e934234bd27f46c5d__SharePoint-2013-Trial-7-14-2014" -Name "SPAZSP2013-01" -InstanceSize ExtraLarge |
        Add-AzureProvisioningConfig -Windows -AdminUsername adminazdoit -Password Locald0i7adm! | 
        Set-AzureSubnet -SubnetNames "Frontend" | 
        Set-AzureStaticVNetIP -IPAddress "10.108.64.5" |
        Add-AzureEndpoint -Name "web" -Protocol tcp -LocalPort 80 `
                          -PublicPort 80 -LBSetName "sp2013lbset" `
                          -InternalLoadBalancerName "spageasfe" `
                          -DefaultProbe 
 
 
$vm2 = New-AzureVMConfig -ImageName "c6e0f177abd8496e934234bd27f46c5d__SharePoint-2013-Trial-7-14-2014" -Name "SPAZSP2013-02" -InstanceSize ExtraLarge |
        Add-AzureProvisioningConfig -Windows -AdminUsername adminazdoit -Password Locald0i7adm! | 
        Set-AzureSubnet -SubnetNames "Frontend" | 
        Set-AzureStaticVNetIP -IPAddress "10.108.64.6" |
        Add-AzureEndpoint -Name "web" -Protocol tcp -LocalPort 80 `
                          -PublicPort 80 -LBSetName "sp2013lbset" `
                          -InternalLoadBalancerName "spageasfe" `
                          -DefaultProbe  
 
# Create the virtual machines in the virtual network and specify the ILB config 
New-AzureVM -ServiceName $serviceName `
            -Location $location `
            -VNetName $vnet `
            -VMs $vm1, $vm2 `
            -InternalLoadBalancerConfig $ilbConfig