$pass= Get-Content c:\Windows\System32\sql.ocx

net use k: /del  

net use k: \\172.16.120.239\f$\SQLBackups\Azure_prd /user:bcpcorp.dev\d333867 $pass



 #region Histórico de Backups
$Now = Get-Date
$Days = "30" 
$Dayslocal = "1" 
$Extension = "*.bak" 
$LastWrite = $Now.AddDays(-$Days) 
$LastWritelocal = $Now.AddDays(-$Dayslocal) 
#endregion

# superior a 30 dias para apagar

New-AzureStorageContext -StorageAccountName ageasbackup -StorageAccountKey o5UnaTDZV34kzCMtFuvsqJ98+5s6RwiHH756V0Vy5OSKLjdaixLFh7xEx0NRMkv3oDqoc/8Z0KddrzrZ00hshQ== |  Get-AzureStorageBlob -Container sql | Where {$_.LastModified  -lt "$LastWrite"} | Remove-AzureStorageBlob -Force
#| Get-AzureStorageBlobContent -Destination D:\SQL



# copia local desde storage ultimos 1 dias 
 New-AzureStorageContext -StorageAccountName ageasbackup -StorageAccountKey o5UnaTDZV34kzCMtFuvsqJ98+5s6RwiHH756V0Vy5OSKLjdaixLFh7xEx0NRMkv3oDqoc/8Z0KddrzrZ00hshQ== |  Get-AzureStorageBlob -Container sql |Where-Object { $_.LastModified -gt "$LastWritelocal" } | Get-AzureStorageBlobContent -Destination K:\SQL


