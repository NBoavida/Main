###########################################################################
#
# NAME: KAMAE Execução de Scripts de Migração 
#
# COMMENT: executa os novos Scrips
# 
# VERSION HISTORY:
#   1.0 20131706 - Frederico Frazão
#
# Kamae Current Version: 3.5.0.10
#
###########################################################################

Write-Host = 'efectuar Backup Primeiro'
$a = new-object -comobject wscript.shell
$b = $a.popup(" Os Backups from  Efectuados as base de dados ? de certeza que deseja continuar? ",0,"Kamae Current Version: 3.5.0.10",1)

#Adicionar a snap in do sqlcmd
Add-PSSnapin SqlServerCmdletSnapin100

# Configuração de Servidor e  Instancia 
$INT =  "10.90.151.47\inst08r2"
$PROD = "172.16.120.141\inst08r2"
$DEV = "172.16.120.126\inst08r2"


# Scripts path 
$Scriptpath = "X:\DATA"

#Configura BD's 
$KAl = "KAlerts"
$002 ="KamaeGest002"
$master = "KamaeGestMaster"
$SI ="KamaeSI"
$01 = "KSI01"

#Configura Logfile 
$Log = 'kame_Migration'
$Logfile = "X:\DATA\kame_Migration.rpt"


###############
# backups de BD 
###############

# Exemplo de Scripts a serem executados : 
#KAlerts
#invoke-sqlcmd -inputfile $Scriptpath\file.sql -serverinstance $INT -database $KAl | Out-File -filePath  $Logfile  
#invoke-sqlcmd -inputfile $Scriptpath\file2.sql -serverinstance $INT -database $KAl | Out-File -filePath  $Logfile -append

$fileskal = Get-Content X:\DATA\kamae.txt
Add-PSSnapin SqlServerCmdletSnapin100 #Adicionar a snap in do sqlcmd
$INT =  "10.90.151.47\inst08r2" # Configuração de Servidor e  Instancia 
$Scriptpath = "X:\DATA\" # Scripts path 
$KAl = "KAlerts" #Configura BD's 



ForEach ($f in $files ) { invoke-sqlcmd -inputfile $f -serverinstance $INT -database $KAl | Out-File -filePath  $Logfile }

#KamaeGest002
#invoke-sqlcmd -inputfile $Scriptpath\file.sql -serverinstance $INT -database $002 | Out-File -filePath  $Logfile  -append
#invoke-sqlcmd -inputfile $Scriptpath\file2.sql -serverinstance $INT -database $002 | Out-File -filePath  $Logfile -append

#KamaeGestMaster
#invoke-sqlcmd -inputfile $Scriptpath\file.sql -serverinstance $INT -database $master | Out-File -filePath  $Logfile  -append
#invoke-sqlcmd -inputfile $Scriptpath\file2.sql -serverinstance $INT -database $master | Out-File -filePath  $Logfile -append

#KamaeSI
#invoke-sqlcmd -inputfile $Scriptpath\file.sql -serverinstance $INT -database $SI | Out-File -filePath  $Logfile  -append
#invoke-sqlcmd -inputfile $Scriptpath\file2.sql -serverinstance $INT -database $SI | Out-File -filePath  $Logfile -append

#KSI01
#invoke-sqlcmd -inputfile $Scriptpath\file.sql -serverinstance $INT -database $01 | Out-File -filePath  $Logfile  -append
#invoke-sqlcmd -inputfile $Scriptpath\file2.sql -serverinstance $INT -database $01 | Out-File -filePath  $Logfile -append


