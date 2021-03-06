
$log = 'C:\Purga\validar_area_passagens_path.txt'
$p1 = '\\setpsfifvs01.bcpcorp.net\NNormalizadas\DOIT-Passagens\'

Echo ' Validador de Full Paths Área de Passagens @ setpsfifvs01.bcpcorp.net '> $log

Get-date |Out-File $log -Append


echo AIA\PRODUCAO\_HIST\|Out-File $log -Append


Test-Path $p1\AIA\PRODUCAO\_HIST\ |Out-File $log -Append

echo  AIA\QUALIDADE\_HISt\ |Out-File $log -Append
Test-Path $p1\AIA\QUALIDADE\_HISt\ |Out-File $log -Append


Echo BNKS-IENGINE\_HISt |Out-File $log -Append
Test-Path $p1\BNKS-IENGINE\_HISt |Out-File $log -Append

echo BrokerSeguros\DRP\_hist  >> $log
Test-Path $p1\BrokerSeguros\DRP\_hist |Out-File $log -Append

echo BrokerSeguros\Producao\_zhist |Out-File $log -Append
Test-Path $p1\BrokerSeguros\Producao\_zhist |Out-File $log -Append

Echo BrokerSeguros\Qualidade\_Hist |Out-File $log -Append
Test-Path $p1\BrokerSeguros\Qualidade\_Hist | Out-File $log -Append

Echo  BSG\Producao\_hist | Out-File $log -Append
Test-Path  $p1\BSG\Producao\_hist |Out-File $log -Append

Echo BSG\Qualidade\_hist> | Out-File $log -Append
Test-Path $p1\BSG\Qualidade\_hist\ |Out-File $log -Append


ECHO Evolflow\Qualidade\_HIST |Out-File $log -Append
Test-Path  $p1\Evolflow\Qualidade\_HIST |Out-File $log -Append
ECHO Evolflow\Produção\_HIST |Out-File $log -Append
Test-Path  $p1\Evolflow\Produção\_HIST |Out-File $log -Append

ECHO Facets\Hist |Out-File $log -Append
Test-Path  $p1\Facets\Hist |Out-File $log -Append


#GIS-GA
ECHO GIS-GA\PRODUCAO\_HIST |Out-File $log -Append
Test-Path  $p1\GIS-GA\PRODUCAO\_HIST |Out-File $log -Append


#IP_Intranet
echo IP_Intranet\PRODUCAO\_HIST|Out-File $log -Append
Test-path  $p1\IP_Intranet\PRODUCAO\_HIST |Out-File $log -Append

ECHO IP_Intranet\QUALIDADE\_HIST |Out-File $log -Append
Test-PATH  $p1\IP_Intranet\QUALIDADE\_HIST |Out-File $log -Append


#IP_Mediators
ECHO IP_Mediators\PRODUCAO\_hist |Out-File $log -Append
Test-PATH  $p1\IP_Mediators\PRODUCAO\_hist |Out-File $log -Append

ECHO IP_Mediators\QUALIDADE\_hist |Out-File $log -Append
Test-PATH  $p1\IP_Mediators\QUALIDADE\_hist |Out-File $log -Append


#IP_medis
ECHO IP_Medis\Producao\_hist |Out-File $log -Append
Test-PATH  $p1\IP_Medis\Producao\_hist |Out-File $log -Append

ECHO IP_Medis\Qualidade\_hist |Out-File $log -Append
Test-PATH  $p1\IP_Medis\Qualidade\_hist |Out-File $log -Append


#IP_MSProviders
echo IP_MSProviders\Producao\_Historico |Out-File $log -Append
Test-PATH  $p1\IP_MSProviders\Producao\_Historico |Out-File $log -Append

ECHO IP_MSProviders\Qualidade\_Historico |Out-File $log -Append
Test-PATH  $p1\IP_MSProviders\Qualidade\_Historico |Out-File $log -Append

#Ip_ocidental
ECHO IP_Ocidental\Producao\_Hist |Out-File $log -Append
Test-PATH  $p1\IP_Ocidental\Producao\_Hist |Out-File $log -Append


ECHO IP_Ocidental\Qualidade\_History |Out-File $log -Append
Test-PATH  $p1\IP_Ocidental\Qualidade\_History |Out-File $log -Append

#IP_PSG
ECHO IP_PensoesGere\Producao\_Historico |Out-File $log -Append
Test-PATH  $p1\IP_PensoesGere\Producao\_Historico |Out-File $log -Append

ECHO IP_PensoesGere\Qualidade\_Historico |Out-File $log -Append
Test-PATH  $p1\IP_PensoesGere\Qualidade\_Historico |Out-File $log -Append

#Maaps
ECHO MAppS\Producao\Materiais\_hist |Out-File $log -Append
Test-PATH  $p1\MAppS\Producao\Materiais\_hist |Out-File $log -Append

ECHO MAppS\Qualidade\Materiais\_hist |Out-File $log -Append
Test-PATH  $p1\MAppS\Qualidade\Materiais\_hist |Out-File $log -Append

#Siebel
ECHO Siebel\Producao\_hist |Out-File $log -Append
Test-PATH  $p1\Siebel\Producao\_hist |Out-File $log -Append

ECHO Siebel\Qualidade\_hist |Out-File $log -Append

Test-PATH  $p1\Siebel\Qualidade\_hist |Out-File $log -Append



$emailbody = Get-Content C:\Purga\validar_area_passagens_path.txt



#region SendNotification
Add-PSSnapin Microsoft.Exchange.Management.Powershell.Admin -erroraction silentlyContinue
$batch_date = Get-Date
$file = "c:\Purga\validar_area_passagens_path.txt"
$smtpServer = "applsmtp.bcpcorp.dev"
$att = new-object Net.Mail.Attachment($file)
$msg = new-object Net.Mail.MailMessage
$smtp = new-object Net.Mail.SmtpClient($smtpServer)
$msg.From = "Path_validatorAreaPassagens@bcpcorp.dev"
$msg.To.Add("fredericofrazao.agap2@millenniumbcp.pt, joaomoreira.agap2@millenniumbcp.pt")
$msg.Subject = "[Path Validator] AreaPassagens Histórico $batch_date"
$msg.Body = $emailbody
$msg.Attachments.Add($att)
$smtp.Send($msg)
$att.Dispose()



