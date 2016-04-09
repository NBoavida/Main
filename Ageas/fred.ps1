###########################################################################
#
# NAME: Hyper-v Backup Report via SMTP
#
# AUTHOR:  Frederico Frazão 
#
# COMMENT: 
#
# VERSION HISTORY:
# 1.0 07/24/2012 - Initial release
# 1.1 20/09/2013 - Multi Att  
#
###########################################################################
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Admin -erroraction silentlyContinue
$batch_Date = (get-date).AddDays(-2).ToString("dd-mm-yyyy")
$file = "\\S3TP10-1a05.bcpcorp.dev\e$\Scripts\VMExport.log"
$file1 = "\\S3TP10-1a11.bcpcorp.dev\e$\bck_scripts\VMExport.log"
$file2 = "\\s3tp10-1a23.bcpcorp.dev\E$\Scripts\VMExport.log"
$file3 = "\\S3TP10-1A44.bcpcop.dev\Scripts\VMExport.log"
$smtpServer = "applsmtp.bcpcorp.dev"
$att = new-object Net.Mail.Attachment($file)
$att1 = new-object Net.Mail.Attachment($file1)
$att2 = new-object Net.Mail.Attachment($file2)
$att3 = new-object Net.Mail.Attachment($file3)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "Hyper-v@doit.dev"
$msg.To.Add("fredericofrazao.agap2@millenniumbcp.pt, x337973@bcpcorp.net, x030065@bcpcorp.net, x100465@bcpcorp.net")
$msg.Subject = "Hyper-V backups logs $batch_Date"
$msg.Body = "Hyper-V Export Log"
$msg.Attachments.Add($att)
$msg.Attachments.Add($att1)
$msg.Attachments.Add($att2)
$msg.Attachments.Add($att3)
$smtp.Send($msg)
$att.Dispose()