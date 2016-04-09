$DestContainerName = "backupvms" 

#region storagenetinfra
# Destination Storage Account name 
$DestStorageAccountName = 'storagenetinfra'

# Destination Storage Account Key 
$DestStorageAccountKey = 'alYyE/EyXap3iRWuuocSWXi7DhekglhScnKBSPJ68FInSkKa4iGql3Eg9RewRQX29GSphKz1lhphmuqavnY6kw=='
	
Set-StrictMode -Version 3
		

		$VerbosePreference = "Continue"
		

		if ((Get-Module -ListAvailable Azure) -eq $null)
		{
    		throw "Windows Azure Powershell not found! Please install from http://www.windowsazure.com/en-us/downloads/#cmd-line-tools"
		}
		

		$azureDisks = Get-AzureDisk
		
		$tempStorageContainerAccounts = @{}

		$tempStorageContainerName = "pstmp" + [DateTime]::UtcNow.Ticks
		$tempCopyStates = @()
		foreach ($azureDisk in $azureDisks)
		{
    		$src = $azureDisk.MediaLink
    		$vhdName = $azureDisk.MediaLink.Segments | Where-Object { $_ -like "*.vhd" }
		
    		if ($vhdName -ne $null)
    		{
        		$srcStorageAccount = $src.Host.Replace(".blob.core.windows.net", "") 
        		$srcStorageAccountKey = (Get-AzureStorageKey -StorageAccountName $srcStorageAccount).Primary
		
        		$srcContext = New-AzureStorageContext -StorageAccountName $srcStorageAccount -StorageAccountKey $srcStorageAccountKey
        		if ((Get-AzureStorageContainer -Name $tempStorageContainerName -Context $srcContext -ErrorAction SilentlyContinue) -eq $null)
        		{
            		Write-Verbose "Creating container '$tempStorageContainerName'."
            		New-AzureStorageContainer -Name $tempStorageContainerName -Context $srcContext
        		}
		

        		$tempCopyState = Start-AzureStorageBlobCopy -Context $srcContext -SrcUri $src `
                             -DestContext $srcContext -DestContainer $tempStorageContainerName `
                             -DestBlob $vhdName 
        		$tempCopyStates += $tempCopyState
		

        		if (($tempStorageContainerAccounts[$srcStorageAccount]) -eq $null)
        		{
            		$tempStorageContainerAccounts[$srcStorageAccount] = $srcContext
        		}
    		}
		}
		

		foreach ($copyState in $tempCopyStates)
		{

    		$copyState | 
        		Get-AzureStorageBlobCopyState -WaitForComplete | 
            		Format-Table -AutoSize -Property Status,BytesCopied,TotalBytes,Source
		}
		
		

		$destContext = New-AzureStorageContext –StorageAccountName $DestStorageAccountName  -StorageAccountKey $DestStorageAccountKey
		if ((Get-AzureStorageContainer -Name $DestContainerName -Context $destContext -ErrorAction SilentlyContinue) -eq $null)
		{
    		Write-Verbose ("Creating container '{0}' in destination storage account '{1}'." -f $DestContainerName, $DestStorageAccountName)
    		New-AzureStorageContainer -Name $DestContainerName -Context $destContext
		}
		

		$destCopyStates = @()
		foreach ($item in $tempStorageContainerAccounts.GetEnumerator())
		{
    		$srcContext = $item.Value
    		Get-AzureStorageBlob -Container $tempStorageContainerName -Context $srcContext |
        		ForEach-Object {
            		$blob = $_
            		$blobUri = $_.ICloudBlob.Container.Uri.AbsoluteUri + "/" + ($blob.Name)
		

            		$destCopyState = Start-AzureStorageBlobCopy -Context $srcContext -SrcUri $blobUri `
                                 -DestContext $destContext -DestContainer $DestContainerName `
                                 -DestBlob $blob.Name -Force
            		$destCopyStates += $destCopyState
        		}
		}
		

		$delaySeconds = 10
		do
		{
    		Write-Verbose "Checking storage blob copy status every $delaySeconds seconds."
    		Write-Verbose "This will repeat until all copy operations are complete."
    		Write-Verbose "Press Ctrl-C anytime to stop checking status."
    		Write-Warning "If you do press Ctrl-C, manually remove temporary container '$tempStorageContainerName' from your storage accounts after the copy operation completes."
    		Start-Sleep $delaySeconds
		
    		$continue = $false
		
    		foreach ($copyState in $destCopyStates)
    		{

        		$copyStatus = $copyState | Get-AzureStorageBlobCopyState
        		$copyStatus | Format-Table -AutoSize -Property Status,BytesCopied,TotalBytes,Source
		

        		if (!$continue)
        		{
            		$continue = $copyStatus -eq [Microsoft.WindowsAzure.Storage.Blob.CopyStatus]::Pending
        		}
    		}
		} while ($continue)
		
		

		foreach ($item in $tempStorageContainerAccounts.GetEnumerator())
		{
    		Write-Verbose ("Removing container '{0}' from storage account '{1}'." -f $tempStorageContainerName, $item.Key)
    		Remove-AzureStorageContainer -Name $tempStorageContainerName -Context ($item.Value) -Force
		}
		
		
#endregion		