######Remove-StorageBlobXDaysOld##### 
<# 
.SYNOPSIS 
   Remove all blob contents from one storage account that are X days old. 
.DESCRIPTION  
   This script will run through a single Azure storage account and delete all blob contents in  
   all containers, which are X days old. 
.EXAMPLE 
    Remove-StorageBlobXDaysOld -StorageAccountName "storageaccountname" -AzureConnectionName "azureconnectionname" -DaysOld 7 
#> 
workflow Remove-oldBack30days
{ 

#variaveis
               
$AzureConnectionName = 'ageas'
$StorageAccountName = 'ageasbackup'
$DaysOld = '30'
    
 
    $Start = [System.DateTime]::Now 
    "Starting: " + $Start.ToString("HH:mm:ss.ffffzzz") 
 
    Connect-Azure ` 
        -AzureConnectionName $AzureConnectionName ` 
        -StorageAccountName $StorageAccountName 
    Select-AzureSubscription -SubscriptionName $AzureConnectionName 
     
    # loop through each container and get list of blobs for each container and delete 
    $blobsremoved = 0 
    $containersremoved = 0 
    $containers = 'sql'
     
    foreach($container in $containers)  
    {  
        $blobsremovedincontainer = 0        
        Write-Output ("Searching Container: {0}" -f $container.Name)    
        $blobs = Get-AzureStorageBlob -Container $container.Name  
 
        if ($blobs -ne $null) 
        {     
            foreach ($blob in $blobs) 
            { 
               $lastModified = $blob.LastModified 
               if ($lastModified -ne $null) 
               { 
                   $blobDays = ([DateTime]::Now - [DateTime]$lastModified) 
                   Write-Output ("Blob {0} in storage for {1} days" -f $blob.Name, $blobDays)  
                
                   if ($blobDays.Days -ge $DaysOld) 
                   { 
                        Write-Output ("Removing Blob: {0}" -f $blob.Name) 
                        Remove-AzureStorageBlob -Blob $blob.Name -Container $container.Name  
                        $blobsremoved += 1 
                        $blobsremovedincontainer += 1 
                   } 
                } 
            } 
        } 
         
        $blobs = Get-AzureStorageBlob -Container $container.Name  
        if ($blobs -eq $null -or $blobs.Count -eq 0) 
        { 
            Write-Output ("Removing Blob container: {0}" -f $container.Name)  
            Remove-AzureStorageContainer -Name $container.Name -Force 
            $containersremoved += 1 
        } 
 
        Write-Output ("{0} blobs removed from container {1}." -f $blobsremovedincontainer, $container.Name)        
    } 
     
    $Finish = [System.DateTime]::Now 
    $TotalUsed = $Finish.Subtract($Start).TotalSeconds 
    
    Write-Output ("Removed {0} blobs in {1} containers in storage account {2} of subscription {3} in {4} seconds." -f $blobsRemoved, $containersremoved, $StorageAccountName, $AzureConnectionName, $TotalUsed) 
    "Finished " + $Finish.ToString("HH:mm:ss.ffffzzz") 
}  
 