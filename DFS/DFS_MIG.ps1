
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
#$mailto = "frederico.franco.frazao@cgd.pt"
$mailto = "GDLSSIL-ASA4-USA44-PCS-SDM@GrupoCGD.com"



$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $MailFrom1 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS iniciada" 
$msg.Body = $MailTextT 
$smtp.Send($msg)


###########################
# Mapeamento de Fileshares #
###########################



$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS Task Mapeamento FS " 
$msg.Body = "Mapeamento de Fileshares " 
$smtp.Send($msg)

net use k: \\SPF4764FLS01\k$
net use o: \\SPF4764FLS01\o$



############
# DFS tasks#
############

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS,DFS Tasks Enable\Disable" 
$msg.Body = "" 
$smtp.Send($msg)


Write-Host "DFS LINKS" -BackgroundColor Red -ForegroundColor DarkYellow
#DRH-Aplicacoes
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Aplicacoes" -TargetPath "\\SPF4764FLS01\CLHPDir_VCXS\DRH\DRH-Aplicacoes" -State Online
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Aplicacoes" -TargetPath "\\SPF4764FLS01\CLHPDir_IIICXS\DRH\DRH-Aplicacoes" -State Offline

#DRH-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DRH\DRH-CLHP" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-CLHP " -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DRH\DRH-CLHP" -State Online

#DRH-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DRH\DRH-Comum" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DRH\DRH-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DRH\DRH-Comum" -State Online

#DAP-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DAP\DAP-Aplicacoes" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DAP\DAP-Aplicacoes" -State Online

#DAP-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DAP\DAP-CLHP" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DAP\DAP-CLHP" -State Online

#DAP-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DAP\DAP-Comum" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DAP\DAP-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DAP\DAP-Comum" -State Online

#DCB-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\dcb\DCB-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DCB\DCB-Aplicacoes" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\dcb\DCB-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DCB\DCB-Aplicacoes" -State Online

#DCB-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DCB\DCB-CLHP" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DCB\DCB-CLHP" -State Online

#DCB-Comum 
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DCB\DCB-Comum" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCB\DCB-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DCB\DCB-Comum" -State Online

#DCC-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCC\DCC-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\dcc\DCC-Aplicacoes" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCc\DCC-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\dcc\DCC-Aplicacoes" -State Online

#DCC-LCHD
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCC\DCC-LCHD" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\dcc\DCC-LCHD" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCc\DCC-LCHD" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\dcc\DCC-LCHD" -State Online

#DCC-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCC\DCC-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\dcc\DCC-Comum" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DCc\DCC-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\dcc\DCC-Comum" -State Online

#DIN-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DIN\DIN-Aplicacoes" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DIN\DIN-Aplicacoes" -State Online

#DIN
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DIN\DIN" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DIN\DIN" -State Online

#DIN-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\DIN\DIN-Comum" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\DIN\DIN-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\DIN\DIN-Comum" -State Online

#FRM-Aplicações
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\FRM\FRM-Aplicacoes" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Aplicacoes" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\FRM\FRM-Aplicacoes" -State Online

#FRM-CLHP
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\FRM\FRM-CLHP" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-CLHP" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\FRM\FRM-CLHP\FRM-CLHP" -State Online

#FRM-Comum
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Comum" -TargetPath "\\spf4764fls01\CLHPDir_IIICXS\FRM\FRM-Comum" -State Offline
Set-DfsnFolderTarget -Path "\\fidelidademundial.com\FRM\FRM-Comum" -TargetPath "\\spf4764fls01\CLHPDir_VCXS\FRM\FRM-CLHP\FRM-Comum" -State Online



#############################################
# Restart FLS para Libertar sessões activas #
############################################

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS, Restart spf4764fls01 Iniciaado" 
$msg.Body = "" 
$smtp.Send($msg)


Write-Host "Restart" -BackgroundColor Red -ForegroundColor DarkYellow

Restart-Computer -ComputerName spf4764fls01 -Force -Wait -For PowerShell  


Write-Host "Online" -BackgroundColor Green -ForegroundColor DarkYellow

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS, spf4764fls01, online " 
$msg.Body = "" 
$smtp.Send($msg)

###########################
# Robotcopy final run #
###########################

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS, Robocopy final run started $date" 
$msg.Body = "" 
$smtp.Send($msg)

Write-Host "DAP" -BackgroundColor Red -ForegroundColor DarkYellow

robocopy K:\CLHPDir_IIICXS\DAP  O:\CLHPDir_VCXS\DAP /MIR /SEC /log:o:\dap_final.txt

Write-Host "DCB" -BackgroundColor Red -ForegroundColor DarkYellow

robocopy K:\CLHPDir_IIICXS\DCB	O:\CLHPDir_VCXS\DCB /MIR /SEC /log:o:\dcb_final.txt
Write-Host "DCC" -BackgroundColor Red -ForegroundColor DarkYellow

robocopy K:\CLHPDir_IIICXS\DCC	O:\CLHPDir_VCXS\DCC /MIR /SEC /log:o:\dcc_final.txt
Write-Host "DIN" -BackgroundColor Red -ForegroundColor DarkYellow
	
robocopy K:\CLHPDir_IIICXS\DIN	O:\CLHPDir_VCXS\DIN /MIR /SEC /log:o:\din_final.txt	
Write-Host "FRN" -BackgroundColor Red -ForegroundColor DarkYellow

robocopy K:\CLHPDir_IIICXS\FRM	O:\CLHPDir_VCXS\FRM /MIR /SEC  /log:o:\frm_final.txt
Write-Host "DRH" -BackgroundColor Red -ForegroundColor DarkYellow

robocopy K:\CLHPDir_IIICXS\DRH	O:\CLHPDir_VCXS\DRH  /MIR /SEC /log:o:\dhr_final.txt



$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS, Robocopy final run Finnish $date" 
$msg.Body = "" 
$smtp.Send($msg)

###########################
# Final Send Mail#
###########################


$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $MailFromFim
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Migração de DFS Concluida $date" 
$msg.Body = $MailTextT 
$smtp.Send($msg)