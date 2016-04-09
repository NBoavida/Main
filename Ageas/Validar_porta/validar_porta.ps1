$server = Read-Host 'IP ? '
$port = Read-Host 'porta? '
	
$socket = new-object Net.Sockets.TcpClient
$socket.Connect($server, $port)

if ($socket.Connected) {
$status = "Open"
$socket.Close()
}
else {
$status = "Not Open"
}

$server | Out-File validarporta.txt 
$port 	| Out-File validarporta.txt -Append
$status | Out-File validarporta.txt -Append
	
	invoke-Expression "notepad.exe validarporta.txt" 
	sleep 60
	Remove-Item validarporta.txt