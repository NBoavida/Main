#############
# Variables #
#############
$date=get-date

##################
# Mail variables #
##################
$smtpServer = "smtp.fidelidademundial.com" 
$mailfrom1 = "SPF4764FLS01 Mirror de DFS <SPF4764FLS01@Fm.com>"
$mailfromtsk = "SPF4764FLS01 Mirror de DFS task <SPF4764FLS01@Fm.com>"
$mailfromfim = "SPF4764FLS01 Mirror de DFS Finalizada <SPF4764FLS01@Fm.com>"
$mailto = "frederico.franco.frazao@cgd.pt"
#$mailto = "GDLSSIL-ASA4-USA44-PCS-SDM@GrupoCGD.com"



$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $MailFrom1 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Mirror de DFS iniciada $date" 
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
$msg.Subject = "spf4764fls01 Task Mapeamento FS " 
$msg.Body = "Mapeamento de Fileshares " 
$smtp.Send($msg)

net use k: \\SPF4764FLS01\k$
net use o: \\SPF4764FLS01\o$


###########################
# Robotcopy 1st run #
###########################

$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From = $mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Mirror de DFS, Robocopy 1st run started  " 
$msg.Body = "" 
$smtp.Send($msg)

robocopy K:\CLHPDir_IIICXS\DAP  O:\CLHPDir_VCXS\DAP /MIR /SEC /log:o:\dap.txt
robocopy K:\CLHPDir_IIICXS\DCB	O:\CLHPDir_VCXS\DCB /MIR /SEC /log:o:\dcb.txt
robocopy K:\CLHPDir_IIICXS\DCC	O:\CLHPDir_VCXS\DCC /MIR /SEC /log:o:\dcc.txt	
robocopy K:\CLHPDir_IIICXS\DIN	O:\CLHPDir_VCXS\DIN /MIR /SEC /log:o:\din.txt	
robocopy K:\CLHPDir_IIICXS\FRM	O:\CLHPDir_VCXS\FRM /MIR /SEC  /log:o:\frm.txt
robocopy K:\CLHPDir_IIICXS\DRH	O:\CLHPDir_VCXS\DRH  /MIR /SEC /log:o:\dhr.txt


$msg = new-object Net.Mail.MailMessage  
$smtp = new-object Net.Mail.SmtpClient($smtpServer)  
$msg.From =$mailfromtsk 
$msg.IsBodyHTML = $true 
$msg.To.Add($Mailto)  
$msg.Subject = "spf4764fls01 Mirror de DFS, Robocopy 1st run finnish " 
$msg.Body = "" 
$smtp.Send($msg)