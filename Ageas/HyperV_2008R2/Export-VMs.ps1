<#
 Export-VMs.ps1 Version 1.0
 Export VMs on a Hyper-V Server and/or cluster
 
 Copyright 2011 Altaro Software - http://www.altaro.com/hyper-v-backup/
 
 Your usage of this software indicates acceptance of the following: 
 This script is provided as-is. Altaro Software does not provide any warranty of the item whatsoever, whether express, implied, or
 statutory, including, but not limited to, any warranty of merchantability or fitness for a particular purpose or any warranty that
 the contents of the item will be error-free.
#>

## command-line parameters must be trapped immediately or they'll throw an error
## $JobName = the name of the job (defined in VMExportConfig.xml) to be run; if none, an "export-all with defaults" job is executed
## $Subfolder = the name of a subfolder to be used/created under the export path; if empty, use the folder as defined
param ([String]$JobName="",[String]$Subfolder="")		# this must be trapped right at the top; if no job is specified, just export everything

## Global "Constants" (actually variables, but are unchangeable by functions)
$ScriptDir = Split-Path (Get-Variable MyInvocation).Value.MyCommand.Path
$ConfigFile = "$ScriptDir\VMExportConfig.xml"			# Modify this to change where configuration data is saved
$DefaultLogFile = "$ScriptDir\VMExport.log"		# Modify this to change default log location (overriden when config file is read)
$OpsTimeOut = 360																	# Seconds to wait for a process before continuing without it (mostly, how long to wait for a VM to finish changing state before skipping it)
## TODO: Make the timeout user configurable?

## Global variables
$global:ConfigData = ""														# Holds configuration data as read from the config XML file
$global:ClusterName = $null												# Name of cluster this computer is a member of, if any
[String]$global:LogFile	= $DefaultLogFile					# Where messages will be stored
$ThisHost = Get-Content env:computername					# Get the name of this computer
$global:ActionBeforeExport = "Save"								# Will be reset by config load
$global:MoveMissingVMsToThisNode = "No"						# Will be reset by config load
$global:IncludeOrExclude	= "Exclude"							# Will be reset by config load
$global:UseCluster = "No"													# Will be reset by config load
[String[]]$global:Hosts = @()												# Array of host names in the cluster

############## Functions ##############

## Log errors with timestamp
function LogMessage
{
	param([String]$Condition,[String]$ErrorMessage)
	$Stamp = Get-Date
	Add-Content $global:LogFile "$Stamp $Condition`: $ErrorMessage"
}

## Migrates a VM from one host to another. If the VM is online, LiveMigration is used. If it is offline/saved, it is Moved.
## This function relies on cluster commands and as such it will only operate on HA VMs.
## Uses modification of code from James O'Neill's Hyper-V Module at http://pshyperv.codeplex.com and Microsoft's script repository at http://gallery.technet.microsoft.com/scriptcenter/48db8f68-8b8e-4852-bf64-6a197f9b73ec
##
## $VMName = string name of VM to be migrated
## $SourceNodeName = string name of the node that the VM is currently on
## $DestinationNodeName = string name of node to move the VM to; default is this node
function Migrate-VM
{
	param([String]$VMName,[String]$SourceNodeName,[String]$DestinationNodeName="")
	if (-not $DestinationNodeName)
	{ $DestinationNode = Get-Clusternode $env:computername	}	# if it's blank, attempt migration to the calling node
	else
	{ $DestinationNode = Get-Clusternode $DestinationNodeName }
	$VMObject = Get-WmiObject -ComputerName $SourceNodeName -namespace root\virtualization -Query "SELECT * FROM MSVM_ComputerSystem WHERE ElementName = '$VMName'"
	$VMClusterGroup = Get-Cluster -Name $VMObject.__SERVER | Get-ClusterGroup | Where-Object { Get-ClusterResource -Input $_ |
		Where-Object { $_.ResourceType -like "Virtual Machine" } |
		Get-ClusterParameter -Name vmID |
		Where-Object {$_.Value -eq $VMObject.Name}}
	$VMResource = Get-ClusterResource |
		WHERE { $_.ResourceType -like "Virtual Machine" -and $_.OwnerGroup.Name -like $VMClusterGroup.Name }
	if($VMResource -eq $null)
	{
		LogMessage "Error" "Attepted to migrate $VMName but was unable to determine its existence on the cluster."
		return $FALSE
	}
	try
	{
		if($VMResource.State -eq "Online")
		{	# LiveMigrate if online
			Move-ClusterVirtualMachineRole -Node $DestinationNode -InputObject $VMResource.OwnerGroup -ErrorAction Stop
		}
		else
		{ # Move if offline
			Move-ClusterGroup -Node $DestinationNode -InputObject $VMResource.OwnerGroup -ErrorAction Stop
		}
	}
	catch
	{
		LogMessage "Error" "Attempted to move VM $VMName from $SourceNodeName to $DestinationNodeName but encountered an error: $Error"
		return $FALSE
	}
	return $TRUE
}

## Read the configuration file and ensure it is more or less valid format
function Read-ConfigData
{
	$global:ConfigData = New-Object XML
	if (Test-Path $ConfigFile)	# Don't blindly read it
	{
		try
		{
			$Error.Clear()
			$global:ConfigData.Load($ConfigFile)
			return $TRUE
		}
		catch
		{
			Clear-Host
			LogMessage "Error" ("Error reading configuration file: $Error.")
			return $FALSE
		}
	}
	else
	{
		LogMessage "Error" ("Configuration file not found: " + $ConfigFile)
		return $FALSE
	}
	$ConfigurationRoot = $global:ConfigData.Root.Configuration

	# The Root element is not checked for, if the file is that badly damaged then it probably didn't even load
	if ($ConfigurationRoot -eq $null)
	{
		LogMessage "Error" "Configuration node missing in " + $ConfigFile
		return $FALSE
	}

	# TODO: If the script is upgraded with new options, ensure they are checked below
	# TODO: Implement better error-checking: only checks to see if the nodes are non-present or empty, not for invalid data
	# TODO: Find a way to loop these, too much almost-duplicate code

	# Check to be sure the DefaultExportPath key exists and is set
	if ($ConfigurationRoot.DefaultExportPath -eq $null)
	{
		LogMessage "Error" "`"DefaultExportPath`" not found in configuration file."
		return $FALSE
	}
	if ($ConfigurationRoot.DefaultExportPath.Length -eq 0)
	{
		LogMessage "Error" "`"DefaultExportPath`" not set in configuration file."
		return $FALSE
	}
	# Check to be sure the LogFile key exists and is set
	if ($ConfigurationRoot.LogFile -eq $null)
	{
		LogMessage "Error" "`"LogFile`" not found in configuration file."
		return $FALSE
	}
	if ($ConfigurationRoot.LogFile.Length -eq 0)
	{
		LogMessage "Error" "`"LogFile`" not set in configuration file."
		return $FALSE
	}
	# Check to be sure the UseCluster key exists and is set
	if ($ConfigurationRoot.UseCluster -eq $null)
	{
		LogMessage "Error" "`"UseCluster`" not found in configuration file."
		return $FALSE
	}
	if ($ConfigurationRoot.UseCluster.Length -eq 0)
	{
		LogMessage "Error" "`"UseCluster`" not set in configuration file."
		return $FALSE
	}
	# Check to be sure the DefaultActionBeforeExport key exists and is set
	if ($ConfigurationRoot.DefaultActionBeforeExport -eq $null)
	{
		LogMessage "Error" "`"DefaultActionBeforeExport`" not found in configuration file."
		return $FALSE
	}
	if ($ConfigurationRoot.DefaultActionBeforeExport.Length -eq 0)
	{
		LogMessage "Error" "`"DefaultActionBeforeExport`" not set in configuration file."
		return $FALSE
	}
	# Check to be sure the DefaultMoveMissingVMsToThisNode key exists and is set
	if ($ConfigurationRoot.DefaultMoveMissingVMsToThisNode -eq $null)
	{
		LogMessage "Error" "`"DefaultMoveMissingVMsToThisNode`" not found in configuration file."
		return $FALSE
	}
	if ($ConfigurationRoot.DefaultMoveMissingVMsToThisNode.Length -eq 0)
	{
		LogMessage "Error" "`"DefaultMoveMissingVMsToThisNode`" not set in configuration file."
		return $FALSE
	}
	# Check to be sure the DefaultIncludeOrExclude key exists and is set
	if ($ConfigurationRoot.DefaultIncludeOrExclude -eq $null)
	{
		LogMessage "Error" "`"DefaultIncludeOrExclude`" not found in configuration file."
		return $FALSE
	}
	if ($ConfigurationRoot.DefaultIncludeOrExclude.Length -eq 0)
	{
		LogMessage "Error" "`"DefaultIncludeOrExclude`" not set in configuration file."
		return $FALSE
	}
}

## Import dependencies and populate globals
function SetUp-Environment
{
	if($global:ConfigData.Root.Configuration.UseCluster -eq "Yes")
	{
		try
		{
			Import-Module "FailoverClusters" -ErrorAction Stop
			$global:ClusterName = Get-Cluster
			$global:UseCluster = "Yes"
			ForEach($Server in Get-ClusterNode)
			{
				$global:Hosts += $Server.Name
			}
		}
		catch
		{
			LogMessage "Warning" "Directed to use cluster functions; cluster is not available: $Error"
			$global:ClusterName = $null
			$global:UseCluster = "No"		# Defaults to "No", but if a future code change calls this function again, it's a cheap check
		}
	}
	$global:LogFile = $global:ConfigData.Root.Configuration.LogFile
	$global:ActionBeforeExport = $global:ConfigData.Root.Configuration.DefaultActionBeforeExport
	$global:MoveMissingVMsToThisNode = $global:ConfigData.Root.Configuration.DefaultMoveMissingVMsToThisNode
}

## function name is to reduce probability of name collisions with other tools; PowerShell is not graceful about that
##
## $VMName = string name of the VM to be exported
## $Destination = string indicating fully qualified destination path including any custom Subfolder
## $SaveOrShutDown = if powered on, should this VM be saved or shut down? [String] "Save" or "Shutdown"
## $Migrate = if not on this node, should there be an attempt to move the VM to this node? [String] "Yes" or "No"
function Export-SingleVM
{
	param([String]$VMName,[String]$Destination,[String]$SaveOrShutDown,[String]$Migrate)

	$StartingState = 0	# Status of the VM before export begins
	$StartingHost = $env:computername
	LogMessage "Information" "Beginning export of $VMName"
	$HVMgmtService = Get-WMIObject -namespace root\virtualization MSVM_VirtualSystemManagementService

	# Locate the requested VM
	$VMObject = Get-WmiObject -ComputerName $env:computername -namespace root\virtualization -Query "SELECT * FROM MSVM_ComputerSystem WHERE ElementName = '$VMName'"
	if($VMObject -eq $null)
	{	# this means the named VM wasn't found on the local system
		if(($Migrate -eq "Yes") -and ($global:UseCluster -eq "Yes"))
		{	# only look on other servers if directed and in a cluster
			ForEach ($Server in $Hosts)
			{
				if($Server -eq $env.computername)
				{ continue }	# already checked the local machine
				$VMObject = Get-WmiObject -ComputerName $Server -namespace root\virtualization -Query "SELECT * FROM MSVM_ComputerSystem WHERE ElementName = '$VMName'"
				if($VMObject -ne $null)
				{
					$StartingHost = $VMObject.__SERVER		# record the server that it began on so it can be returned
					break		# no sense checking every server
				}
			}
		}
		# potentially wasteful second check but easiest to code and understand
		if($VMObject -eq $null)
		{ # not necessarily an error
			LogMessage "Skipped" "VM $VMName selected for export but was not found."
			return
		}
		if(!(Migrate-VM $VMName $VMObject.__SERVER))
		{ return }	# The Migration function performs its own error messaging
	}
	# The VM is selected, options are set, destination is known. Proceed with the export. Run inside a try block to ensure a LiveMigrated VM is returned no matter what else happens.

	try
	{
		# VMs cannot be exported while powered on.
		# First, find out what the current status of the VM is and store it.
		# Since the only state necessary to return to would be the powered on state, this could be a lot simpler, but this builds in some future expandability
		$StayInLoop = $TRUE
		$FirstEntry = $TRUE
		while ($StayInLoop)
		{
			# VMObject.EnabledState doesn't refresh; retrieve the object again
			$VMObject = Get-WmiObject -ComputerName $env:computername -namespace root\virtualization -Query "SELECT * FROM MSVM_ComputerSystem WHERE ElementName = '$VMName'"
			$StartingState = $VMObject.EnabledState
			switch ($StartingState)
			{
				32768 # Paused: this state cannot be exported and is uncommon -- the user can pause a VM, but Hyper-V will also pause it if something goes wrong. Do not interfere. Report and return.
				{
					LogMessage "Skipped" "VM $VMName is paused and cannot be exported."
					return
				}
				{ $_ -ge 32770 } # Starting, taking snapshot, saving, stopping -- these are transitional so wait the timeout and check again
				{
					if ($FirstEntry)
					{
						Start-Sleep $OpsTimeOut
					}
					else
					{
						## TODO: Make the number user-friendly
						if($StartingState -ge 32770)
						{
							LogMessage "Skipped" "VM $VMName was in a transitional state ($StartingState) when the export started and exceeded the timeout of $OpsTimeOut seconds."
							return
						}
					}
				}
				Default
				{
					$StayInLoop = $FALSE # just store state and continue -- probable options are 2 (running), 3 (stopped), and 32769 (saved)
				}
			}
		}

		if ($StartingState -eq 2)	# The VM is running, so perform the user-selected action
		{
			if($SaveOrShutDown -eq "Save")
			{
				$SaveStatus = $VMObject.RequestStateChange(32769)
				if($SaveStatus.ReturnValue -eq 4096)
				{
					$Job = [WMI]$SaveStatus.Job
					while($Job.JobState -eq 4)	# 4 is "running"
					{
						Start-Sleep 5		# wait about 5 seconds between checks
						$Job.PSBase.Get()
						# TODO: Build in a timeout? Potentially more dangerous to abandon a VM that takes a while to save than to just let it take as long as it wants
					}
					if($Job.JobState -ne 7)	# 7 is "completed"
					{
						LogMessage "Error" ("Attempted to save $VMName for export but encountered error " + $Job.ErrorDescription)
						return
					}
				}
			}
			else	# other option is to shut it down, which is an entirely different command
			{
				$ShutdownObject = Get-WmiObject -namespace root\virtualization -Query "Associators of {$VMObject} WHERE AssocClass=MSVM_SystemDevice ResultClass=MSVM_ShutdownComponent"
				$ShutdownStatus = $ShutdownObject.InitiateShutdown($True, "Scheduled Export")
				if($ShutdownStatus.ReturnValue -eq 4096)
				{
					$Job = [WMI]$ShutdownStatus.Job
					while($Job.JobState -eq 4)	# 4 is "running"
					{
						Start-Sleep 5
						$Job.PSBase.Get()
					}
					if($Job.JobState -ne 7)	# 7 is "completed"
					{
						LogMessage "Error" ("Requested VM $VMName to shut down, error received: " + $Job.ErrorDescription)
						return
					}
				}
				elseif ($ShutdownStatus.ReturnValue -eq 0)
				{	# this happens when the command returns immediately, so monitor the shutdown manually
					$CheckInterval = 5	# how many seconds to wait between polls
					for($i = 0;$i -lt $OpsTimeOut;$i += $CheckInterval)
					{
						Start-Sleep $CheckInterval
						# VMObject.EnabledState doesn't refresh; call again
						$VMObject = Get-WmiObject -ComputerName $env:computername -namespace root\virtualization -Query "SELECT * FROM MSVM_ComputerSystem WHERE ElementName = '$VMName'"
						if($VMObject.EnabledState -eq 3)
						{ break }
					}
					# potentially wasteful check, but easy to code/read
					if($VMObject.EnabledState -ne 3)
					{
						LogMessage "Error" "Attempted to shutdown $VMName for export, but timeout exceeded without a successful shutdown. Please check the status of this VM immediately."
						return
					}
				}
				else
				{
					# TODO: Make user friendly
					LogMessage "Error" ("Attempted to shutdown $VMName for export, but it failed with an unexpected status: " + $ShutdownStatus.ReturnValue)
					return
				}
			}
		}

		# Check for earlier exports of this VM.
		if(Test-Path($Destination + "\" + $VMName))
		{
			# Export will attempt to create a subfolder with the name of the VM in the destination location. If it already exists,
			# export stops. There is no overwrite option. The options available are to wipe the destination folder or to skip the VM.
			# In this implementation, the script wipes the destination.
			# TODO: Create an option to choose to delete or skip.
			Remove-Item ($Destination + "\" + $VMName) -Force -Recurse
		}

		# There are some complicated CIM scripts that can be used to pre-check statistics of the VM. Those statistics, especially
		# disk space consumed, could then be compared against the free disk space on the target, but it's far easier to use the
		# export command itself to do the heavy lifting and just report any problems in the log file.
		$ExportStatus = $HVMgmtService.ExportVirtualSystem($VMObject.__PATH, $True, $Destination) # which VM to export, copy the entire state (VHDs, AVHDs, saved state), and where to put it all
		if ($ExportStatus.ReturnValue -eq 4096)	# 4096 is "asynchronous job started"
		{
			$Job = [WMI]$ExportStatus.Job
			while($Job.JobState -eq 4)	# 4 is "running"
			{
				Start-Sleep 5		# wait about 5 seconds between checks
				$Job.PSBase.Get()
			}
			if($Job.JobState -eq 7)	# 7 is "completed"
			{ LogMessage "Information" "VM $VMName exported successfully." }
			else
			{ LogMessage "Error" ("Export of $VMName failed: " + $Job.ErrorDescription) }
		}
		else
		{
			switch ($ExportStatus.ReturnValue)
			{
				32775
				{
					LogMessage "Error" "The VM $VMName could not be exported because it is turned on and attempts to turn it off did not succeed."
					return
				}
				Default
				{ LogMessage "Error" ("Unable to start export for $VMName for an undetermined reason. Exit code " + $ExportStatus.ReturnValue) }
			}
		}
	}
	catch
	{
		return	# the real purpose of this try/catch/finally is to ensure VM powered back on and moved back to its original host even if the export doesn't work
	}
	finally
	{
		# get the current state of the object
		$VMObject = Get-WmiObject -ComputerName $env:computername -namespace root\virtualization -Query "SELECT * FROM MSVM_ComputerSystem WHERE ElementName = '$VMName'"
		if($VMObject.EnabledState -ne $StartingState)
		{
			$ReturnStatus = $VMObject.RequestStateChange($StartingState)
			if($ReturnStatus.ReturnValue -eq 4096)
			{
				$Job = [WMI]$ReturnStatus.Job
				while($Job.JobState -eq 4)
				{
					Start-Sleep 5		# wait about 5 seconds between checks
					$Job.PSBase.Get()
				}
				if($Job.JobState -ne 7)
				{
					LogMessage "Error" ("Attempted to restore $VMName to its original state but encountered error " + $Job.ErrorDescription)
				}
			}
		}
		# there is no need to check again if migrating/cluster is enabled
		if($env:computername -ne $StartingHost)
		{ Migrate-VM $VMName $env:computername $StartingHost | Out-Null }
	}
}

## Work-horse function
function Execute-Export
{
	# TODO: Research breaking out into disparate functions; need to weigh readability and usage of more globals and/or [ref] variables
	$VMList = @()	# this was originally a multi-dimensional array of VMs to be exported: [0]=VM Name [1]=Action before export [2]= Move to this node -- PowerShell freaked out and refused to handle that consistently; now an array of comma-separated strings in the same format
	$JobExportPath = $global:DefaultExportPath # Where the VMs will go
	$JobActionBeforeExport = $global:ActionBeforeExport	# Save or shutdown?
	$JobMoveMissingVMsToThisNode = $global:MoveMissingVMsToThisNode	# Migrate or not
	$JobIncludeOrExclude = $global:DefaultIncludeOrExclude	# Include or exclude configured VMs?

	if($JobName.Length)
	{ LogMessage "Information" "$JobName started" }
	else
	{ LogMessage "Information" "Exporting all VMs" }

	# Build the list of VMs to be exported and the options to be used on them
	if($JobName.Length)
	{
		$JobsNode = $global:ConfigData.SelectNodes("Root/Jobs/Job")
		ForEach ($JobNode in $JobsNode)
		{
			if($JobNode.JobName -eq $JobName)
			{
				$ActiveJobNode = $JobNode
				break
			}
		}
		if($ActiveJobNode -eq $null)
		{
			# This would only happen if the app was told to run a non-existent job.
			# Could fall through to export all, but that's potentially disastrous. Log it as an error and exit.
			LogMessage "Error" "Unable to find specified job `"$JobName`""
			Exit
		}
		$JobExportPath = $ActiveJobNode.ExportPath
		$JobActionBeforeExport = $ActiveJobNode.ActionBeforeExport
		$JobMoveMissingVMsToThisNode = $ActiveJobNode.MoveMissingVMsToThisNode
		$JobIncludeOrExclude = $ActiveJobNode.IncludeOrExclude
		$VMNodes = $ActiveJobNode.SelectNodes("VMList/VM")
	}
	else
	{
		$JobExportPath = $global:DefaultExportPath
		$JobActionBeforeExport = $global:DefaultActionBeforeExport
		$JobMoveMissingVMsToThisNode = $global:MoveMissingVMsToThisNode
	}
	if($JobName.Length -and ($JobIncludeOrExclude -eq "Include"))
	{
		# This is the easy one; only export from the user-defined list
		ForEach ($VMObject in $VMNodes)
		{
			if($VMObject.ActionBeforeExport -ne $null)
			{ $VMActionBeforeExport = $VMObject.ActionBeforeExport }
			else
			{ $VMActionBeforeExport = $JobActionBeforeExport }
			if($VMObject.MoveIfMissing -ne $null)
			{ $VMMoveToThisNode = $VMObject.MoveIfMissing }
			else
			{ $VMMoveToThisNode = $JobMoveMissingVMsToThisNode }
			$VMList += ,@($VMObject.Name + ",$VMActionBeforeExport,$VMMoveToThisNode")
		}
	}
	elseif (($JobName.Length -and ($JobIncludeOrExclude -eq "Exclude")) -xor ($JobName.Length -eq 0))
	{
		[String[]]$VMExcludeList = @()		# Will hold the excluded items
		[String[]]$Hosts	= @()					# Will hold the host name(s)
		$VMActionBeforeExport = ""
		$VMMoveToThisNode = ""

		# First, if a job name was passed in, get a list of items to Exclude
		if($JobName.Length)
		{
			ForEach($VMObject in $VMNodes)
			{	$VMExcludeList += $VMObject.Name }
		}
		# Next, get a list of all available VMs
		if($global:UseCluster)
		{
			ForEach($Server in Get-ClusterNode)
			{
				$Hosts += $Server.Name
			}
		}
		else { $Hosts += $env:computername }

		# Retrieve the list of VMs on this server or cluster
		$VMObjects = Get-WmiObject -ComputerName $Hosts -namespace root\virtualization MSVM_ComputerSystem -filter "ElementName <> Name"

		# Step through the retrieved VMs; skip if excluded, add to export list with job settings
		ForEach ($VMObject in $VMObjects)
		{
			if ($VMExcludeList -notcontains $VMObject.ElementName)
			{
				$Count++
				$VMList += ,@($VMObject.ElementName + ",$JobActionBeforeExport,$JobMoveMissingVMsToThisNode")
			}
		}
	}
	else	# Not too many ways to get here; most probable, a job name was passed in and the value for IncludeOrExclude in the XML is not right
	{
		LogMessage "Error" "Invalid value $JobIncludeOrExclude specified for job " + $JobName + "; expected `"Include`" or `"Exclude`" for IncludeOrExclude element."
		Exit
	}

	# The list of VMs to export is now prepared. The next thing to look at is the destination.

	# If data was submitted for parameter $Subfolder, modify the export path to include it
	if($Subfolder.Length)
	{
		if(($JobExportPath[($ExportPath.Length - 1)] -ne "\") -and ($Subfolder[0] -ne "\"))
		{	$JobExportPath += "\" }	# Make sure the original folder and specified subfolder are separated by a \
		$JobExportPath += $Subfolder
	}

	if(!(Test-Path($JobExportPath)))
	{
		try
		{	# if the folder doesn't exist, make it
			New-Item $JobExportPath -Type directory -Force -ErrorAction Stop | Out-Null
		}
		catch
		{
			LogMessage "Error" "Path specified for job $JobName ($JobExportPath) is not valid and could not be created. Message from system: $error"
			Exit
		}
	}

	# The larger environment requirements are set. Next is to step through the VMs and export them.
	ForEach ($VM in $VMList)
	{
		$VMArray = [RegEx]::Split($VM, ",")
		Export-SingleVM $VMArray[0] $JobExportPath $VMArray[1] $VMArray[2] | Out-Null #Export-SingleVM reports success, but it's not trapped in this implementation; pipe to null or the user might see a series of True and False reports without explanation
	}
}

############ End Functions ############

############# Main Routine ############

$Error.Clear()	# Should be unnecessary, but since there's no way to know what the environment was like before this was called, this will keep foreign items out of the log.
if(!(Read-ConfigData)) { Exit }	# Retrieve the configuration or die
Write-Host ("Export-VMs.ps1 Version 1.0`n")
SetUp-Environment
Execute-Export


########## End Main Routine ###########