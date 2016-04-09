###########################################################################
#
# NAME: DOIT Purga BCK from FS DOIT
#
# AUTHOR:  Frederico Frazão
#
# COMMENT:  Elemina backups com mais de 2 dias e envia o report
#
# VERSION HISTORY:
# 1.0 20130401 - Initial release
#
#
###########################################################################

#region Histórico de Backups
$Now = Get-Date  
$Days = "5" 
$Extension = "*.bak" 
$LastWrite = $Now.AddDays(-$Days) 
#endregion

#Region Log Dir + logfile
$logdir = "B:\Reports\"
new-item -type directory -path $logdir -ErrorAction SilentlyContinue 
$logfile = "B:\Reports\CleanUp_DOIT_log.txt"
new-item -path $logfile -type file  -ErrorAction SilentlyContinue 
mkdir $logdir -ErrorAction SilentlyContinue 
get-date | out-file $logfile 
#endregion


#region #Backups Share DOIT# 
echo "--------------------------------------------------------------------------"  | out-file $logfile -append
echo "Listagem de Backups Eleminados"  | out-file $logfile -append
echo "--------------------------------------------------------------------------"  | out-file $logfile -append

$SQL3405 = "B:\" 
$Files3405 = Get-Childitem $SQL3405 -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
foreach ($File in $Files3405) 
    {
    if ($File -ne $NULL)
        {
        write-host "Deleting File $File" -ForegroundColor "DarkRed"

echo "Deleting File $File"  | out-file $logfile -append
       Remove-Item $File.FullName | out-null
        }
    else
        {
        Write-Host "Backups Up to Date!!" -foregroundcolor "Green"
	echo "Backups Up to Date!!"  | out-file $logfile -append
        }
    }
#endregion

#region Listagem de backups "Guardados" 
echo "--------------------------------------------------------------------------"  | out-file $logfile -append
echo "Listagem de Backups Guardados"  | out-file $logfile -append
echo "--------------------------------------------------------------------------"  | out-file $logfile -append
Get-Childitem $SQL3405 -Include $Extension -Recurse | out-file $logfile -append

#endregion

