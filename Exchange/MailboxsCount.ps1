#
#.SYNOPSIS 
#Returns the list of mailbox databases on a server
#along with the mailbox count and .edb file size
#for each database.
#
#.EXAMPLE
#.\get-mbinfo.ps1 -server EX2007MB
#

#You must specify a server name
param($server)
$server="vpf6001EXC011"

#If server name not provided try using the local host
if ($server -eq $nul) {$server = $env:COMPUTERNAME}

#Exit if server is not an Exchange mailbox server
$rolecheck = Get-ExchangeServer $server -erroraction silentlycontinue
if ($rolecheck.IsMailboxServer -ne $true)
{
	Write-Host "Server" $server "is not a mailbox server" -foregroundcolor red -backgroundcolor white
	Write-Host "Use -Server to specify a valid mailbox" -foregroundcolor red -backgroundcolor white
	Write-Host "server to run script against." -foregroundcolor red -backgroundcolor white
	Exit
}

#Check if its a cluster so that node name can be used for EDB file size check
$cluster = get-ClusteredMailboxServerStatus -identity $server -erroraction silentlycontinue 
if ($cluster -eq $nul)
{
	$servername = $server
}
else
{
	$CluObj = New-Object -com "MSCluster.Cluster"	
	$CluObj.Open($Server)
	$ActiveNode = $CluObj.ResourceGroups.Item($Server).OwnerNode.Name

	$servername = $ActiveNode
}

#Get the list of mailbox databases from the server (excluding recovery databases)
$dbs = Get-MailboxDatabase -server $server | Where {$_.Recovery -ne $true}

#Quick reorder
$dbs = $dbs | sort-object name

foreach ($db in $dbs)
{ 
	#Get the mailbox count for the database
	$mailboxes = Get-Mailbox -database $db -IgnoreDefaultScope -Resultsize Unlimited -erroraction silentlycontinue
	$mbcount = $mailboxes.count
	
	#Get the EDB file size for the database
	$edbfilepath = $db.edbfilepath 
	$path = "`\`\" + $servername + "`\" + $db.EdbFilePath.DriveName.Remove(1).ToString() + "$"+ $db.EdbFilePath.PathName.Remove(0,2) 
	$dbsize = Get-ChildItem $path 
	[float]$size = $dbsize.Length /1024/1024 
	$dbname = $db.name

	$returnedObj = new-object PSObject
    $returnedObj | add-member NoteProperty -name "Server" -value $server
	$returnedObj | add-member NoteProperty -name "Database" -value $dbname
	$returnedObj | add-member NoteProperty -name "Size (Mb)" -value $size
	$returnedObj | Add-Member NoteProperty -Name "Mailboxes" -Value $mbcount
	$returnedObj
}

$server="vpf6001EXC012"

#If server name not provided try using the local host
if ($server -eq $nul) {$server = $env:COMPUTERNAME}

#Exit if server is not an Exchange mailbox server
$rolecheck = Get-ExchangeServer $server -erroraction silentlycontinue
if ($rolecheck.IsMailboxServer -ne $true)
{
	Write-Host "Server" $server "is not a mailbox server" -foregroundcolor red -backgroundcolor white
	Write-Host "Use -Server to specify a valid mailbox" -foregroundcolor red -backgroundcolor white
	Write-Host "server to run script against." -foregroundcolor red -backgroundcolor white
	Exit
}

#Check if its a cluster so that node name can be used for EDB file size check
$cluster = get-ClusteredMailboxServerStatus -identity $server -erroraction silentlycontinue 
if ($cluster -eq $nul)
{
	$servername = $server
}
else
{
	$CluObj = New-Object -com "MSCluster.Cluster"	
	$CluObj.Open($Server)
	$ActiveNode = $CluObj.ResourceGroups.Item($Server).OwnerNode.Name

	$servername = $ActiveNode
}

#Get the list of mailbox databases from the server (excluding recovery databases)
$dbs = Get-MailboxDatabase -server $server | Where {$_.Recovery -ne $true}

#Quick reorder
$dbs = $dbs | sort-object name

foreach ($db in $dbs)
{ 
	#Get the mailbox count for the database
	$mailboxes = Get-Mailbox -database $db -IgnoreDefaultScope -Resultsize Unlimited -erroraction silentlycontinue
	$mbcount = $mailboxes.count
	
	#Get the EDB file size for the database
	$edbfilepath = $db.edbfilepath 
	$path = "`\`\" + $servername + "`\" + $db.EdbFilePath.DriveName.Remove(1).ToString() + "$"+ $db.EdbFilePath.PathName.Remove(0,2) 
	$dbsize = Get-ChildItem $path 
	[float]$size = $dbsize.Length /1024/1024 
	$dbname = $db.name

	$returnedObj = new-object PSObject
	$returnedObj | add-member NoteProperty -name "Database" -value $dbname
	$returnedObj | add-member NoteProperty -name "Size (Mb)" -value $size
	$returnedObj | Add-Member NoteProperty -Name "Mailboxes" -Value $mbcount
	$returnedObj
}