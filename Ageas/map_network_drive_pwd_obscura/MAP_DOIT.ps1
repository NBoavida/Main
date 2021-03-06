#+-------------------------------------------------------------------+    
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |    
#|{>/-------------------------------------------------------------\<}|             
#|: | Author:  Frederico Frazão                                   | :|             
#| :|   
#|: | Purpose: Map DOIT NetWork Drives
#+-------------------------------------------------------------------+    
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |    
#|{>/-------------------------------------------------------------\<}|             
#: |
#: |      SERVER LIST
#: |
#: | SQL Servers
net use e: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("E:", "\\10.90.151.34\d$")
net use F: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("F:", "\\10.90.151.34\e$")
net use H: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("H:", "\\10.90.151.35\d$")
net use G: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("G:", "\\10.90.151.35\c$")
net use I: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("I:", "\\172.16.120.126\d$")
net use J: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("J:", "\\172.16.120.124\c$\Program Files\Microsoft SQL Server\MSSQL10_50.INST08R2\MSSQL\DATA")
#: |
#: | DATA_TRAF
net use K: /del 
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("K:", "\\setpsftvip01\DOIT")
net use L: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("L:", "\\setpsftvip01\Transf")
net use M: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("M:", "\\172.16.120.128\VSS")
Net use N: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("N:", "\\172.16.120.124\Interfaces")
#: | NAS
Net use O: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("O:", "\\10.90.151.112\backups", $false, "10.90.151.112\doit", "d01t")
net use P: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("P:", "\\10.90.151.112\software", $false, "10.90.151.112\doit", "d01t")
net use Q: /del
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("Q:", "\\10.90.151.30\Public", $false, "10.90.151.30\admin", "w2k_upd")
net use R: /del 
$net = new-object -ComObject WScript.Network
$net.MapNetworkDrive("R:", "\\10.90.151.30\Software", $false, "10.90.151.30\admin", "w2k_upd")
#: | S
#: | T
#: | U
#: | W
#: | X
#: | Y
#: | Z
#: | 
#: | 