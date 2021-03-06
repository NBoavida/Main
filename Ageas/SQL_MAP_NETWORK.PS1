########################################
#
# 
#    SQL Backups Map Network Drive
#
#
#######################################

net use g: /del
net use R: /del
net use d: /del
net use L: /del
net use F: /del
net use o: /del

#10.90.151.35
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("g:", "\\10.90.151.35\d$", $false, "bcpcorp.dev\D333867", "!!!!!!!!!!!!!!!!!9")


#10.90.151.34
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("r:", "\\10.90.151.34\e$", $false, "bcpcorp.dev\D333867", "!!!!!!!!!!!!!!!!!9")


#172.16.120.126
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("L:", "\\172.16.120.126\e$", $false, "bcpcorp.dev\D333867", "!!!!!!!!!!!!!!!!!9")


#DOIT
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("D:", "\\setpsftvip01\DOIT", $false, "bcpcorp.dev\D333867", "!!!!!!!!!!!!!!!!!9")

#172.16.120.124
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("F:", "\\172.16.120.124\F$", $false, "bcpcorp.dev\D333867", "!!!!!!!!!!!!!!!!!9")

#172.16.120.141
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("o:", "\\172.16.120.141\f$", $false, "bcpcorp.dev\D333867", "!!!!!!!!!!!!!!!!!9")

#Validação
test-Path -path "filesystem::F:\" #142,32 GB
test-Path -path "filesystem::o:\" #42,19 GB
test-Path -path "filesystem::D:\" #189,61 GB
test-Path -path "filesystem::L:\" #208,15 GB
test-Path -path "filesystem::R:\" #18,47 GB
test-Path -path "filesystem::G:\" #78,03 GB

Get-PSDrive -PSProvider filesystem 