#requires -version 2
<#
Valida se a Drive existe, caso não exista será mapeada
- Drive F: Share Backups DOIT setpsfVIp01 
- Drive Y: 10.90.151.35
- Drive M: 10.90.151.34
- Drive W: Cloud 1
- Drive T: Could 2
- Drive V: Source Safe
- Drive L: DEPLOY
- Drive X: BsgWebServices \ BSGconnectors
Presentation
Logdir Web services
LogDir Presentation

#>

#Log Dir + logfile
$logdir = "c:\scripts\logs\"
new-item -type directory -path $logdir -ErrorAction SilentlyContinue 
$logfile = "c:\scripts\logs\NetWorkMap_log.txt"
new-item -path $logfile -type file  -ErrorAction SilentlyContinue 
mkdir $logdir -ErrorAction SilentlyContinue 
get-date | out-file $logfile -append

#Variaveis das drives a mapear
$F_drive, $y_drive, $m_drive, $l_drive, $w_drive, $v_drive, $t_drive, $X_drive = "f:", "Y", "M","L", "W", "V", "T", "X"

#Drive F, Validação e mapeamento
$Valida_F = Test-Path $F_drive -IsValid
If ($Valida_F -eq $True) {
Write-Host "Drive $f_drive em Uso."  | out-file $logfile -append
echo "Drive $f_drive em Uso."  | out-file $logfile -append
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("f:", "\\127.0.0.1\c$" ) #Share Doit
Write-Host "Drive $F_drive foi Mapeada #Share Doit" | out-file $logfile -append
Write-Host "Drive $f_drive foi Mapeada #Share Doit"  | out-file $logfile -append}
#fim drive F

Start-Sleep -Milliseconds 3

#Drive y Validação e mapeamento 
$Valida_Y = Test-Path $y_drive -IsValid
If ($Valida_Y -eq $True) {
Write-Host "Drive $y_drive em Uso #Share Doit" | out-file $logfile -append
echo  "Drive $y_drive em Uso #Share Doit" | out-file $logfile -append
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("Y:", "\\127.0.0.1\c$" ) #Share SQL bck 10.90.151.35
Write-Host "Drive $y_drive foi Mapeada #Share SQL bck 10.90.151.35" | out-file $logfile -append
echo "Drive $y_drive foi Mapeada #Share SQL bck 10.90.151.35" | out-file $logfile -append}
#fim drive y

Start-Sleep -Milliseconds 3

#Drive M, Validação e mapeamento
$Valida_M = Test-Path $M_drive -IsValid
If ($Valida_M -eq $True) {
Write-Host "Drive $M_drive em Uso #Share SQL 10..90.151.34."  | out-file $logfile -append
echo  "Drive $M_drive em Uso.#Share SQL 10..90.151.34"  | out-file $logfile -append
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("M:", "\\127.0.0.1\c$" ) #Share SQL 10..90.151.34
Write-Host "Drive $M_drive foi Mapeada #Share SQL 10..90.151.34 " | out-file $logfile -append
echo "Drive $M_drive foi Mapeada #Share SQL 10..90.151.34 " | out-file $logfile -append}
#fim drive M
Start-Sleep -Milliseconds 3
#Drive W, Validação e mapeamento
$Valida_W = Test-Path $W_drive -IsValid
If ($Valida_W -eq $True) {
Write-Host "Drive $W_drive em Uso. #Share sql cloud I" | out-file $logfile -append 
Echo  "Drive $W_drive em Uso. #Share sql cloud I" | out-file $logfile -append 
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("W:", "\\127.0.0.1\c$" ) #Share sql cloud I
Write-Host "Drive $W_drive foi Mapeada #Share sql cloud I"| out-file $logfile -append
echo "Drive $W_drive foi Mapeada #Share sql cloud I"| out-file $logfile -append}
#fim drive W
Start-Sleep -Milliseconds 3

#Drive T, Validação e mapeamento
$Valida_T = Test-Path $T_drive -IsValid
If ($Valida_T -eq $True) {
Write-Host "Drive $T_drive em Uso." | out-file $logfile -append
echo "Drive $T_drive em Uso." | out-file $logfile -append  
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("T:", "\\127.0.0.1\c$" ) #Share sql cloud II
Write-Host "Drive $T_drive foi Mapeada " | out-file $logfile -append
Echo "Drive $T_drive foi Mapeada " | out-file $logfile -append}
#fim drive T
Start-Sleep -Milliseconds 3
#Drive V, Validação e mapeamento
$Valida_V = Test-Path $V_drive -IsValid
If ($Valida_V -eq $True) {
Write-Host "Drive $V_drive em Uso."| out-file $logfile -append 
Echo "Drive $V_drive em Uso."| out-file $logfile -append 
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("V:", "\\127.0.0.1\c$" ) #Share VSS
Write-Host "Drive $V_drive foi Mapeada "| out-file $logfile -append
echo "Drive $V_drive foi Mapeada "| out-file $logfile -append}
#fim drive V

#Drive L, Validação e mapeamento
$Valida_L = Test-Path $L_drive -IsValid
If ($Valida_L -eq $True) {
Write-Host "Drive $L_drive em Uso."| out-file $logfile -append 
echo "Drive $L_drive em Uso."| out-file $logfile -append 
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("L:", "\\127.0.0.1\c$" ) #Share Deploy
Write-Host "Drive $L_drive foi Mapeada "| out-file $logfile -append
echo  "Drive $L_drive foi Mapeada "| out-file $logfile -append
}
#fim drive L



#Drive X, Validação e mapeamento BsgWebServices \ BSGconnectors
$Valida_X = Test-Path $X_drive -IsValid
If ($Valida_X -eq $True) {
Write-Host "Drive $X_drive em Uso. BsgWebServices \ BSGconnectors"| out-file $logfile -append 
echo "Drive $X_drive em Uso. BsgWebServices \ BSGconnectors"| out-file $logfile -append 
}
Else {
$objNet = New-Object -ComObject WScript.Network 
$objNet.MapNetworkDrive("X:", "\\127.0.0.1\c$" ) #Share Deploy
Write-Host "Drive $X_drive foi Mapeada BsgWebServices \ BSGconnectors"| out-file $logfile -append
echo  "Drive $X_drive foi Mapeada BsgWebServices \ BSGconnectors"| out-file $logfile -append
}
#fim drive X
