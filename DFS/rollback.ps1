
#############
# Variables #
#############
$date=get-date

##################
# Mail variables #
##################
$smtpServer = "smtp.fidelidademundial.com" 
$mailfrom1 = "SPF4764FLS01 Migração de DFS <SPF4764FLS01@Fm.com>"
$mailfromtsk = "SPF4764FLS01 Migração de DFS task <SPF4764FLS01@Fm.com>"
$mailfromfim = "SPF4764FLS01 Migração de DFS Finalizada <SPF4764FLS01@Fm.com>"
$mailto = "frederico.franco.frazao@cgd.pt"

############
# DFS tasks#
############

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Start Roolback " 
$msg.Body = "" 
$smtp.Send($msg)


#DRH-Aplicacoes
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Aplicacoes" -TargetPath "\\SPF4764FLS01\CLHPDir_VCXS\DRH\DRH-Aplicacoes" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Aplicacoes" -TargetPath "\\SPF4764FLS01\CLHPDir_IIICXS\DRH\DRH-Aplicacoes" -State Online

#DRH-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DRH\DRH-CLHP" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-CLHP " -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DRH\DRH-CLHP" -State Offline

#DRH-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DRH\DRH-Comum" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DRH\DRH-Comum" -State Offline

#DAP-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DAP\DAP-Aplicacoes" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DAP\DAP-Aplicacoes" -State Offline

#DAP-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DAP\DAP-CLHP" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DAP\DAP-CLHP" -State Offline

#DAP-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DAP\DAP-Comum" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DAP\DAP-Comum" -State Offline

#DCB-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\dcb\DCB-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DCB\DCB-Aplicacoes" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\dcb\DCB-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DCB\DCB-Aplicacoes" -State Offline

#DCB-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DCB\DCB-CLHP" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DCB\DCB-CLHP" -State Offline

#DCB-Comum 
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DCB\DCB-Comum" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DCB\DCB-Comum" -State Offline

#DCC-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCC\DCC-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\dcc\DCC-Aplicacoes" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCc\DCC-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\dcc\DCC-Aplicacoes" -State Offline

#DCC-LCHD
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCC\DCC-LCHD" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\dcc\DCC-LCHD" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCc\DCC-LCHD" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\dcc\DCC-LCHD" -State Offline

#DCC-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCC\DCC-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\dcc\DCC-Comum" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCc\DCC-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\dcc\DCC-Comum" -State Offline

#DIN-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DIN\DIN-Aplicacoes" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DIN\DIN-Aplicacoes" -State Offline

#DIN
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DIN\DIN" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DIN\DIN" -State Offline

#DIN-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DIN\DIN-Comum" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DIN\DIN-Comum" -State Offline

#FRM-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\FRM\FRM-Aplicacoes" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\FRM\FRM-Aplicacoes" -State Offline

#FRM-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\FRM\FRM-CLHP" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\FRM\FRM-CLHP\FRM-CLHP" -State Offline

#FRM-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\FRM\FRM-Comum" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\FRM\FRM-CLHP\FRM-Comum" -State Offline



#############################################
# Restart FLS para Libertar sessões activas #
############################################

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Rollback efectuado" 
$msg.Body = "" 
$smtp.Send($msg)

Restart-Computer -ComputerName spf4764fls01 -Force -Wait -For PowerShell  


$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Restarted spf4764fls01 " 
$msg.Body = "" 
$smtp.Send($msg)