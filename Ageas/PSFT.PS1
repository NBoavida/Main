$psft = get-Item \\setp11irmt01\Interfaces\BSG\PSFT\B0033\SACH.NTService.Output\NoProtocol\VCHB0033S1024*.txt  | where-object {$_.LastWriteTime.Date -eq (get-date).adddays(-2).Date}
$XMLPATH = "\\172.16.120.128\Interfaces\BSG\PSFT_TST\S1024\VCH\IN"
copy-item $psft $XMLPATH
-EXECUÇÂO MANUAL 
$ai = \\Setp11iapl54.bcpcorp.net\Interfaces\BSG\PSFT\AI
Copy-Item \\tsclient\T\*  $ai
