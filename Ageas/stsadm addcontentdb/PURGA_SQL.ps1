###########################################################################
#
# NAME: Purga old backups
#
# AUTHOR:  Frederico Frazão 
#
# COMMENT: 
#
# VERSION HISTORY:
# 1.0 4/15/2012 - Initial release
# 1.1 07/09/2012 - Adicionar SQL Backups Paths
###########################################################################

#region Data settings
$Now = Get-Date  
$Days = "2" 
$Extension = "*.bak" 
$LastWrite = $Now.AddDays(-$Days) 
#endregion

#region #----- SQL 10.90.151.34 INST05 -----# 
$SQL3405 = "\\10.90.151.34\e$\INST05\" 
$Files3405 = Get-Childitem $SQL3405 -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
foreach ($File in $Files3405) 
    {
    if ($File -ne $NULL)
        {
        write-host "Deleting File $File" -ForegroundColor "DarkRed"
        Remove-Item $File.FullName | out-null
        }
    else
        {
        Write-Host "10.90.151.34\e$\INST05 Folder Up to Date!" -foregroundcolor "Green"
        }
    }
#endregion

#region #----- SQL 10.90.151.34 INST08 -----# 
$SQL3408 = "\\10.90.151.34\e$\INST08R2\" 
$Files3408 = Get-Childitem $SQL3408 -Include $Extension -Recurse | Where {$_.LastWriteTime -le "$LastWrite"}
foreach ($File in $Files3408) 
    {
    if ($File -ne $NULL)
        {
        write-host "Deleting File $File" -ForegroundColor "DarkRed"
        Remove-Item $File.FullName | out-null
        }
    else
        {
        Write-Host "10.90.151.34\e$\INST08r2 Folder Up to Date!" -foregroundcolor "Green"
        }
    }
#endregion
