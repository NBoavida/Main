#SQLjobs Load Plug-ins
add-pssnapin sqlserverprovidersnapin100
add-pssnapin sqlservercmdletsnapin100 
Write-host SQLjobs Plug-ins loadead 


# Variaveis dos Jobs 

#BACKUP @ 34 INST08
$34INST08 = Invoke-SQLcmd -Server ‘10.90.151.34\inst08r2' -Database MSDB "exec sp_start_job N'MaintenancePlan'”
#SQL BACKUPs @ 34 INST05
$34INST05 = Invoke-SQLcmd -Server ‘10.90.151.34\inst05' -Database MSDB "exec sp_start_job N'MaintenancePlan'”
#SQL BACKUPs @ 35 INST08
$35INST08 = Invoke-SQLcmd -Server ‘10.90.151.35\inst08' -Database MSDB "exec sp_start_job N'MaintenancePlan_INST08'”
#SQL BACKUPs @ 35 INST05
$35INST05 = Invoke-SQLcmd -Server ‘10.90.151.35\inst08' -Database MSDB "exec sp_start_job N'MaintenancePlan_INST05'”
#172.16.120.124\INST08r2
$24INST08 = Invoke-SQLcmd -Server ‘172.16.120.124\INST08r2' -Database MSDB "exec sp_start_job N'MaintenancePlan'”
#172.16.120.126\INST08r2
$26INST08 = Invoke-SQLcmd -Server ‘172.16.120.126\INST08r2' -Database MSDB "exec sp_start_job N'MaintenancePlan'”
#172.16.120.126\TFS08r2
$26TFS = Invoke-SQLcmd -Server ‘172.16.120.126\TFS08r2' -Database MSDB "exec sp_start_job N'MaintenancePlan'”

#Inicio de Jobs 
Write-host Inicio Job 10.90.151.35\INST08
$35INST08
Write-host FIM Job 10.90.151.35\INST08
Write-host Inicio Job 10.90.151.35\INST05
$35INST05
Write-host FIM Job 10.90.151.35\INST05
Write-host Inicio Job 10.90.151.34\INST08
$34INST08
Write-host FIM Job 10.90.151.34\INST08
Write-host Inicio Job 172.16.120.126\TFS08r2
$26TFS
Write-host FIM Job 172.16.120.126\TFS08r2
Write-host Inicio Job 172.16.120.126\INST08
$26INST08 
Write-host  FIM Job 172.16.120.126\INST08
Write-host Inicio Job 172.16.120.124\INST08
$24INST08
Write-host FIM Job   172.16.120.124\INST08
Write-host Inicio Job 10.90.151.34\INST05
$34INST05
Write-host FIM Job 10.90.151.34\INST05