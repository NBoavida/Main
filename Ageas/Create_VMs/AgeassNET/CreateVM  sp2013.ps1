

<#     
       .NOTES
       ===========================================================================
       Created on:        30/09/2014 
       Created by:        Frederico Frazão
       Organization:     Agap2
        Filename: CreateVM sp2013
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
$Storage = "storagenetfront"

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
$OS = “SPAZSQL02”

#Set Cloud Service
$ServiceName = 'spageasfe'
#set Vm name
$name = 'spazsp2013-02'

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
$SubnetNames = 'Frontend'
<#
NEtworks:
PROD. VNET01_GTW_PRD
DEV\QUAl: vnet02_dev_cq 
#>
$VNetName = 'VNET01_GTW_PRD'

#local Admin Password
$p = 'Locald0i7adm!'
#endregion


#region Create VM (não alterar)

#Set Default Storage Accont
Set-AzureSubscription -SubscriptionName "AGEAS" -CurrentStorageAccount $Storage



#CreateVM
New-AzureQuickVM -Windows -ServiceName $ServiceName -Name $name -InstanceSize Small -ImageName $OS -AdminUsername adminazdoit -Password $p –Location “West Europe” -SubnetNames $SubnetNames -VNetName $VNetName


#endregion


