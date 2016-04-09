<#
.SYNOPSIS
	Restores the a virtual machines disks to a BLOB snapshot taken previously. 
	
.DESCRIPTION
	Restores the a virtual machines disks to a BLOB snapshot taken previously.  The snapshot used will be the next one found after the date and time selected.  This is to eliminate the need for specific times.
	
.PARAMETER subscriptionName
	The user friendly subscription name as defined in the Subscriptions.csv file.

.PARAMETER cloudServiceName
	The cloud service that contains the virtual machine to be restored.

.PARAMETER virtualMachineName
	The name of the virtual machine to be restored.

.PARAMETER utcRestoreDate 
	The UTC date and time in the yyyy-MMM-dd HH:mm:ss format (ex. 2013-JUL-18 15:00:00) that the machine should be restored to.  If no snapshot is found for any drive at that time the next snapshot in chronological order
	will be used.

.PARAMETER restoreDataDisks
	If present the data disks will be restored as well as the operating system disk.  If this is absent only the operating system disk will be restored.

.NOTES
	Author: Chris Clayton
	Date: 2013/08/30
	Revision: 1.1

.EXAMPLE
	./RestoreVirtualMachine.ps1 -subscriptionName "ContosoSubscription" -cloudServiceName "ContosoCloud" -virtualMachineName "DC1" -utcRestoreDate "2013-JUL-18 15:00:00" -restoreDataDisks
#>
param
(
	[string]$subscriptionName,				# The user friendly name of the subscription that contains the virtual machine.  This must match the subscription name in the Subscriptions.csv file.
	[string]$cloudServiceName,				# The name of the cloud service that contains the virtual machine.
	[string]$virtualMachineName,			# The name of the virtual machine that is to be restored.
	[string]$utcRestoreDate,				# The utc date that the restore should be performed for.  Date format should be 2013-JUL-18 15:00:00 (yyyy-MMM-dd HH:mm:ss)
	[switch]$restoreDataDisks = $false		# If present the data disks will be restored as well
)
	
<#
================================================================================================================================================================
														Common Script Header
================================================================================================================================================================
#>

# Import the Windows Azure PowerShell cmdlets
Import-Module 'C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell\ServiceManagement\Azure\Azure.psd1'

<#
.SYNOPSIS
	Determines the directory that the current script is running from.
	
.DESCRIPTION
	Determines the directory that the current script is running from.  If the call depth is not set or is set to 0 it assumes that this method is being called
	from within the script body.  If this is being called from within a function adjust the call depth to reflect how many levels deep the call chain is.

.PARAMETER callDepth
	The depth in the call chain that the script is at when this is being called.  If this is called from within the script body it should be set to 0 or from 
	within a function called from the script body it would be 1 etc.

.NOTES
	Author: Chris Clayton
	Date: 2013/07/18
	Revision: 1.0

.EXAMPLE
	[string]$scriptDirectory = Get-ScriptDirectory 0
#>
function Get-ScriptDirectory
{
	param
	(
		[int]$callDepth = 0		# 0 for main script body, add 1 for each call depth
	)
	
	$callDepth++
	
	# Retrieve the MyInvocation variable representitive of the call depth
	$invocation = (Get-Variable MyInvocation -Scope $callDepth).Value
	
	# return the directory portion of the script
	return Split-Path $invocation.MyCommand.Path
}

<#
.SYNOPSIS
	Determines the relative path of an file or directory that is based on the current location the script is running from.
	
.DESCRIPTION
	Determines the relative path of an file or directory that is based on the current location the script is running from.  If the call depth is not set 
	or is set to 0 it assumes that this method is being called from within the script body.  If this is being called from within a function adjust the 
	call depth to reflect how many levels deep the call chain is.

.PARAMETER callDepth
	The depth in the call chain that the script is at when this is being called.  If this is called from within the script body it should be set to 0 or from 
	within a function called from the script body it would be 1 etc.

.NOTES
	Author: Chris Clayton
	Date: 2013/07/18
	Revision: 1.0

.EXAMPLE
	[string]$scriptDirectory = Get-LiteralPath '..\Data\MyData.csv' 0
#>
function Get-LiteralPath
{
	param
	(
		[string]$relativePath,
		[int]$callDepth = 0		# 0 for main script body, add 1 for each call depth
	)
	$callDepth++	
	$scriptDirectory = Get-ScriptDirectory $callDepth 
	
	return [System.IO.Path]::GetFullPath((Join-Path $scriptDirectory $relativePath))
}

<#
================================================================================================================================================================
														Script specific functions
================================================================================================================================================================
#>

<#
.SYNOPSIS
	Retrieves the snapshot of the newest snapshot that is older than the provided restore time.
	
.DESCRIPTION
	Retrieves the snapshot of the newest snapshot that is older than the provided restore time.  This searches a list of snapshots for the appropriate one.

.PARAMETER snapshotList
	A list of snapshots that are associated with the specific disk to be restored.

.PARAMETER restoreTime
	The time that the machine should be restored to.  The snapshot that is newest before this time is considered the snapshot to restore.

.NOTES
	Author: Chris Clayton
	Date: 2013/07/18
	Revision: 1.0

.EXAMPLE
	$restoreSnapshot = Get-RestoreSnapshot $blobSnapshots $restoreTime
#>
function Get-RestoreSnapshot
{
	param
	(
		$snapshotList,
		[DateTimeOffset]$restoreTime
	)
	$restoreSnapshot = $null
		
	foreach($snapshot in $snapshotList)
	{		
		if(($restoreSnapshot -eq $null) -or (($snapshot.SnapshotTime -le $restoreDate) -and ($snapshot.SnapshotTime -gt $restoreSnapshot.SnapshotTime)))
		{
			$restoreSnapshot = $snapshot
		}
	}
	
	return $restoreSnapshot
}

<#
.SYNOPSIS
	Removes a virtual machine along with all of the related disks.
	
.DESCRIPTION
	Removes a virtual machine along with all of the related disks.  The VHDs are retained and delays are in place to monitor for the 
	attached flag to release.

.PARAMETER virtualMachine
	A virtual machine object that is to be deleted.

.PARAMETER osDisk
	The operating system disk to be deleted.  The associated VHD will not be deleted.

.PARAMETER dataDisks
	The data disks to be deleted.  The associated VHDs will not be deleted.

.NOTES
	Author: Chris Clayton
	Date: 2013/07/18
	Revision: 1.0

.EXAMPLE
	Remove-VirtualMachine $virtualMachine $operatingSystemDisk @($dataDisk1, $dataDisk2)
#>
function Remove-VirtualMachine
{
	param
	(
		$virtualMachine,
		$osDisk,
		$dataDisks
	)
	
	# Safely remove the VM as the metadata is now saved
	$removeResult = $virtualMachine | Remove-AzureVM

	# Loop while waiting for the disks to release
	do
	{
		Start-Sleep -Seconds 5
		$disksInUse = Get-AzureDisk | Where-Object { ($_.AttachedTo.RoleName -eq $virtualMachineName) -and ($_.AttachedTo.HostedServiceName -eq $cloudServiceName) }
	}while(($disksInUse -ne $null) -or ($disksInUse.Count -gt 0))
	
	# The operating system disk and data disks must be removed but VHD retained
	$osDisk | Remove-AzureDisk
	
	foreach($dataDisk in $dataDisks)
	{
		$dataDisk | Remove-AzureDisk		
	}
}

<#
.SYNOPSIS
	Restores the requested disks to the previous blob state and adds them again.
	
.DESCRIPTION
	Restores the requested disks to the previous blob state and adds them again.

.PARAMETER osDisk
	The operating system disk to be restored.  

.PARAMETER osSnapshot
	The operating system disk BLOB snapshot to be restored.

.PARAMETER dataDisks
	An array of data disks to be restored.
	
.PARAMETER dataDiskSnapshots	
	An array of data disk BLOB snapshot to be restored.  This array must be in the same order as the dataDisks array.

.NOTES
	Author: Chris Clayton
	Date: 2013/07/18
	Revision: 1.0

.EXAMPLE
	Restore-Disks $operatingSystemDisk $osSnapshot @($dataDisk1, $dataDisk2) @($dataDisk1Snapshot, $dataDisk2Snapshot)
#>
function Restore-Disks
{
	param
	(
		$osDisk,
		$osSnapshot,
		$dataDisks,
		$dataDiskSnapshots
	)
	
	# Restore the snapshot if it is not null
	if($osSnapshot -ne $null)
	{
		Restore-BlobFromSnapshot $osDisk.MediaLink $osSnapshot
	}
	
	# Continue restoring if there are data disk snapshots
	if(($dataDiskSnapshots -ne $null) -and ($dataDiskSnapshots.Length -gt 0))
	{
		[int]$dataDiskIndex = 0
		
		foreach($dataDisk in $dataDisks)
		{
			if($dataDiskSnapshots[$dataDiskIndex] -ne $null)
			{
				Restore-BlobFromSnapshot $dataDisk.MediaLink $dataDiskSnapshots[$dataDiskIndex]
			}
			
			$dataDiskIndex++
		}		
	}

	foreach($dataDisk in $dataDisks)
	{
		Add-AzureDisk -DiskName $dataDisk.DiskName -MediaLocation $dataDisk.MediaLink 
	}

	Add-AzureDisk -DiskName $osDisk.DiskName -MediaLocation $osDisk.MediaLink -OS $osDisk.OS 
}

<#
.SYNOPSIS
	Restores an existing virtual machine to a previous stated. 
	
.DESCRIPTION
	Restores an existing virtual machine to a previous stated.  This will delete the virtual machine and readd it so if
	it is the last machine in the cloud service the IP address will be lost.

.PARAMETER subscriptionName
	The friendly name of the subscription that the virtual machine is stored in.

.PARAMETER subscriptionDataFile
	The Windows Azure subscription data file to be used.

.PARAMETER cloudServiceName
	The cloud service name that contains the virtual machine.
	
.PARAMETER virtualMachineName
	The name of the virtual machine to be restored.

.PARAMETER exportFile
	A fully qualified file name that the virtual machine metadata will be exported to.

.PARAMETER restoreDataDisks
	If true the data disks will also be restored.

.NOTES
	Author: Chris Clayton
	Date: 2013/07/18
	Revision: 1.0

.EXAMPLE
	Restore-VirtualMachine 'Development' 'c:\snapshots\mydatafile.xml' 'developerservice' 'AppServer' 'c:\snapshots\AppServer.txt' $true
#>
function Restore-VirtualMachine
{
	param
	(
		[string]$subscriptionName,
		[string]$subscriptionDataFile,
		[string]$cloudServiceName,
		[string]$virtualMachineName,
		[string]$exportFile,
		[bool]$restoreDataDisks
	)
	
	# Set the subscription context to the desired subscription
	Select-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionDataFile $subscriptionDataFile	

	# Retrieve the virtual machine object that will be restored
	$virtualMachine = Get-AzureVM -ServiceName $cloudServiceName -Name $virtualMachineName

	if($virtualMachine -ne $null)
	{
		# Retrieve the Disk Information
		$osDisk = $virtualMachine | Get-AzureOSDisk 
		$dataDisks = $virtualMachine | Get-AzureDataDisk

		# Based on the operating system set the current storage account details and reset the context
		$urlElements = Get-BlobUriElements $osDisk.MediaLink
		Set-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionDataFile $subscriptionDataFile -CurrentStorageAccount $urlElements.Item1
		Select-AzureSubscription -SubscriptionName $subscriptionName -SubscriptionDataFile $subscriptionDataFile	
		
		# Retrieve the restore snapshot for the operating system disk
		$existingSnapshots = Get-BlobSnapshots $osDisk.MediaLink			
		$osSnapshot = Get-RestoreSnapshot $existingSnapshots $restoreDate

		# Retrieve the restore snapshots for the data disks
		$dataDiskSnapshot = @()

		if($restoreDataDisks)
		{			
			foreach($dataDisk in $dataDisks)
			{
				$existingDataDiskSnapshots = Get-BlobSnapshots $dataDisk.MediaLink			
				$dataDiskSnapshot += Get-RestoreSnapshot $existingDataDiskSnapshots $restoreDateOffset
			}	
		}			

		# Export the current virtual machine information as we have to delete and recreate it
		Export-AzureVM -ServiceName $cloudServiceName -Name $virtualMachineName -Path $exportFile	

		# Remove the virtual machine and disks while wait for it to release the disks
		Remove-VirtualMachine $virtualMachine $osDisk $dataDisks
		
		# Restore the os and data disks.  Register the disks as they are completed
		Restore-Disks $osDisk $osSnapshot $dataDisks $dataDiskSnapshot

		# Import the Azure VM again
		Import-AzureVM -Path $exportFile | New-AzureVM -ServiceName $cloudServiceName	
	}
	else
	{
		Throw "Could not retrieve the virtual machine $virtualMachineName that is part of $cloudServiceName cloud service."
	}
}

<#
================================================================================================================================================================
														Script Body
================================================================================================================================================================
#>

# Add the snapshot common script functions
.$(Get-LiteralPath '.\Common\RepositoryCommon.ps1')

# Determine the required file locations based on relative paths
[string]$subscriptionsFileName = Get-LiteralPath '.\Subscriptions.csv'
[string]$subscriptionDataFile = Get-LiteralPath '.\SubscriptionData.xml'
[string]$exportFile = Get-LiteralPath ".\$($cloudServiceName)-$($virtualMachineName).xml"

# Prepare the subscription data by moving entries from the Subscriptions.csv file into the Windows Azure data file.
Prepare-SubscriptionDataFile $subscriptionsFileName $subscriptionDataFile

# Convert the provided date time to one that matches the SnapshotTime structure (offset).
[DateTime]$restoreDate = [DateTime]::SpecifyKind([DateTime]::Parse($utcRestoreDate), [DateTimeKind]::Utc)
[DateTimeOffset]$restoreDateOffset = New-Object DateTimeOffset($restoreDate)

# Perform the virtual machine restore
Restore-VirtualMachine $subscriptionName $subscriptionDataFile $cloudServiceName $virtualMachineName $exportFile $restoreDataDisks

# Clear subscription entries		
Clear-SubscriptionData $subscriptionDataFile

