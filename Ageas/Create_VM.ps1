

<#     
       .NOTES
       ===========================================================================
       Created on:        30/09/2014 
       Created by:        Frederico Frazão
       Organization:     Agap2
        Filename: CreateVM         
       ===========================================================================
       .DESCRIPTION
            . Definir 
            Storage Accont
            . ServiceName  (Cloud Service DNS público)
            . Name  (Hostname)
            . SubnetNames
            . VNetName  (network)
#>

#region Parametros de configuração da VM

<#  Storage Acconts

StorageAccountName        : portalvhdsjhkyqvhd88p4l
StorageAccountName        : storagecqfrontend
StorageAccountName        : storagedevdata
StorageAccountName        : storagedevfrontend
StorageAccountName        : storagedevinfra
StorageAccountName        : storagedevwrks
StorageAccountName        : storagedrp
StorageAccountName        : storagenetdata
StorageAccountName        : storagenetfront
StorageAccountName        : storagenetinfra

#>

#Set Storage Account 
$Storage = "storagedevwrks"

#Select OS _Windows-Server-2012-R2

$OS = “a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201408.01-en.us-127GB.vhd”

#Set Cloud Service 
$ServiceName = 'TestJTMPS'
#set Vm name
$name = 'TestjajajPS'

<#
Subnets: 
Frontend
Application
Data
Development
Infrastructure
Management
#>

#Set Subnet 
$SubnetNames = 'Development'
<#
NEtworks:
PROD. VNET01_GTW_PRD
DEV\QUAl: vnet02_dev_cq 
#>
$VNetName = 'vnet02_dev_cq'

#local Admin Password
$p = '!!!!!!!!!!!!!!!!!'
#endregion


#region Create VM (não alterar)

#Set Default Storage Accont 
Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount $Storage



#CreateVM 
New-AzureQuickVM -Windows -ServiceName $ServiceName -Name $name -InstanceSize Small -ImageName $OS -AdminUsername adminazdoit -Password $p –Location “West Europe” -SubnetNames $SubnetNames -VNetName $VNetName


#endregion


