#Migrar vms para DRP

Select-AzureSubscription AGEAS

# VHD da VM
$vmvhd = "spazfw02-os-2015-01-19.vhd" 
#$vmvhd = "ageasfw-spazfw02-0-201412311507410865"
$SourceStorage = "storagedevfrontend"
$Key11 = "fXlH8mzrSCf6zDwSuq2hfFp9lyXXynZ0/q+fBK9hI3fh/a0dwNwGM78zb0ECaWWRQRehjaO+UrqIe8I3ZnMaCQ=="
$sourceContext = New-AzureStorageContext –StorageAccountName $SourceStorage -StorageAccountKey $Key1  
$SC = "vhds"
$DestinationStorage = "ageasdrp"
$Key2 = "v2qBQ0c62FbjORRjFbrBsWcx6u8CraGY2tPsFLinsE+PXYG9gU63Wu/HKRclz+qEh2OVI1YtG+6+H++hmbjnaA=="
$destinationContext = New-AzureStorageContext –StorageAccountName $DestinationStorage -StorageAccountKey $Key2

$destinationContainer = "mig"
New-AzureStorageContainer -Name $destinationContainer -Context $destinationContext 

 
$Mig = Start-AzureStorageBlobCopy -DestContainer $destinationContainer `
                        -DestContext $destinationContext `
                        -SrcBlob $vmvhd `
                        -Context $sourceContext `
                        -SrcContainer $SC

                        while(($Mig | Get-AzureStorageBlobCopyState).Status -eq "Pending")
{
    Start-Sleep -s 15
    $Mig | Get-AzureStorageBlobCopyState
}

echo " $vmvhd foi copiado para O Storage $DestinationStorage, no container mig com Sucesso "