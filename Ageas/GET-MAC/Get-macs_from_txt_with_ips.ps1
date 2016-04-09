	$strservers = 'C:\Servidores.txt'

$Servers = Get-Content $strservers

$log = 'c:\log.txt'

foreach ($Server in $Servers)
{
    nbtstat -a $Server >> $log
} 

start $log
	