

<#     
       .NOTES
       ===========================================================================
       Created on:        30/09/2014 
       Created by:        Frederico Frazão
       Organization:     Agap2
        Filename: CreateVM Windows 2012
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
$Storage = "portalvhdsjhkyqvhd88p4l"

#Select OS _Windows-Server-2012-R2
<#
sdazsp13-01                                                 sdazsp13-01
SDAZSQL01                                                   SDAZSQL01
spazsp2013-02                                               spazsp2013-02
spazsql01                                                   spazsql01
SPAZSQL02                                                   SPAZSQL02
SQL2012R2SP1_INSt12                                         SQL2012R2SP1_INSt12
TFS2013UPD2                                                 TFS2013UPD2
WD SP2013 SQL VS2013                                        WD_SP2013_SQL_VS2013
WD_VS_2013                                                  WD_VS_2013
default azure w2012 r2 a699494373c04fc0bc8f2bb1389d6106__Windows-Server-2012-R2-201408.01-en.us-127GB.vhd
#>
$OS = “c6e0f177abd8496e934234bd27f46c5d__SharePoint-2013-Trial-7-14-2014"

#Set Cloud Service
$ServiceName = 'ageasdev'
#set Vm name
$name = 'wdazsp2013-02'

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
$p = 'ageasaz2014!'
#endregion


#region Create VM (não alterar)

#Set Default Storage Accont
Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount $Storage



#CreateVM
New-AzureQuickVM -Windows -ServiceName $ServiceName -Name $name -InstanceSize Large  -ImageName $OS -AdminUsername adminazdoit -Password $p  -SubnetNames $SubnetNames -VNetName $VNetName


#endregion


