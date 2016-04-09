<#     
       .NOTES
       ===========================================================================
       Created by:        Frederico Frazão
       Organization:     Agap2
        Filename: Create SQL Cluster server (OS)
       ===========================================================================
       .DESCRIPTION
Cria 3 Vms (2 sql + FS )
#>

Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount "storagedevdata"

Set-AzureStorageAccount -StorageAccountName storagedevdata



# Location/cloud service/vnet name for the virtual machines
$location = "West Europe"
$serviceName = "ageasdev"
$vnet = "vnet02_dev_cq"
 
         
 

 
 
 

# Static IPs are not a requirement - I just like them :) 
$vm1 = New-AzureVMConfig -ImageName "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201408.01-en.us-127GB.vhd" -Name "SDAZSQL02"  -InstanceSize Large |
        Add-AzureProvisioningConfig -Windows -AdminUsername adminazdoit -Password ageasaz2014! | 
        Set-AzureSubnet -SubnetNames "Data" | 
        Set-AzureStaticVNetIP -IPAddress "10.108.82.5" |
       Add-AzureDataDisk -CreateNew -DiskSizeInGB 250 -DiskLabel "SQL_DATA" -LUN 0 `

 

$vm2 = New-AzureVMConfig -ImageName "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201408.01-en.us-127GB.vhd" -Name "SDAZSQL03"  -InstanceSize Large |
        Add-AzureProvisioningConfig -Windows -AdminUsername adminazdoit -Password ageasaz2014! | 
        Set-AzureSubnet -SubnetNames "Data" | 
        Set-AzureStaticVNetIP -IPAddress "10.108.82.6" |
        Add-AzureDataDisk -CreateNew -DiskSizeInGB 250 -DiskLabel "SQL_DATA" -LUN 0 



$vm3 = New-AzureVMConfig -ImageName "a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201408.01-en.us-127GB.vhd" -Name "SDAZFS01"  -InstanceSize Large |
        Add-AzureProvisioningConfig -Windows -AdminUsername adminazdoit -Password ageasaz2014! | 
        Set-AzureSubnet -SubnetNames "Infrastructure" | 
        Set-AzureStaticVNetIP -IPAddress "10.108.95.222" |
        Add-AzureDataDisk -CreateNew -DiskSizeInGB 1000 -DiskLabel "DATA" -LUN 0 

 
# Create the virtual machines in the virtual network 
New-AzureVM -ServiceName $serviceName `
            -Location $location `
            -VNetName $vnet `
            -VMs $vm1, $vm2, $vm3 `
     