# ========================================================================
# 
# Nome: Weeklely_SQL_BACKUPS_TO_DOIT.ps1
# 
# Frederico Frazão
#  
# To be Runned every Friday
#
# Comments:  
#  - Copy Backups from Phisical SQL Server to DOIT File Share
#  - Clean Up Outdated Backups files from Doit File Share 
# ========================================================================

#Settings for 10.90.151.35

$35INST05 = get-Item \\10.90.151.35\d$\SQL_BACKUPS\INST08\*.bak | where-object {$_.LastWriteTime.Date -eq (get-date).adddays(-0).Date}
$35INST08 = get-Item \\10.90.151.35\d$\SQL_BACKUPS\INST05\*.bak | where-object {$_.LastWriteTime.Date -eq (get-date).adddays(-0).Date}

#Settings for 10.90.151.34
$34INST05 = get-Item \\10.90.151.34\e$\INST05\*.bak | where-object {$_.LastWriteTime.Date -eq (get-date).adddays(-0).Date}
$34INST08 = get-Item \\10.90.151.34\e$\INST08R2\*.bak | where-object {$_.LastWriteTime.Date -eq (get-date).adddays(-0).Date}

#Settings for DOIT Backup File Share
$35INST05doit ="\\setpsftvip01\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.35\INST05\"
$35INST08doit = "\\setpsftvip01\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.35\INST08\"
$34INST05doit =  "\\setpsftvip01.bcpcorp.dev\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.34\INST05\"
$34INST08doit = "\\setpsftvip01.bcpcorp.dev\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.34\INST08\"

#Start Copy backups to File Share
Copy-Item $35INST05 $35INST05doit
Copy-Item $35INST08 $35INST08doit
Copy-Item $34INST05 $34INST05doit
Copy-Item $34INST08 $34INST08doit

#Settings outdated Backups from Doit File Share
$Doit35Inst05 = get-Item \\setpsftvip01\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.35\INST05\*.bak | where-object {$_.LastWriteTime.Date -ne (get-date).adddays(-0).Date}
$Doit35Inst08 = get-Item \\setpsftvip01\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.35\INST08\*.bak | where-object {$_.LastWriteTime.Date -ne (get-date).adddays(-0).Date}
$Doit34Inst05 = get-Item \\setpsftvip01.bcpcorp.dev\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.34\INST05\*.bak | where-object {$_.LastWriteTime.Date -ne (get-date).adddays(-0).Date}
$Doit34Inst08 = get-Item \\setpsftvip01.bcpcorp.dev\DOIT\Backups\Bds\SQL_BACKUPS\10.90.151.34\INST08\*.bak | where-object {$_.LastWriteTime.Date -ne (get-date).adddays(-0).Date}

#Delete outdated Backups from Doit File Share
Remove-item $Doit35Inst05
Remove-item $Doit35Inst08
Remove-item $Doit34Inst05
Remove-item $Doit34Inst08