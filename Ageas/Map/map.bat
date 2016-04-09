cho ************************************************ >> %backuplog%\MAP_Network.TXT
Echo ************************************************ >> %backuplog%\MAP_Network.TXT
Echo Map network Started %DATE% %Time% >> %backuplog%\MAP_Network.TXT
Echo ************************************************ >> %backuplog%\MAP_Network.TXT
REM 	SQL 10.90.151.34
Echo SQL net use i:\\10.90.151.34\e$  %DATE% %Time% >> %backuplog%\MAP_Network.TXT
net use i: /DELETE /Y  
net use i: \\10.90.151.34\e$

REM SQL 10.90.151.35
Echo SQL net use i:\\10.90.151.35\e$  %DATE% %Time% >> %backuplog%\MAP_Network.TXT
net use J: /DELETE /Y 
net use J: \\10.90.151.35\e$


REM Share Doit  setpsftvip01\DOIT
Echo DOIT SHARE net use V: \\setpsftvip01\DOIT  %DATE% %Time% >> %backuplog%\MAP_Network.TXT
net use V: /DELETE /Y 
net use V: \\setpsftvip01\DOIT 


REM Interfaces + Deploy + vss
Echo 10.90.150.7 Interfaces + Deploy + vss  %DATE% %Time% >> %backuplog%\MAP_Network.TXT
net use U: /DELETE /Y 
net use U: \\10.90.150.7\c$


REM VSS \\10.90.150.6\
Echo 10.90.150.6  vss  %DATE% %Time% >> %backuplog%\MAP_Network.TXT
net use Z: /DELETE /Y 
net use Z: \\10.90.150.6\d /USER:administrator w2k_upd

REM baclups @ 10.90.151.112
net use X: /DELETE /Y
net use x: \\10.90.151.112\backups /User:localhost\admin w2k_upd


REM baclups @ 10.90.151.113
net use S: /DELETE /Y
net use S: \\10.90.151.113\backups

REM VSS @ 10.90.151.91
REM VSSMedisSaude - VSSICI - - « -  - VSS_BROKER  - 
net use L: /DELETE /Y
net use L: \\10.90.151.91\vss 
Echo ******************************