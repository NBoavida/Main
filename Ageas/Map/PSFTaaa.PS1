$psft = get-Item \\setp11irmt01\Interfaces\BSG\PSFT\B0033\SACH.NTService.Output\NoProtocol\VCHB0033S1024*.txt  | where-object {$_.LastWriteTime.Date -eq (get-date).adddays(-0).Date}
$XMLPATH = "\\tsclient\U"
copy-item $psft $XMLPATH
net use t: \\tsclient\U\
t:
./bsgAgau.RenameToXML.exe
###
#  - wake Operador 
# 
###
$ai = "\\Setp11iapl54.bcpcorp.net\Interfaces\BSG\PSFT\AI"
Copy-Item \\tsclient\T\*  $ai
